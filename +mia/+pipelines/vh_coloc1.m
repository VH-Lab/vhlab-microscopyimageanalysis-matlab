function [parameters] = vh_coloc1(atd, roisetA, roisetB, outname, varargin)
% VH_COLOC1 - Steve's first colocalization pipeline piece / Nelson lab - Van Hooser lab
%
% VH_COLOC1(ATD, STARTIMAGENAME, OUTNAME, ...)
% 
% Runs a sub pipeline (VH colocalization version 1) pipeline on ROIs A with name
% ROISETA and ROIs B with name ROISETB and generate a co-localization called OUTNAME.
% Operators on AT_DIR object ATD.
%
% Assumes that the image is already scaled (Step 0).
%
%  The output will be named [outname '_*'].
% 
% Several parameters can be altered by name/value pairs (see help NAMEVALUEPAIR).
% Parameter (default)       | Description
% --------------------------------------------------------------------
% overlap_threshold (0.01)  | Overlap threshold for colocalization
% xyshift ([-2 : 2])        | Colocalization shifts to examine in X/Y
% zshift ([0])              | Colocalization shifts to examine in Z
% delete_old_output (1)     | Delete any old output before we start
%                           |  (uses AT_CLEAN_PIPELINE)
%
% Example:
%    atd = at_dir([MYEXPERIMENTPATH]);
%    vh_coloc1(atd, 'PSD', 'PSDsv1');
%


overlap_threshold = 0.01;
xyshift = [-2:2];
zshift = 0;
delete_old_output = 1;

assign(varargin{:});

parameters = workspace2struct;

if delete_old_output,
	disp(['Cleaning pipeline as requested (deleting previous pipeline items): ' outname '.']);
	at_clean_pipeline(atd,outname);
end;

items = getitems(atd,'ROIs');

hasROIA = find(strcmp(roisetA,{items.name}));
hasROIB = find(strcmp(roisetB,{items.name}));

if isempty(hasROIA)
	disp(['Experiment lacks ' roisetA ', skipping...']);
	return;
end;
if isempty(hasROIB),
	disp(['Experiment lacks ' roisetB ', skipping...']);
	return;
end;

% Step 1: make the first colocalization
disp(['Step 1: Making colocalization!'])
clear p;
p.shiftsX = xyshift;
p.shiftsY = xyshift;
p.shiftsZ = zshift;
p.threshold = overlap_threshold;
p.roi_set_2 = roisetB;
at_colocalization_shiftxyz(atd,roisetA,outname,p);


