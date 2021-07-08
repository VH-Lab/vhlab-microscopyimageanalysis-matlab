function out = at_image_blur(atd, input_itemname, output_itemname, parameters)
% AT_IMAGE_BLUR - Threshold an image and store results
%  
%  OUT = AT_IMAGE_BLUR(ATD, INPUT_ITEMNAME, OUTPUT_ITEMNAME, PARAMETERS)
%
%  If the function is called with no arguments, then a description of the
%  parameters is returned in OUT. OUT{1}{n} is the name of the nth parameter, and
%  OUT{2}{n} is a human-readable description of the parameter.
%  OUT{3} is a list of methods for user-guided selection of these parameters.
%
 
error('not debugged yet.');

image_viewer_name = 'IM';

if nargin==0,
	out{1} = {'useGaussian','radius','filtersize'};
	out{2} = {'Filter type; 1=gaussian, 0=pure circle', 'Human 2','Human 3'};
	out{3} = {'choose_inputdlg'};
	return;
end;

if ischar(parameters),
	switch lower(parameters),
		case 'choose',
			out_choice = at_image_threshold;
			choices = cat(2,out_choice{3},'Cancel');
			buttonname = questdlg('By which method should we choose parameters?',...
				'Which method?', choices{:},'Cancel');
			if ~strcmp(buttonname,'Cancel'),
				out = at_image_threshold(atd,input_itemname,output_itemname,buttonname);
			else,
				out = [];
			end;

		case {'choose_inputdlg'},
			out_p = at_image_threshold;
			default_parameters.threshold = 100;
			parameters = dlg2struct('Choose parameters',out_p{1},out_p{2},default_parameters);
			if isempty(parameters),
				out = [];
			else,
				out = at_image_threshold(atd,input_itemname,output_itemname,parameters);
			end;
	end;
	return;
end;

 % perform the thresholding

h = gethistory(atd,'images',input_itemname);
h(end+1) = struct('parent',input_itemname,'operation','at_image_blur','parameters',parameters,...
	'description',['Applied blur with radius ' num2str(parameters.threshold) ' to image ' input_itemname '.']);

im_in_file = getimagefilename(atd,input_itemname);

[dummy,image_raw_filename,ext] = fileparts(im_in_file);

im_out_file = [getpathname(atd) filesep 'images' filesep output_itemname filesep output_itemname ext];

input_finfo = imfinfo(im_in_file);

extra_args{1} = {'WriteMode','overwrite'};
extra_args{2} = {'WriteMode','append'};

for i=1:length(input_finfo),
	im = imread(im_in_file,'index',i,'info',input_finfo);
	if i==1, try, mkdir([getpathname(atd) filesep 'images' filesep output_itemname]); end; end;
    % Sam's code goes here:
    % This is the thresholding thing
    im = logical(im > parameters.threshold);
	imwrite(im,im_out_file,extra_args{1+double(i>1)}{:});
	str2text([getpathname(atd) filesep 'images' filesep output_itemname filesep 'parent.txt'], input_itemname);
end;

sethistory(atd,'images',output_itemname,h);

out = 1;

