function savesubset(atd, input_itemname, indexes, output_itemname, history)
% SAVESUBSET - save an subset of ROI and its associated files 
%
% MIA.ROI.FUNCTIONS.SAVESUBSET(ATD, INPUT_ITEMNAME, INDEXES, OUTPUT_ITEMNAME, HISTORY)
%
% Saves a new ROI set with OUTPUT_ITEMNAME, selecting a subset (INDEXES) of the
% ROIS in the ROI set at INPUT_ITEMNAME. HISTORY is saved with the new ROI set.
%
% 

L_in_file = atd.getlabeledroifilename(input_itemname);
roi_in_file = atd.getroifilename(input_itemname);
load(roi_in_file,'CC','-mat');

CC.NumObjects = numel(indexes);
CC.PixelIdxList = CC.PixelIdxList(indexes);
L = labelmatrix(CC);

L_out_file = [atd.getpathname() filesep 'ROIs' filesep output_itemname filesep output_itemname '_L' '.mat'];
roi_out_file = [atd.getpathname() filesep 'ROIs' filesep output_itemname filesep output_itemname '_ROI' '.mat'];

try,
	mkdir([atd.getpathname() filesep 'ROIs' filesep output_itemname]);
end;

save(roi_out_file,'CC','-mat');
save(L_out_file,'L','-mat');
atd.sethistory('ROIs',output_itemname,history);
str2text([atd.getpathname() filesep 'ROIs' filesep output_itemname filesep 'parent.txt'], input_itemname);

roi_properties_input_file = atd.getroiparametersfilename(input_itemname);
roi_properties_output_file = [atd.getpathname() filesep 'ROIs' filesep output_itemname filesep output_itemname 'ROI_roiparameters' '.mat'];

if exist(roi_properties_input_file,'file'),
	load(roi_properties_input_file);
	ROIparameters.params3d = ROIparameters.params3d(indexes);
	ROIparameters.params2d = ROIparameters.params2d(indexes);
	save(roi_properties_output_file,'ROIparameters');
end;

