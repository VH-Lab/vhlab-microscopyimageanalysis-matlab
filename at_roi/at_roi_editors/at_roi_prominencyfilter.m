%% PROMINENCY FILTER
function out = at_roi_prominencyfilter (atd, input_itemname, output_itemname, parameters)
% out = AT_ROI_PROMINENCY FILTER (ATD,INPUT_ITEMANME,OUTPUT_ITEMNAME,PARAMETERS) 
% atd should be a directory culminating in an "analysis" file for ATGUI
% code.
% input_itemname is specified in at_gui as a selected ROI set
% output_itemname is also specified in at_gui, and entered as you wish
% this filter has one parameter, the threshold of prominence needed to
% consider a punctum sufficiently prominent over its local background - the
% logic being that if it not prominent, it is unlikely to be real.
% you can also manually set these three parameters for at_roi_locbacgr if you
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
	out{1} = {'prom_thresh','dist_cardinal','CV_binsize','imagename'};
	out{2} = {'Reject puncta if their peak is less than this value higher than local background','Distace to scan for local background (default shown)', 'Number of pixels considered for coeffvar for local background (default shown)', ...
			'Image name to use (leave blank to use default in history'};
	out{3} = {'choose_inputdlg'};
	return;
end;

if ischar(parameters),
	switch lower(parameters),
		case 'choose',
			out_choice = at_roi_prominencyfilter;
			choices = cat(2,out_choice{3},'Cancel');
			buttonname = questdlg('By which method should we choose parameters?',...
				'Which method?', choices{:},'Cancel');
			if ~strcmp(buttonname,'Cancel'),
				out = at_roi_prominencyfilter(atd,input_itemname,output_itemname,buttonname);
			else,
				out = [];
			end;
		case 'choose_inputdlg',
			out_p = at_roi_prominencyfilter;
			defaultparameters.prom_thresh = 100;
			defaultparameters.dist_cardinal = 50;
			defaultparameters.CV_binsize = 5;
			defaultparameters.imagename = '';
			parameters = dlg2struct('Choose parameters', out_p{1}, out_p{2}, defaultparameters);
			if isempty(parameters),
				out = [];
			else,
				out = at_roi_prominencyfilter(atd,input_itemname,output_itemname,parameters);
			end
	end; % switch
	return;
end;

%% Load or generate local background values & peak values
ROIname = getroifilename(atd,input_itemname);
foldername = fileparts(ROIname);
if exist([foldername filesep input_itemname '_ROI_roiintparam.mat']) == 2    
   load([foldername filesep input_itemname '_ROI_roiintparam.mat'])
   local_bg = ROIintparam.local_bg; highest_pixel = ROIintparam.highest_int;
disp(['Found local background value, loaded in!'])
else
disp(['Cannot find local background value, recalculating with provided settings!'])
[local_bg,highest_pixel] = at_roi_locbacgr(atd,ROIname,parameters);
end

%% Load the ROIs in the set (both L and CC files from ATGUI code)
L_in_file = getlabeledroifilename(atd,input_itemname);
roi_in_file = getroifilename(atd,input_itemname);
load(roi_in_file,'CC','-mat');
load(L_in_file,'L','-mat');
oldobjects = CC.NumObjects;

%% Load the original image
if isempty(parameters.imagename), % choose it 
    [dummy,im_fname] = at_roi_underlying_image(atd,input_itemname);
    parameters.imagename = im_fname;
end

[num_images,img_stack] = at_loadscaledstack(parameters.imagename);

%% Change ROI format from indexes to y x z (ind2sub)
[puncta_info] = at_puncta_info(img_stack,CC);

%% Remove any ROIs with lower prominence than chosen threshold
prominence = highest_pixel-local_bg;
abv_prom_thresh = find(prominence >= parameters.prom_thresh);
new_idx_list = CC.PixelIdxList(1,abv_prom_thresh)

NewCC.Connectivity = CC.Connectivity;
NewCC.ImageSize = CC.ImageSize;
NewCC.NumObjects = size(new_idx_list,2)
NewCC.PixelIdxList = new_idx_list;
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