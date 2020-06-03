function [parameters] = wise_pipeline1(atd, startImageName, outname, varargin)
% WISE_PIPELINE1 - Derek Wise pipeline 1 / Nelson lab - Van Hooser lab
%
% WISE_PIPELINE1(ATD, STARTIMAGENAME, OUTNAME, ...)
% 
% Runs the Wise (version 1) pipeline on an image with STARTIMAGENAME in the
% AT_DIR object ATD.
% For Step 1, scaling is applied (not implemented yet).
% For Step 2, a threshold is applied.
% For Step 3, make the ROIs.
% For Step 4, apply a volume filter (use 0, Inf to do nothing)
% For Step 5, apply the watershed resegmentation 
%  The output will be named [startImageName '_' outname '_wp1_roivfres'].
%
% 
% Several parameters can be altered by name/value pairs (see help NAMEVALUEPAIR).
% Parameter (default)       | Description
% --------------------------------------------------------------------
% threshold (1250)          | Threshold for pixel detection
% connectivity (26)         | Connectivity for ROIs
% volume_filter_low (0)     | Low setting for volume filter
% volume_filter_high (Inf)  | High setting for volume filter
% 
%
% Example:
%    atd = at_dir([MYEXPERIMENTPATH]);
%    wise_pipelin1(atd, 'PSD95chan', 'threshold', 1275);
%


threshold = 1250;
volume_filter_low = 1;
volume_filter_high = Inf;

assign(varargin{:});

parameters = workspace2struct;

 % Step 1: perform AryScan 3
 %    Derek insert code here, result should be saved in at_dir as a new image
 % note the output image name
 % for right now I'm using just the starting image name
Step1_output_image_name = startImageName;

 % Step 2: threshold
clear p;
p.threshold = threshold;
Step2_output_image_name = [Step1_output_image_name '_' outname '_wp1_threshold'];
at_image_threshold(atd, Step1_output_image_name, Step2_output_image_name,p);

 % Step 3: Make rois
clear p;
p.connectivity = 26;
Step3_output_roi_name = [startImageName '_' outname '_wp1_roisraw'];
at_roi_connect(atd, Step2_output_image_name, Step3_output_roi_name, p);

 % Step 4: Volume filter
clear p;
p.volume_minumum = volume_filter_low;
p.volume_maximum = volume_filter_high;
Step4_output_roi_name = [ startImageName '_' outname '_wp1_roivf' ];
at_roi_volumefilter(atd, Step3_output_roi_name, Step4_output_roi_name, p);

 % Step 5: Watershed
clear p;
p.resegment_algorithm = 'watershed';
p.connectivity = 0;
p.values_outside_roi = 0;
p.use_bwdist = 0;
p.imagename = startImageName; % reset to scaled image name
Step5_output_roi_name = [ startImageName '_' outname '_wp1_roivfres'];
at_roi_resegment(atd,Step4_output_roi_name, Step5_output_roi_name, p);


