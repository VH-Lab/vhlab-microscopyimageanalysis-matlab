function [parameters] = vh_rawhuman2filled(atd, startImageName, maskImageName, outname, varargin)
% VH_RAWHUMAN2FILLED - 
%
% VH_RAWHUMAN2FILLED(ATD, STARTIMAGENAME, MASKIMAGENAME, OUTNAME, ...)
% 
% Runs a sub pipeline (VH version 1) pipeline on an image with STARTIMAGENAME in the
% AT_DIR object ATD.
% Assumes that the image is already scaled (Step 0).
% For Step 1:
%    the image is examined by AT_ESTIMATETHRESHOLDS.
%    A new image called [outname '_th2mask'] is created with at_image_doublethreshold
% Step 2: ROIs are made [outname '_roi']
% Step 3, Watershed is applied
% Step 4: Volume filter (use 0, Inf to do nothing)
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
threshold_connectivity = 6;
mask_pixels_set_in_image = 65e3;
delete_old_output = 1;
t_levels = [99 30];

assign(varargin{:});

parameters = workspace2struct;

Step0_output_image_name = startImageName;
try,
	im = at_readimage(atd,Step0_output_image_name);
catch,
	disp(['No image ' Step0_output_image_name ' found, skipping...']);
	return;
end;

 % Step 1: threshold
disp(['Step 1: threshold']);
   % first, estimate thresholds
[th,out] = at_estimatethresholds(double(im),'t_levels',t_levels,...
	'plotit',plotthresholdestimate);

 % Step 1b, actually apply the threshold
clear p;
p.threshold1 = mask_pixels_set_in_image - 1;
p.threshold2 = th(1);
p.threshold_units = 'raw';
p.mask_pixels_set_in_image = mask_pixels_set_in_image;
p.connectivity = threshold_connectivity;
p.thresholdinfo = out;
Step1_output_image_name = [outname '_th2mask'];
at_image_doublethresholdmask(atd, Step0_output_image_name, maskImageName, Step1_output_image_name, p);
disp(['Step 1: threshold complete']);

 % Step 2: Make rois
disp(['Step 2: making initial rois']);
clear p;
p.connectivity = connectivity;
Step2_output_roi_name = [outname '_roiraw'];
at_roi_connect(atd, Step1_output_image_name, Step2_output_roi_name, p);
disp(['Step 2: making initial rois complete']);

 % Step 3: Watershed, with and without assigning borders
disp(['Step 3: performing watershed with and without borders']);
clear p;
p.resegment_algorithm = 'watershed';
p.connectivity = 0;
p.values_outside_roi = 0;
p.use_bwdist = 0;
p.imagename = startImageName; % reset to scaled image name
p.assignborders = 1;
Step3_output_roi_name = [ outname '_roires'];
at_roi_resegment(atd,Step2_output_roi_name, Step3_output_roi_name, p);
disp(['Step 3: performing watershed with borders assigned finished']);
p.assignborders = 0;
Step3_output_roi_name_alt = [ outname '_roires_noborder'];
at_roi_resegment(atd,Step2_output_roi_name, Step3_output_roi_name_alt, p);
disp(['Step 3: performing watershed without borders assigned finished']);

 % Step 4: Volume filter
disp(['Step 4: volume filter']);
clear p;
p.volume_minimum = volume_filter_low;
p.volume_maximum = volume_filter_high;
Step4_output_roi_name = [ outname '_roiresvf' ];
at_roi_volumefilter(atd, Step3_output_roi_name, Step4_output_roi_name, p);
disp(['Step 4: volume filter finished']);

