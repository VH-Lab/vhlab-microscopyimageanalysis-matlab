function [parameters] = vh_groundtruthcompareC(atd, maskregion, computer_roisA, groundtruthA, computer_roisB, groundtruthB, varargin)
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
%    vh_groundtruthcompare(atd,'PSD_DECsv1','spine_ROI_DLW_ROI','PSD_ROI_');
%


assign(varargin{:});

parameters = workspace2struct;

disp(['Working on new directory: ' getpathname(atd)])

roilist = getitems(atd,'ROIs');

indexes = [];

for i=1:numel(roilist),
	if startsWith(roilist(i).name,groundtruthprefix) & endsWith(roilist(i).name,'_ROIres'), 
		if ~strcmp(roilist(i).name,computer_rois),
			indexes(end+1) = i;
		end;
	end;
end;

try,
	mkdir([getpathname(atd) filesep 'groundtruth_analysis']);
end;

for i=1:numel(indexes),
	disp(['Now working on ' roilist(indexes(i)).name '...']);
	stats = at_groundtruthcorrespondence(atd,computer_rois, maskregion_rois, roilist(indexes(i)).name);
	save([getpathname(atd) filesep 'groundtruth_analysis' filesep computer_rois '_x_' roilist(indexes(i)).name '.mat'],'stats');
end;


