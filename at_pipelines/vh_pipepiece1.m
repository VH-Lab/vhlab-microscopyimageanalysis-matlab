function [parameters] = vh_pipepiece1(atd, startImageName, outname, varargin)
% WISE_PIPELINE1 - Derek Wise pipeline 1 / Nelson lab - Van Hooser lab
%
% WISE_PIPELINE1(ATD, STARTIMAGENAME, OUTNAME, ...)
% 
% Runs a sub pipeline (VH version 1) pipeline on an image with STARTIMAGENAME in the
% AT_DIR object ATD.
% Assumes that the image is already scaled (Step 0).
% For Step 1:
%    the image is examined by AT_ESTIMATETHRESHOLDS.
%    A new image called [outname '_th2'] is created with at_image_doublethreshold
% Step 2: ROIs are made [outname '_roi']
% Step 3, Watershed is applied
% Step 4: Volume filter (use 0, Inf to do nothing)
%
%  The output will be named [outname '_*'].
%
% 
% Several parameters can be altered by name/value pairs (see help NAMEVALUEPAIR).
% Parameter (default)       | Description
% --------------------------------------------------------------------
% plotthresholdestimate (0) | Should we plot the threshold estimate?
% connectivity (26)         | Connectivity for ROIs
% volume_filter_low (0)     | Low setting for volume filter
% volume_filter_high (Inf)  | High setting for volume filter
% 
%
% Example:
%    atd = at_dir([MYEXPERIMENTPATH]);
%    vh_pipepiece1(atd, 'PSD', 'PSDsv1');
%


plotthresholdestimate = 0;
volume_filter_low = 1;
volume_filter_high = Inf;
connectivity = 26;

assign(varargin{:});

parameters = workspace2struct;

disp(['Working on new directory: ' ])

atd,

Step0_output_image_name = startImageName;
im_in_file = getimagefilename(atd,Step0_output_image_name);
if isempty(im_in_file),
	disp(['No image ' Step0_output_image_name ' found, skipping...']);
	return;
end;

 % Step 0: perform AryScan 3
 % for right now I'm using just the starting image name

 % Step 1: threshold
disp(['Step 1: threshold']);
   % first, estimate thresholds
input_finfo = imfinfo(im_in_file);
im = [];
for i=1:numel(input_finfo),
	im_here = imread(im_in_file,'index',i,'info',input_finfo);
	im = cat(3,im,im_here);
end;
[th,out] = at_estimatethresholds(double(im),'plotit',plotthresholdestimate);

 % Step 1b, actually apply the threshold
clear p;
p.threshold1 = th(1);
p.threshold2 = th(2);
p.threshold_units = 'raw';
p.connectivity = connectivity;
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

