%% SECOND THRESHOLD
function out = at_roi_secondthresh (atd, input_itemname, output_itemname, parameters)
% out = AT_ROI_SECONDTHRESH(ATD,INPUT_ITEMANME,OUTPUT_ITEMNAME,PARAMETERS) 
% atd should be a directory culminating in an "analysis" file for ATGUI
% code.
% input_itemname is specified in at_gui as a selected ROI set
% output_itemname is also specified in at_gui, and entered as you wish
% this transformation has one parameter, the % threshold for second thresh.
% second thresh is the percentage of intensity falloff from the ROI peak to
% the local background that defines which pixels are included in the new
% ROI.
% you can also manually set these three parameters for at_roi_locbacgr if you
% want: % parameters.dist_cardinal (default 50); parameters.CV_binsize
% (default 5);
% parameters.CV_thresh (default 0.01).


%% Give users options to input parameters, set defaults if not
if nargin==0,
	out{1} = {'secthresh','dist_cardinal','CV_binsize','CV_thresh','imagename'};
	out{2} = {'Second threshold (ratio of peak height)','Distace to scan for local background (0 for default)', 'Number of pixels considered for coeffvar for local background (0 for default)', ...
			'Coeffvar threshold for local background (0 for default)',...
			'Image name to use (leave blank to use default in history'};
	out{3} = {'choose_inputdlg'};
	return;
end;

if ischar(parameters),
	switch lower(parameters),
		case 'choose',
			out_choice = at_roi_secondthresh;
			choices = cat(2,out_choice{3},'Cancel');
			buttonname = questdlg('By which method should we choose parameters?',...
				'Which method?', choices{:},'Cancel');
			if ~strcmp(buttonname,'Cancel'),
				out = at_roi_secondthresh(atd,input_itemname,output_itemname,buttonname);
			else,
				out = [];
			end;
		case 'choose_inputdlg',
			out_p = at_roi_secondthresh;
            % EDIT THESE TO BE THE CORRECT SET OF PARAMETERS
			defaultparameters.secthresh = 0.20;
			defaultparameters.dist_cardinal = 50;
			defaultparameters.CV_binsize = 5;
			defaultparameters.CV_thresh = 0.01;
			defaultparameters.imagename = '';
			parameters = dlg2struct('Choose parameters', out_p{1}, out_p{2}, defaultparameters);
			if isempty(parameters),
				out = [];
			else,
				out = at_roi_resegment(atd,input_itemname,output_itemname,parameters);
			end
	end; % switch
	return;
end;

%% Load or generate local background values & peak values
ROIname = getlabeledroifilename(atd,input_itemname);
foldername = fileparts(ROIname);
if exist([foldername filesep input_itemname '_roiintparam.mat']) == 2    
    load([foldername filesep input_itemname '_roiintparam.mat'])
else
disp(['Cannot find local background value, recalculating with default settings!'])
[local_bg,highest_pixel] = at_roi_locbacgr(atd,ROIname);
end

%% Load the ROIs in the set (both L and CC files from ATGUI code)
L_in_file = getlabeledroifilename(atd,input_itemname);
roi_in_file = getroifilename(atd,input_itemname);
load(roi_in_file,'CC','-mat');
load(L_in_file,'L','-mat');
oldobjects = CC.NumObjects;

%% Load the original image
if isempty(parameters.imagename), % choose it 
    [dummy,im_fname] = at_roi_underlying_image(atd,itemname);
    parameters.imagename = im_fname;
end

[num_images,img_stack] = at_loadscaledstack(parameters.imagename);

%% Change ROI format from indexes to y x z (ind2sub)
[puncta_info] = at_puncta_info(img_stack,CC);

for punctum = 1: size(puncta_info,1),
    
%% Find the location, intensity, and frame of the peak pixel
intensities = cell2mat(puncta_info(punctum,3));
pixel_locs = cell2mat(puncta_info(punctum,2));
[highest_pixel(punctum) brightest_pixel_loc] = max(intensities);
highest_zframe(punctum) = pixel_locs(brightest_pixel_loc,3);

%% Narrow our selections to the second threshold
int_abv = find(intensities >=  local_bg(punctum) + ((1 - parameters.secthresh) * (highest_pixel(punctum) - local_bg(punctum))));
loc_abv = pixel_locs(int_abv,:);
new_puncta_info{punctum,1} = punctum; %puncta number
new_puncta_info{punctum,2} = loc_abv; %locations, note this is [y x z]
new_puncta_info{punctum,3} = int_abv; %intensities
end

%% Restore ROI format from y x z to indexes (sub2ind) & reconstruct CC file
sz_matrix = [size(img_stack,1) size(img_stack,2) size(img_stack,3)];
for rois = 1:size(new_puncta_info,1)
these_locs = cell2mat(new_puncta_info(rois,2));
PixelIdxList{1,rois} = sub2ind(sz_matrix,these_locs(:,1),these_locs(:,2),these_locs(:,3));
end

NewCC.Connectivity = CC.Connectivity;
NewCC.ImageSize = CC.ImageSize;
NewCC.NumObjects = size(PixelIdxList,2);
NewCC.PixelIdxList = PixelIdxList;
CC = NewCC;
L = labelmatrix(CC);

%% Save the new CC, L and parameter files
newobjects = CC.NumObjects;

L_out_file = [getpathname(atd) filesep 'ROIs' filesep output_itemname filesep output_itemname '_L' '.mat'];
roi_out_file = [getpathname(atd) filesep 'ROIs' filesep output_itemname filesep output_itemname '_ROI' '.mat'];

try,
	mkdir([getpathname(atd) filesep 'ROIs' filesep output_itemname]);
end;

save(roi_out_file,'CC','-mat');
save(L_out_file,'L','-mat');

h = gethistory(atd,'ROIs',input_itemname);
h(end+1) = struct('parent',input_itemname,'operation','at_roi_resegment','parameters',parameters,...
	'description',['Resegmented ' int2str(oldobjects) ' ROIs into ' int2str(newobjects) ' from ' input_itemname '.']);
sethistory(atd,'ROIs',output_itemname,h);

str2text([getpathname(atd) filesep 'ROIs' filesep output_itemname filesep 'parent.txt'], input_itemname);

at_roi_parameters(atd,roi_out_file);

out = 1;
end
