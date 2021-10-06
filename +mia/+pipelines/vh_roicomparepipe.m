function [parameters] = vh_roicomparepipe(atd, roi_search_string, roi_compare, varargin)
% VH_ROICOMPAREPIPE - Convert ROIs that have been placed in image files into actual AT ROIs
%
% VH_ROICOMPAREPIPE(ATD, ...)
% 
% Runs a pipeline (VH version 1) that looks for image files that define ROIs on the
% AT_DIR object ATD.
%
% It examines all image files that have the name SOMETHING_ROI_SOMETHING and
% makes ROIs that have the same name.
% 
%  The output will be named [outname '_*'].
% 
% Several parameters can be altered by name/value pairs (see help NAMEVALUEPAIR).
% Parameter (default)       | Description
% --------------------------------------------------------------------
% overlap_threshold (0.01)  | Overlap threshold for colocalization
% xyshift ([0])        | Colocalization shifts to examine in X/Y
% zshift ([0])              | Colocalization shifts to examine in Z
% delete_old_output (1)     | Delete any old output before we start
%                           |  (uses AT_CLEAN_PIPELINE)
%
% Example:
%    atd = at_dir([MYEXPERIMENTPATH]);
%    vh_roicomparepipe(atd,'PSD_ROI_','PSDsv1');
%

overlap_threshold = 0.01;
xyshift = 0;
zshift = 0;
delete_old_output = 1;
useRes = 1;

assign(varargin{:});

parameters = workspace2struct;

disp(['Working on new directory: ' getpathname(atd)])

roilist = getitems(atd,'ROIs');

indexes = [];
match = [];

for i=1:numel(roilist),
	if startsWith(roilist(i).name,roi_search_string) & (~useRes | endsWith(roilist(i).name,'ROIres')),
		indexes(end+1) = i;
	end;
	if strcmp(roilist(i).name,roi_compare),
		match = i;
	end;
end;

if isempty(match),
	error(['No match for ROI set with name ' roi_compare '.']);
end;

roisetB = roi_compare;


for i=1:numel(indexes),
	% make the colocalization
	disp(['Step 1: Making colocalization! (' int2str(i) ' of ' int2str(numel(indexes)) ')...'])
	clear p;
	roisetA = roilist(indexes(i)).name;
	outname = [ roisetA '_x_' roisetB '_CLA' ];
	p.shiftsX = xyshift;
	p.shiftsY = xyshift;
	p.shiftsZ = zshift;
	p.threshold = overlap_threshold;
	p.roi_set_2 = roisetB;
	at_colocalization_shiftxyz(atd,roisetA,outname,p);
	for j=i+1:numel(indexes), % compare all others
		p.roi_set_2 = roilist(indexes(j)).name;
		outname = [ roisetA '_x_' p.roi_set_2 '_CLA' ];
		at_colocalization_shiftxyz(atd,roisetA,outname,p);
	end;
end;

