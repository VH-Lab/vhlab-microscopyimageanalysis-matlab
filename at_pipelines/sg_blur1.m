function [parameters] = sg_blur1(atd, startImageName, varargin)
% SG_BLUR1 - Sam's first pipeline piece / Nelson lab - Van Hooser lab
%
% SG_BLUR1(ATD, STARTIMAGENAME, OUTNAME, ...)
% 
% Runs a sub pipeline (VH version 1) pipeline on an image with STARTIMAGENAME in the
% AT_DIR object ATD.
% STARTIMAGENAME should be the name of a thresholded image file.
%
% Step 1: the image is blurred and named [STARTIMAGENAME '_blur']
% Step 2: the new blurred image is then thresholded and called [STARTIMAGENAME '_blur_th']
%
% Several parameters can be altered by name/value pairs (see help NAMEVALUEPAIR).
% Parameter (default)       | Description
% --------------------------------------------------------------------
% useGaussian (1)           | Should use a Gaussian
% radius (20)               | Radius to use
% filtersize (100)          | Filter size to use
% postblurthreshold (10)    | Post blur threshold
%
% Example:
%    atd = at_dir([MYEXPERIMENTPATH]);
%    sg_blur1(atd, 'PSD', 'PSDsv1');
%


useGaussian = 1;
radius = 20;
filtersize = 100;
postblurthreshold = 10;

assign(varargin{:});

parameters = workspace2struct;

disp(['Working on new directory: ' getpathname(atd)])


Step0_output_image_name = startImageName;
try,
	im = at_readimage(atd,Step0_output_image_name);
catch,
	disp(['No image ' Step0_output_image_name ' found, skipping...']);
	return;
end;


% Step 1: perform blur
outname_step1 = [ startImageName '_blur'];
blur_parameters.useGaussian = useGaussian;
blur_parameters.radius = radius;
blur_parameters.filtersize = filtersize;
at_image_blur(atd, startImageName, outname_step1, blur_parameters);

disp(['Blur completed...']);

% Step 2: perform after-blur threshold

outname_step2 = [ startImageName '_blur_th'];
th_parameters.threshold = postblurthreshold;
at_image_threshold(atd, outname_step1, outname_step2, th_parameters);

disp(['Second threshold completed...']);
