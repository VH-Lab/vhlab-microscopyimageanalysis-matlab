function [parameters] = vh_groundtruthcompareC(atd, maskregion_rois, computer_roisA, groundtruthA, computer_roisB, groundtruthB, varargin)
% VH_vh_groundtruthcompare - Convert ROIs that have been placed in image files into actual AT ROIs
%
% VH_vh_groundtruthcompareC(ATD, maskregion_rois, computerroiA, groundtruthA, computerroiB, groundtruthB,  ...)
% 
% Performs ground truth correspondence analysis for all available ground truth datasets.
% 
% Several parameters can be altered by name/value pairs (see help NAMEVALUEPAIR).
% Parameter (default)       | Description
% --------------------------------------------------------------------
%
% Example:
%    atd = at_dir([MYEXPERIMENTPATH]);
%    vh_groundtruthcompareC(atd,'spine_ROI_DLW_ROI','PSD_DECsv1_roiresbf','PSD_ROI_KC_ROIres', 'VG_DECsv1_roiresbf','VG_ROI_KC_ROIres');
%


assign(varargin{:});

parameters = workspace2struct;

disp(['Working on new directory: ' getpathname(atd)])

try,
	mkdir([getpathname(atd) filesep 'groundtruth_analysisC']);
end;

stats = at_groundtruthcorrespondenceC(atd,maskregion_rois,computer_roisA, groundtruthA, computer_roisB, groundtruthB);
save([getpathname(atd) filesep 'groundtruth_analysisC' filesep computer_roisA '_x_' groundtruthA '.mat'],'stats');


