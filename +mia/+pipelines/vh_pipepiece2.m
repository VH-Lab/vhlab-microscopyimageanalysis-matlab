function [parameters] = vh_pipepiece1(atd, startImageName, outname, varargin)
% VH_PIPEPIECE1 - Steve's first pipeline piece / Nelson lab - Van Hooser lab
%
% VH_PIPELINE1(ATD, STARTIMAGENAME, OUTNAME, ...)
% 
% Runs a sub pipeline (VH version 1) pipeline on an image with STARTIMAGENAME in the
% AT_DIR object ATD.
% Assumes that the image is already scaled (Step 0).
% For Step 1:
%    the image is examined by AT_ESTIMATETHRESHOLDS.
%    A new image called [outname '_th2'] is created with at_image_doublethreshold
% Step 2: ROIs are made [outname '_roi']
% Step 3: Volume filter (use 0, Inf to do nothing)
%
%  The output will be named [outname '_*'].
% 
% Several parameters can be altered by name/value pairs (see help NAMEVALUEPAIR).
% Parameter (default)       | Description
% --------------------------------------------------------------------
% plotthresholdestimate (0) | Should we plot the threshold estimate?
% connectivity (26)         | Connectivity for ROIs
% volume_filter_low (0)     | Low setting for volume filter
% volume_filter_high (Inf)  | High setting for volume filter
% t_levels ([80 30])        | Threshold levels for autothresholder
% delete_old_output (1)     | Delete any old output before we start
%                           |  (uses AT_CLEAN_PIPELINE)
%
% Example:
%    atd = at_dir([MYEXPERIMENTPATH]);
%    vh_pipepiece1(atd, 'PSD', 'PSDsv1');
%




plotthresholdestimate = 0;
volume_filter_low = 1;
volume_filter_high = Inf;
connectivity = 26;
delete_old_output = 1;
t_levels = [80 30];

assign(varargin{:});

parameters = workspace2struct;

disp(['Working on new directory: ' getpathname(atd)])

if delete_old_output,
	disp(['Cleaning pipeline as requested (deleting previous pipeline items): ' outname '.']);
	at_clean_pipeline(atd,outname);
end;

Step0_output_image_name = startImageName;
try,
	im = at_readimage(atd,Step0_output_image_name);
catch,
	disp(['No image ' Step0_output_image_name ' found, skipping...']);
	return;
end;

 % Step 0: perform AryScan 3
 % for right now I'm using just the starting image name

 % Step 1: threshold
disp(['Step 1: threshold']);
   % first, estimate thresholds
[th,out] = at_estimatethresholds(double(im),'t_levels',t_levels,...
	'plotit',plotthresholdestimate);

 % Step 1b, actually apply the threshold
clear p;
p.threshold1 = th(1);
p.threshold2 = th(2);
p.threshold_units = 'raw';
p.connectivity = connectivity;
p.thresholdinfo = out;
Step1_output_image_name = [outname '_th2'];
at_image_doublethreshold(atd, Step0_output_image_name, Step1_output_image_name, p);
disp(['Step 1: threshold complete']);

 % Step 2: Make rois
disp(['Step 2: making initial rois']);
clear p;
p.connectivity = connectivity;
Step2_output_roi_name = [outname '_roiraw'];
at_roi_connect(atd, Step1_output_image_name, Step2_output_roi_name, p);
disp(['Step 2: making initial rois complete']);

 % Step 3: Volume filter
disp(['Step 3: volume filter']);
clear p;
p.volume_minimum = volume_filter_low;
p.volume_maximum = volume_filter_high;
Step3_output_roi_name = [ outname '_roiresvf' ];
at_roi_volumefilter(atd, Step2_output_roi_name, Step3_output_roi_name, p);
disp(['Step 3: volume filter finished']);

