function [parameters] = vh_autothreshold_plot(atd, startImageName, varargin)
% VH_AUTOTHRESHOLD_PLOT - Steve's first pipeline piece / Nelson lab - Van Hooser lab
%
% VH_AUTOTHRESHOLD_PLOT(ATD, STARTIMAGENAME, ...)
%
% Plots the results of autothresholding in the current axes.
%  
% Several parameters can be altered by name/value pairs (see help NAMEVALUEPAIR).
% Parameter (default)       | Description
% --------------------------------------------------------------------
% connectivity (26)         | Connectivity for ROIs
% t_levels ([80 30])        | Threshold levels for at_estimatethreshold
%
% Example:
%    atd = at_dir([MYEXPERIMENTPATH]);
%    vh_auththreshold_plot(atd, 'PSD');
%

connectivity = 26;
t_levels = [80 30];

vlt.data.assign(varargin{:});

parameters = workspace2struct;

Step0_output_image_name = startImageName;
try,
	im = at_readimage(atd,Step0_output_image_name);
catch,
	disp(['No image ' Step0_output_image_name ' found, skipping...']);
	return;
end;

   % estimate thresholds
[th,out] = at_estimatethresholds(double(im),...
	'plotit',1,'plotinnewfigure',0,...
	't_levels',t_levels);

