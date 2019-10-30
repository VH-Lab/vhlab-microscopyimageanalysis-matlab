function ROIparameters = at_roi_parameters(filename)
% AT_ROI_SIZES - for an ROI filename, return the ROI sizes
%
% ROIPARAMETERS = AT_ROI_SIZES(FILENAME)
%
% Returns a Matlab structure of the ROI sizes
%
% In addition, writes the data to a file called FILENAME_roiparameters.mat.
%

ROIparameters = emptystruct('solidity3d','solidity2d','eccentricity2d','areaXY','volume');

a = load(filename,'-mat');

disp(['About to calculate 2d projection']);
CC2 = ROI_3d_2dsummary(a.CC);
disp(['About to calculate 3d properties..may take a few minutes']);
tic
params3d = regionprops3(a.CC,{'Volume','Solidity'});
toc
params3d = table2struct(params3d);
disp(['About to calculate 2d properties...may take a few minutes']);
tic
params2d = regionprops(CC2,{'Area','Eccentricity','Solidity'});
toc

for i=1:a.CC.NumObjects,
	ROIpropshere.solidity3d = params3d(i).Solidity;
	ROIpropshere.solidity2d = params2d(i).Solidity;
	ROIpropshere.eccentricity2d = params2d(i).Eccentricity;
	ROIpropshere.areaXY = params2d(i).Area;
	ROIpropshere.volume = params3d(i).Volume;
	ROIparameters(i) = ROIpropshere;
end;

[filepath,fname,ext] = fileparts(filename);

roipfilename = fullfile(filepath,[fname '_roiparameters.mat']);

save(roipfilename, 'ROIparameters');

