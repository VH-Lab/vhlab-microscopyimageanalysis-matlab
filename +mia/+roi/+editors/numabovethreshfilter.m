%% NUMBER OF PIXELS ABOVE HIGH THRESHOLD FILTER
function out = numabovethreshfilter (atd, input_itemname, output_itemname, parameters)
% out = AT_ROI_PROMINENCY FILTER (ATD,INPUT_ITEMANME,OUTPUT_ITEMNAME,PARAMETERS) 
% atd should be a directory culminating in an "analysis" file for mia.GUI.archived_code.ATGUI
% code.
% input_itemname is specified in at_gui as a selected ROI set, which must
% have been generated with the doublethreshold system and must have had a
% threshold supplied by mia.utilities.estimatethresholds.
% output_itemname is also specified in at_gui, and entered as you wish

% This filter has one useful parameter, num_above, representing the number
% of pixels that exceed the high threshold. We found this parameter was
% predictive of our ground truth dataset.

% EXAMPLE PARAMETERS (for troubleshooting)
% atd = atdir(['C:\Users\Derek\Desktop\Analysis 4, ground truth of ROIs\2 24 VV CTRL 2\analysis']);
% input_itemname = 'PSD_test_th_roi';
% output_itemname = 'PSD_test_th_roi_nath';
% parameters.num_above = 50;
% parameters.imagename = '';

%% Give users options to input parameters, set defaults if not
if nargin==0,
	out{1} = {'num_above','imagename'};
	out{2} = {'Number of pixels that must exceed the peak inclusion threshold',
			'Image name to use (leave blank to use default in history'};
	out{3} = {'choose_inputdlg'};
	return;
end;

if ischar(parameters),
	switch lower(parameters),
		case 'choose',
			out_choice = mia.roi.editors.numabovethreshfilter;
			choices = cat(2,out_choice{3},'Cancel');
			buttonname = questdlg('By which method should we choose parameters?',...
				'Which method?', choices{:},'Cancel');
			if ~strcmp(buttonname,'Cancel'),
				out = mia.roi.editors.numabovethreshfilter(atd,input_itemname,output_itemname,buttonname);
			else,
				out = [];
			end;
		case 'choose_inputdlg',
			out_p = mia.roi.editors.numabovethreshfilter;
			defaultparameters.num_above = 50;
			defaultparameters.imagename = '';
			parameters = dlg2struct('Choose parameters', out_p{1}, out_p{2}, defaultparameters);
			if isempty(parameters),
				out = [];
			else,
				out = mia.roi.editors.numabovethreshfilter(atd,input_itemname,output_itemname,parameters);
			end
	end; % switch
	return;
end;

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

[num_images,img_stack] = mia.loadscaledstack(parameters.imagename);

%% Change ROI format from indexes to y x z (ind2sub)
[puncta_info] = mia.utilities.puncta_info(img_stack,CC);

%% Get the threshold data
hist = mia.miadir.gethistory(atd,'ROIs',input_itemname);
doublethreshname = hist(2).parent;
hh = mia.miadir.gethistory(atd,'images',doublethreshname);
thresholdinfo = hh(end).parameters.thresholdinfo;

threshold_to_meet = thresholdinfo(1);

%% Remove any ROIs with lower prominence than chosen threshold
for k = 1:size(puncta_info,1),
    number_above_threshold(k) = size(find(puncta_info{k,3} >= threshold_to_meet),1); %check that this is the correct dimension
end

exceeds_num_above_thresh = find(number_above_threshold >= parameters.num_above);

new_idx_list = CC.PixelIdxList(1,exceeds_num_above_thresh);

NewCC.Connectivity = CC.Connectivity;
NewCC.ImageSize = CC.ImageSize;
NewCC.NumObjects = size(new_idx_list,2);
NewCC.PixelIdxList = new_idx_list;
CC = NewCC;
L = labelmatrix(CC);

%% Save the new CC, L and parameter files
newobjects = CC.NumObjects;

L_out_file = [mia.miadir.getpathname(atd) filesep 'ROIs' filesep output_itemname filesep output_itemname '_L' '.mat'];
roi_out_file = [mia.miadir.getpathname(atd) filesep 'ROIs' filesep output_itemname filesep output_itemname '_ROI' '.mat'];

try,
	mkdir([mia.miadir.getpathname(atd) filesep 'ROIs' filesep output_itemname]);
end;

save(roi_out_file,'CC','-mat');
save(L_out_file,'L','-mat');

h = mia.miadir.gethistory(atd,'ROIs',input_itemname);
h(end+1) = struct('parent',input_itemname,'operation','mia.roi.editors.resegment','parameters',parameters,...
	'description',['Pared down ' int2str(oldobjects) ' ROIs below ' int2str(parameters.num_above) ' pixels above peak threshold into ' int2str(newobjects) ' from ' input_itemname '.']);
sethistory(atd,'ROIs',output_itemname,h);

str2text([mia.miadir.getpathname(atd) filesep 'ROIs' filesep output_itemname filesep 'parent.txt'], input_itemname);

mia.roi.functions.parameters(atd,roi_out_file);

out = 1;
end
