function out = blur(atd, input_itemname, output_itemname, parameters)
% BLUR - Threshold an image and store results
%  
%  OUT = MIA.IMAGE.PROCESS.BLUR(ATD, INPUT_ITEMNAME, OUTPUT_ITEMNAME, PARAMETERS)
%
%  If the function is called with no arguments, then a description of the
%  parameters is returned in OUT. OUT{1}{n} is the name of the nth parameter, and
%  OUT{2}{n} is a human-readable description of the parameter.
%  OUT{3} is a list of methods for user-guided selection of these parameters.
%
 
image_viewer_name = 'IM';

if nargin==0,                  % If function is called with 'zero' inputs, displays what parmaeters it takes. 
	out{1} = {'useGaussian','radius','filtersize'};
	out{2} = {'Filter type: 1=gaussian, 0=pure circle', 'Radius in pixels','Convolution filter in pixels'};
	out{3} = {'choose_inputdlg'};
	return;
end;

if ischar(parameters),
	switch lower(parameters),
		case 'choose',
			out_choice = mia.image.process.blur();
			choices = cat(2,out_choice{3},'Cancel');
			buttonname = questdlg('By which method should we choose parameters?',...
				'Which method?', choices{:},'Cancel');
			if ~strcmp(buttonname,'Cancel'),
				out = mia.image.process.blur(atd,input_itemname,output_itemname,buttonname);
			else,
				out = [];
			end;

		case {'choose_inputdlg'},
			out_p = mia.image.process.blur();
			default_parameters.useGaussian = 1;
			default_parameters.radius = 20;
			default_parameters.filtersize = 100;
			parameters = dlg2struct('Choose parameters',out_p{1},out_p{2},default_parameters);
			if isempty(parameters),
				out = [];
			else,
				out = mia.image.process.blur(atd,input_itemname,output_itemname,parameters);
			end;
	end;
	return;
end;

 % perform the filtering

if parameters.useGaussian,
	filter_type_str = 'Gaussian';
else,
	filter_type_str = 'circular';
end;

h = mia.miadir.gethistory(atd,'images',input_itemname);
h(end+1) = struct('parent',input_itemname,'operation','mia.image.process.blur','parameters',parameters,...
	'description',['Applied ' filter_type_str ' blur with radius ' num2str(parameters.radius) ' and filtersize ' num2str(parameters.filtersize) ' to image ' input_itemname '.']);

im_in_file = mia.miadir.getimagefilename(atd,input_itemname);

[dummy,image_raw_filename,ext] = fileparts(im_in_file);

im_out_file = [mia.miadir.getpathname(atd) filesep 'images' filesep output_itemname filesep output_itemname ext];

input_finfo = imfinfo(im_in_file);

extra_args{1} = {'WriteMode','overwrite'};
extra_args{2} = {'WriteMode','append'};

for i=1:length(input_finfo),
	im = imread(im_in_file,'index',i,'info',input_finfo);         % Reads the image
	if i==1, try, mkdir([mia.miadir.getpathname(atd) filesep 'images' filesep output_itemname]); end; end; % Makes new folder if needs too
	im_out = vlt.image.circular_filter(im,parameters.useGaussian, parameters.radius, parameters.filtersize);     % Calls the circular_filter function and applies threshold to the image.
	imwrite(im_out,im_out_file,extra_args{1+double(i>1)}{:});
	str2text([mia.miadir.getpathname(atd) filesep 'images' filesep output_itemname filesep 'parent.txt'], input_itemname);
end;

mia.miadir.sethistory(atd,'images',output_itemname,h);

out = 1;

