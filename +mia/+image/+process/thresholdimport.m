function out = thresholdimport(atd, input_itemname, output_itemname, parameters)
% THRESHOLDIMPORT - Import threshold data for an image from an external image
%  
%  OUT = THRESHOLDIMPOT(ATD, INPUT_ITEMNAME, OUTPUT_ITEMNAME, PARAMETERS)
%
%  If the function is called with no arguments, then a description of the
%  parameters is returned in OUT. OUT{1}{n} is the name of the nth parameter, and
%  OUT{2}{n} is a human-readable description of the parameter.
%  OUT{3} is a list of methods for user-guided selection of these parameters.
%
 
image_viewer_name = 'IM';

if nargin==0,
	out{1} = {'input_filename'};
	out{2} = {'Filename that has the thresholded input file (leave blank to choose on the fly)'};
	out{3} = {'choose_inputdlg'};
	return;
end;

if ischar(parameters),
	switch lower(parameters),
		case 'choose',
			out_choice = mia.image.process.thresholdimport;
			if numel(out_choice{3})==1,
				out = mia.image.process.thresholdimport(atd,input_itemname,output_itemname,out_choice{3}{1});
				return;
			end;
			choices = cat(2,out_choice{3},'Cancel');
			buttonname = questdlg('By which method should we choose parameters?',...
				'Which method?', choices{:},'Cancel');
			if ~strcmp(buttonname,'Cancel'),
				out = mia.image.process.thresholdimport(atd,input_itemname,output_itemname,buttonname);
			else,
				out = [];
			end;

		case {'choose_inputdlg'},
			out_p = mia.image.process.thresholdimport;
			default_parameters.input_filename = '';
			parameters = dlg2struct('Choose parameters',out_p{1},out_p{2},default_parameters);
			if isempty(parameters),
				out = [];
			else,
				out = mia.image.process.thresholdimport(atd,input_itemname,output_itemname,parameters);
			end;
	end;
	return;
end;

 % perform the thresholding

if isempty(parameters.input_filename),
	[fname,fpath] = uigetfile('*');
	parameters.input_filename = fullfile(fpath,fname);
end;

parameters.input_filename,
if isempty(parameters.input_filename),
	error(['no file selected.']);
end;

h = mia.miadir.gethistory(atd,'images',input_itemname);
h(end+1) = struct('parent',input_itemname,'operation','mia.creator.image.thresholdimport','parameters',parameters,...
	'description',['Applied threshold using file ' parameters.input_filename ' to image ' input_itemname '.']);

im_in_file = parameters.input_filename;

[dummy,image_raw_filename,ext] = fileparts(parameters.input_filename);

im_out_file = [mia.miadir.getpathname(atd) filesep 'images' filesep output_itemname filesep output_itemname ext];

input_finfo = imfinfo(im_in_file);

extra_args{1} = {'WriteMode','overwrite'};
extra_args{2} = {'WriteMode','append'};

for i=1:length(input_finfo),
	i,
	im = imread(im_in_file,'index',i,'info',input_finfo);
	if i==1,
		try,
			mkdir([mia.miadir.getpathname(atd) filesep 'images' filesep output_itemname]);
		end;
	end;
	im = logical(im > 0);
	imwrite(im,im_out_file,extra_args{1+double(i>1)}{:});
	str2text([mia.miadir.getpathname(atd) filesep 'images' filesep output_itemname filesep 'parent.txt'], input_itemname);
end;

mia.miadir.sethistory(atd,'images',output_itemname,h);

out = 1;

