function out = at_image_doublethresholdmask(atd, input_itemname, mask_itemname, output_itemname, parameters)
% AT_IMAGE_DOUBLETHRESHOLDMASK - Threshold an image based on a mask and store results
%  
%  OUT = AT_IMAGE_DOUBLETHRESHOLD(ATD, INPUT_ITEMNAME, MASK_ITEMNAME, OUTPUT_ITEMNAME, PARAMETERS)
%
%  If the function is called with no arguments, then a description of the
%  parameters is returned in OUT. OUT{1}{n} is the name of the nth parameter, and
%  OUT{2}{n} is a human-readable description of the parameter.
%  OUT{3} is a list of methods for user-guided selection of these parameters.
%
%  AT_IMAGE_DOUBLETHRESHOLD has several parameters:
%  | Parameter (default)                | Description                           |
%  |------------------------------------|---------------------------------------|
%  | threshold1 (95)                    | Value of threshold1                   |
%  | threshold2 (75)                    | Value of threshold2                   |
%  | threshold_units ('percentile')     | Unit of threshold (can be 'raw' or    |
%  |                                    |    'percentile'                       |
%  | mask_pixels_set_in_image (65e3)    | Value to assign pixels in raw image   |
%  |                                    |    of pixels that are positive in mask|
%  | connectivity (26)                  | Connectivity for ROI finding          |
%  
%

image_viewer_name = 'IM';

if nargin==0,
	out{1} = {'threshold1','threshold2','threshold_units','mask_pixels_set_in_image','connectivity'};
	out{2} = {'Threshold1 to apply to image to detect presence of objects (real number)', ...
			'Threshold2 to apply to image to detect presence of objects (real number)', ...
			'Units of thresholds; can be ''raw'' to use raw image units or ''percentile'' to use percentile of data.', ...
			'Value to assign pixels in the input image for pixels that are positive in the mask image.', ...
			'Connectivity argument to bwconncomp (26 for 3d all edge connectivity)'};
	out{3} = {'choose_inputdlg'}; % ,'choose_graphical'}; not yet ready for graphical
	return;
elseif nargin==1, % it means it is an image preview call

	im = atd;
	vars = image_viewer_gui(image_viewer_name,'command',[image_viewer_name 'get_vars']);

	fig = gcf;
	threshold1 = eval([get(findobj(fig,'tag','ThresholdEdit1'),'string') ';']);
	threshold2 = eval([get(findobj(fig,'tag','ThresholdEdit2'),'string') ';']);
	threshold_units_list = get(findobj(fig,'tag','ThresholdUnitPopup'),'string');
	threshold_units_value = get(findobj(fig,'tag','ThresholdUnitPopup'),'value');
	threshold_units = threshold_units_list(threshold_units_value);

	if strcmp(threshold_units,'percentile'),
		threshold1 = prctile(im(:),threshold1);
		threshold2 = prctile(im(:),threshold2);
	end;

	threshold_channels = [];

	above_indexes = [];

	for i=1:size(im,3),
		threshold_channels(i) = rescale(threshold1,...
			[vars.ImageScaleParams.Min(i) vars.ImageScaleParams.Max(i)], ...
			[vars.ImageDisplayScaleParams.Min(i) vars.ImageDisplayScaleParams.Max(i)]);
		above_indexes = cat(1,above_indexes,find(im(:,:,i)>threshold1_channels(i)));
	end;

	if size(im,3)==1,
		im_downscale = rescale(im,[vars.ImageDisplayScaleParams.Min(i) vars.ImageDisplayScaleParams.Max(i)],[0 1]);
		im_abovedownscale = im_downscale;
		im_abovedownscale(above_indexes) = 1;
		im3 = cat(3,im_abovedownscale,im_abovedownscale,im_downscale);
	else,
		im3 = above;
	end;

	out = im3;
	return;
end;

if ischar(parameters),
	switch lower(parameters),
		case 'choose',
			out_choice = at_image_doublethreshold;
			choices = cat(2,out_choice{3},'Cancel');
			buttonname = questdlg('By which method should we choose parameters?',...
				'Which method?', choices{:},'Cancel');
			if ~strcmp(buttonname,'Cancel'),
				out = at_image_doublethreshold(atd,input_itemname,mask_itemname, output_itemname,buttonname);
			else,
				out = [];
			end;
		case {'choose_inputdlg'},
			out_p = at_image_doublethreshold;
			default_parameters.threshold1 = 95;
			default_parameters.threshold2 = 75;
			default_parameters.threshold_units = 'percentile';
			default_parameters.mask_pixels_set_in_image = 1e5;
			default_parameters.connectivity = 26;
			parameters = dlg2struct('Choose parameters',out_p{1},out_p{2},default_parameters);
			if isempty(parameters),
				out = [];
			else,
				out = at_image_doublethreshold(atd,input_itemname,mask_itemname,output_itemname,parameters);
			end;
		case {'choose_graphical_notyet'},
	end;
	return;
end;

 % perform the thresholding

h = gethistory(atd,'images',input_itemname);
h(end+1) = struct('parent',input_itemname,'operation','at_image_doublethreshold','parameters',parameters,...
	'description',['Applied threshold1 of ' num2str(parameters.threshold1) ...
	' and threshold2 of ' num2str(parameters.threshold2) ' with units ' parameters.threshold_units ' to image ' input_itemname ' with mask ' mask_itemname '.']);

im_in_file = getimagefilename(atd,input_itemname);
im_mask_file = getimagefilename(atd,mask_itemname);

[dummy,image_raw_filename,ext] = fileparts(im_in_file);
[dummy,image_mask_filename,ext] = fileparts(im_mask_file);

im_out_file = [getpathname(atd) filesep 'images' filesep output_itemname filesep output_itemname ext];

input_finfo = imfinfo(im_in_file);
mask_finfo = imfinfo(im_mask_file);

extra_args{1} = {'WriteMode','overwrite'};
extra_args{2} = {'WriteMode','append'};

im = [];
im_raw = [];
for i=1:length(input_finfo),
	im_here = imread(im_in_file,'index',i,'info',input_finfo);
	im_raw = cat(3,im_raw,im_here);
	mask_here = imread(im_mask_file,'index',i,'info',mask_finfo);
	im_here(find(mask_here>0)) = parameters.mask_pixels_set_in_image;
	im = cat(3,im,im_here);
end;

if strcmp(parameters.threshold_units,'percentile'),
	t1 = prctile(im(:),parameters.threshold1);
	t2 = prctile(im(:),parameters.threshold2);
elseif strcmp(parameters.threshold_units, 'raw'),
	t1 = parameters.threshold1;
	t2 = parameters.threshold2;
else,
	error(['Unknown threshold units: ' parameters.threshold_units '.']);
end; 

class(im)
bin = vlt.image.doublethresholdresegment(im,t1,t2,parameters.connectivity,im_raw);

% write the new file

for i=1:length(input_finfo),
	if i==1, try, mkdir([getpathname(atd) filesep 'images' filesep output_itemname]); end; end;
	im_here = logical(bin(:,:,i));
	imwrite(im_here,im_out_file,extra_args{1+double(i>1)}{:});
end;

str2text([getpathname(atd) filesep 'images' filesep output_itemname filesep 'parent.txt'], input_itemname);

sethistory(atd,'images',output_itemname,h);

out = 1;

