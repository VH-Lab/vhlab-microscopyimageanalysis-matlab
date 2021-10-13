%% PROMINENCY FILTER
function out = squatfilter (atd, input_itemname, output_itemname, parameters)
% out = AT_ROI_SQUAT FILTER (ATD,INPUT_ITEMANME,OUTPUT_ITEMNAME,PARAMETERS) 
% atd should be a directory culminating in an "analysis" file for mia.GUI.archived_code.ATGUI
% code.
% input_itemname is specified in at_gui as a selected ROI set
% output_itemname is also specified in at_gui, and entered as you wish
% this filter has one parameter, the threshold of prominence needed to
% consider a punctum sufficiently prominent over its local background - the
% logic being that if it not prominent, it is unlikely to be real.
% you can also manually set these three parameters for mia.roi.functions.locbacgr if you
% want: % parameters.dist_cardinal (default 50); parameters.CV_binsize
% (default 5);
% parameters.CV_thresh (default 0.01).
% 
% EXAMPLE PARAMETERS (for troubleshooting)
% atd = atdir(['C:\Users\Derek\Desktop\Analysis 4, ground truth of ROIs\2 24 VV CTRL 2\analysis']);
% input_itemname = 'PSD_test_th_roi';
% output_itemname = 'PSD_test_th_roi_pf';
% parameters.imagename = '';

%% Give users options to input parameters, set defaults if not
if nargin==0,
	out{1} = {'dist_cardinal','prc_cut','imagename'};
	out{2} = {'Distace to scan for slope from peak (default shown)','Percentage of slope range to exclude (an integer percentage)', ...
			'Image name to use (leave blank to use default in history'};
	out{3} = {'choose_inputdlg'};
	return;
end;

if ischar(parameters),
	switch lower(parameters),
		case 'choose',
			out_choice = mia.roi.editors.squatfilter;
			choices = cat(2,out_choice{3},'Cancel');
			buttonname = questdlg('By which method should we choose parameters?',...
				'Which method?', choices{:},'Cancel');
			if ~strcmp(buttonname,'Cancel'),
				out = mia.roi.editors.squatfilter(atd,input_itemname,output_itemname,buttonname);
			else,
				out = [];
			end;
		case 'choose_inputdlg',
			out_p = mia.roi.editors.squatfilter;
			defaultparameters.dist_cardinal = 15;
			defaultparameters.prc_cut = 5;
			defaultparameters.imagename = '';
			parameters = dlg2struct('Choose parameters', out_p{1}, out_p{2}, defaultparameters);
			if isempty(parameters),
				out = [];
			else,
				out = mia.roi.editors.squatfilter(atd,input_itemname,output_itemname,parameters);
			end
	end; % switch
	return;
end;

%% Load or generate local background values & peak values
ROIname = getroifilename(atd,input_itemname);
foldername = fileparts(ROIname);

% [intensity_thresh,max_neg_slopes,cutoff,highest_pixel] = mia.roi.functions.secthreshslopes(atd,ROIname,parameters);
[local_bg,whh,highest_pixel]= mia.roi.functions.widthhalfheight(atd,ROIname,parameters);

%% Load the ROIs in the set (both L and CC files from mia.GUI.archived_code.ATGUI code)
L_in_file = getlabeledroifilename(atd,input_itemname);
roi_in_file = getroifilename(atd,input_itemname);
load(roi_in_file,'CC','-mat');
load(L_in_file,'L','-mat');
oldobjects = CC.NumObjects;

%% Load the original image
if isempty(parameters.imagename), % choose it 
    [dummy,im_fname] = mia.roi.functions.underlying_image(atd,input_itemname);
    parameters.imagename = im_fname;
end

[num_images,img_stack] = mia.at_loadscaledstack(parameters.imagename);

%% Change ROI format from indexes to y x z (ind2sub)
[puncta_info] = mia.utilities.at_puncta_info(img_stack,CC);

%% Get simple puncta information
for punctum = 1: size(puncta_info,1),
intensities = cell2mat(puncta_info(punctum,3));
pixel_locs = cell2mat(puncta_info(punctum,2));
[highest_pixel(punctum) brightest_pixel_loc] = max(intensities);
volume(punctum) = size(intensities,1);
end

%% Calculate a cutoff for squat puncta

slenderness = highest_pixel ./ whh;
range = max(slenderness) - min(slenderness);
cutoff =  min(slenderness) + range / (100/parameters.prc_cut);
% figure
% hold on
% plot(slenderness,'ko')
% plot([0 size(puncta_info,1)],[cutoff cutoff],'r-')

%% Remove any ROIs with a low maximum slope (squat puncta)
% good_indexes = find(max_neg_slopes <= cutoff);

good_indexes = find(slenderness >= cutoff);


%% Save the new CC, L and parameter files
newobjects = size(good_indexes,2);

try,
	mkdir([getpathname(atd) filesep 'ROIs' filesep output_itemname]);
end;

h = gethistory(atd,'ROIs',input_itemname);
h(end+1) = struct('parent',input_itemname,'operation','mia.roi.editors.resegment','parameters',parameters,...
	'description',['ROIs were pared down from ' int2str(oldobjects) ' to ' int2str(newobjects) ', rejecting non-prominent members from ' input_itemname '.']);
sethistory(atd,'ROIs',output_itemname,h);

mia.roi.functions.savesubset(atd,input_itemname, good_indexes, output_itemname, h);

out = 1;
end
