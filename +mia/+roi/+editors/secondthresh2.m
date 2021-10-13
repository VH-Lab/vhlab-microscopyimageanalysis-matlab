%% SECOND THRESHOLD
function out = secondthresh (atd, input_itemname, output_itemname, parameters)
% out = MIA.ROI.EDITORS.SECONDTHRESH(ATD,INPUT_ITEMANME,OUTPUT_ITEMNAME,PARAMETERS) 
% atd should be a directory culminating in an "analysis" file for mia.GUI.archived_code.ATGUI
% code.
% input_itemname is specified in at_gui as a selected ROI set
% output_itemname is also specified in at_gui, and entered as you wish
% this transformation has one parameter, the % threshold for second thresh.
% second thresh is the percentage of intensity falloff from the ROI peak to
% the local background that defines which pixels are included in the new
% ROI.
% you can also manually set these three parameters for mia.roi.functions.locbacgr if you
% want: % parameters.dist_cardinal (default 50); parameters.CV_binsize
% (default 5);
% parameters.CV_thresh (default 0.01).

%% Give users options to input parameters, set defaults if not
if nargin==0,
	out{1} = {'secthresh','dist_cardinal','CV_binsize','imagename'};
	out{2} = {'Second threshold (ratio of peak height)','Distace to scan for local background (default shown)', 'Number of pixels considered for coeffvar for local background (default shown)', ...
			'Image name to use (leave blank to use default in history'};
	out{3} = {'choose_inputdlg'};
	return;
end;

if ischar(parameters),
	switch lower(parameters),
		case 'choose',
			out_choice = mia.roi.editors.secondthresh2;
			choices = cat(2,out_choice{3},'Cancel');
			buttonname = questdlg('By which method should we choose parameters?',...
				'Which method?', choices{:},'Cancel');
			if ~strcmp(buttonname,'Cancel'),
				out = mia.roi.editors.secondthresh2(atd,input_itemname,output_itemname,buttonname);
			else,
				out = [];
			end;
		case 'choose_inputdlg',
			out_p = mia.roi.editors.secondthresh2;
            % EDIT THESE TO BE THE CORRECT SET OF PARAMETERS
			defaultparameters.secthresh = 0.20;
			defaultparameters.dist_cardinal = 50;
			defaultparameters.CV_binsize = 5;
			defaultparameters.imagename = '';
			parameters = dlg2struct('Choose parameters', out_p{1}, out_p{2}, defaultparameters);
			if isempty(parameters),
				out = [];
			else,
				out = mia.roi.editors.secondthresh2(atd,input_itemname,output_itemname,parameters);
			end
	end; % switch
	return;
end;

%% Load or generate local background values & peak values
% will gather these from the input image - they won't be saved in the new ROI
% folder
ROIname = getroifilename(atd,input_itemname);
foldername = fileparts(ROIname);

disp(['Calculating ROI ID slope properties!'])
[intensity_thresh,max_neg_slopes,cutoff,highest_pixel] = mia.roi.functions.secthreshslopes(atd,ROIname,parameters);


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

%% Find the location, intensity, and frame of the peak pixel
for punctum = 1: size(puncta_info,1),
intensities = cell2mat(puncta_info(punctum,3));
pixel_locs = cell2mat(puncta_info(punctum,2));

%% Narrow our selections to the second threshold
which_zframes = unique(pixel_locs(:,3));
loc_abv = [];
if isnan(intensity_thresh(punctum)),
    intensity_thresh = highest_pixel(punctum) * 0.80; % default to -20% of peak value
end
for frame = which_zframes(1):which_zframes(end),
    locs_this_frame = find(pixel_locs(:,3) == frame);
    int_this_frame = intensities(locs_this_frame);
    max_this_frame = max(int_this_frame);
    loc_add = locs_this_frame(find(intensities(locs_this_frame) >=  intensity_thresh(punctum)));
    loc_abv = [loc_abv,loc_add'];
end
int_abv = intensities(loc_abv)';

new_puncta_info{punctum,1} = punctum; %puncta number
new_puncta_info{punctum,2} = pixel_locs(loc_abv,:); %locations, note this is [y x z]
new_puncta_info{punctum,3} = int_abv; %intensities
end

%% Delete emtpy cells if necessary
real_cells = find(~cellfun(@isempty,new_puncta_info(:,3)));
new_puncta_info = new_puncta_info(real_cells,:);

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
h(end+1) = struct('parent',input_itemname,'operation','mia.roi.editors.resegment','parameters',parameters,...
	'description',['Second threshold took ' int2str(oldobjects) ' ROIs, and transformed into ' int2str(newobjects) ' from ' input_itemname '.']);
sethistory(atd,'ROIs',output_itemname,h);

str2text([getpathname(atd) filesep 'ROIs' filesep output_itemname filesep 'parent.txt'], input_itemname);
mia.roi.functions.parameters(atd,roi_out_file);

out = 1;
end
