function [parameters] = vh_intensityvolume(atd, roisetA, outname, varargin)
% VH_INTENSITYVOLUME - Steve's first colocalization pipeline piece / Nelson lab - Van Hooser lab
%
% VH_INTENSITYVOLUME(ATD, ROISETA, OUTNAME, ...)
% 
% Runs a sub pipeline (Max Intensity and Volume Filter) on
% ROISETA and generates a new set of ROIs with name OUTNAME.
% Operates on AT_DIR object ATD.
%
%  The output will be named [outname '_*'].
% 
% Several parameters can be altered by name/value pairs (see help NAMEVALUEPAIR).
% Parameter (default)       | Description
% --------------------------------------------------------------------
% min_intensity_thresh (1)  | Which threshold of double threshold to use
% max_intensity_value (Inf) | Should we filter a maximum value?
% min_volume (4)            | Minimum volume allowed
% max_volume (Inf)          | Maximum volume allowed 
% delete_old_output (1)     | Delete any old output before we start
%                           |  (uses AT_CLEAN_PIPELINE)
%
% Example:
%    atd = at_dir([MYEXPERIMENTPATH]);
%    vh_intensityvolume(atd, 'PSD', 'PSDsv1');
%

min_intensity_thresh = 1;
max_intensity_value = Inf;
min_volume = 4;
max_volume = Inf;
delete_old_output = 1;

assign(varargin{:});

parameters = workspace2struct;

if delete_old_output,
	disp(['Cleaning pipeline as requested (deleting previous pipeline items): ' outname '.']);
	at_clean_pipeline(atd,outname);
end;

items = getitems(atd,'ROIs');

hasROIA = find(strcmp(roisetA,{items.name}));

if ~hasROIA,
	disp(['No ROIs ' roisetA ' found, skipping...']);
	return;
end;

disp(['Step 1: Intensity filter...']);

clear p;
h = gethistory(atd,'ROIs',roisetA);
p.property_name = 'MaxIntensity3';
if min_intensity_thresh==2,
	p.min_property = h(1).parameters.threshold2;
elseif min_intensity_thresh==1,
	p.min_property = h(1).parameters.threshold1;
else,
	error(['Unknown threshold input.']);
end;
p.max_property = max_intensity_value;

 % Step 1 out
 step1_out = [outname '_intensityfilt'];
at_roi_propertyfilter(atd,roisetA,step1_out,p);

disp(['Step 2: Volume filter...']);
 % Step 2: Volume filter
clear p;
p.volume_minimum = min_volume;
p.volume_maximum = max_volume;
step2_out = [outname '_vf'];
at_roi_volumefilter(atd, step1_out, step2_out, p);


