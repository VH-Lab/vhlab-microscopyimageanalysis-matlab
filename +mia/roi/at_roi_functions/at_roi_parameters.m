function ROIparameters = at_roi_parameters(atd,filename)
% AT_ROI_SIZES - for an ROI filename, return the ROI sizes
%
% ROIPARAMETERS = AT_ROI_SIZES(FILENAME)
%
% Returns a Matlab structure of the ROI sizes
%
% In addition, writes the data to a file called FILENAME_roiparameters.mat.
%
% Uses the parallel toolbox to speed up the calculation and reports subcalculations.
%

ROIparameters = [];

a = load(filename,'-mat');

disp(['About to calculate 2d projection']);
CC2 = ROI_3d_2dsummary(a.CC);

disp(['About to read in raw image']);

[parentdirname,itemfilename,ext] = fileparts(filename);
itemnamecutoff = strfind(itemfilename,'_ROI');
if isempty(itemnamecutoff),
	error(['Could not identiy ROI name.']);
end;


itemname = itemfilename(1:itemnamecutoff(end)-1);

[dummy,im_filename] = at_roi_underlying_image(atd,itemname);

image_info = imfinfo(im_filename);
IM = [];
for i=1:numel(image_info),
	IM = cat(3,IM,at_image_read(im_filename,i,'iminfo',image_info));
end;

disp(['About to calculate 3d properties..may take a few minutes']);
tic

rois_per_chunk = 100;
numchunks = ceil(a.CC.NumObjects/rois_per_chunk);

params3d = cell(numchunks,1);

parfor chunk=1:numchunks,
	indexes = (1+(chunk-1)*rois_per_chunk):1:min(chunk*rois_per_chunk,a.CC.NumObjects);
	CCsubset = ROI_subset(a.CC, indexes);
	params3d_here = regionprops3(CCsubset,IM,'all');
	params3d{chunk} = table2struct(params3d_here);
end;

params3d = cat(1,params3d{:});

toc

disp(['About to calculate 2d properties...may take a few minutes']);

tic

params2d = cell(numchunks,1);
parfor chunk=1:numchunks,
	indexes = (1+(chunk-1)*rois_per_chunk):1:min(chunk*rois_per_chunk,a.CC.NumObjects);
	CCsubset = ROI_subset(CC2, indexes);
	params2d{chunk} = regionprops(CCsubset,{'eccentricity','area','solidity','circularity'});
end;

params2d = cat(1,params2d{:});

toc

ROIparameters.params3d = params3d;
ROIparameters.params2d = params2d;

[filepath,fname,ext] = fileparts(filename);

roipfilename = fullfile(filepath,[fname '_roiparameters.mat']);

save(roipfilename, 'ROIparameters');

