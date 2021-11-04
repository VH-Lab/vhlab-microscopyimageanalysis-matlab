function out = connect(atd, input_itemname, output_itemname, parameters)
% CONNECT - Use BWCONNCOMP to compute ROIs from thresholded image
% 
%  OUT = MIA.ROI.MAKERS.CONNECT(ATD, INPUT_ITEMNAME, OUTPUT_ITEMNAME, PARAMETERS)
%
%  If the function is called with no arguments, then a description of the parameters
%  is returned in OUT. OUT{1}{n} is the name of the nth parameter, and OUT{2}{n} is a
%  human-readable description of the parameter. 
%  OUT{3} is a list of methods for user-guided selection of these parameters.
% 

if nargin==0,
	out{1} = {'connectivity'};
	out{2} = {'Connectivity to examine, such as 6, 18, 26 (see help bwconncomp)'};
	out{3} = {'choose_inputdlg'};
	return;
end;

if ischar(parameters),
	switch lower(parameters),
		case 'choose',
			out_choice = mia.roi.makers.connect;
			choices = cat(2,out_choice{3},'Cancel');
			buttonname = questdlg('By which method should we choose parameters?',...
				'Which method?', choices{:},'Cancel');
			if ~strcmp(buttonname,'Cancel'),
				out = mia.roi.makers.connect(atd,input_itemname,output_itemname,buttonname);
			else,
				out = [];
			end;
		case 'choose_inputdlg',
			out_p = mia.roi.makers.connect;
			default_parameters.connectivity = 6;
			parameters = dlg2struct('Choose parameters',out_p{1},out_p{2},default_parameters);
			if isempty(parameters),
				out = [];
			else,
				out = mia.roi.makers.connect(atd,input_itemname,output_itemname,parameters);
			end;
	end;
	return;
end;


im_in_file = mia.miadir.getimagefilename(atd,input_itemname);
[dummy,image_raw_filename,ext]=fileparts(im_in_file);

L_out_file = [mia.miadir.getpathname(atd) filesep 'ROIs' filesep output_itemname filesep output_itemname '_L' '.mat'];
roi_out_file = [mia.miadir.getpathname(atd) filesep 'ROIs' filesep output_itemname filesep output_itemname '_ROI' '.mat'];

input_finfo = imfinfo(im_in_file);

im = logical([]);
for i=1:length(input_finfo)
	newim = logical(imread(im_in_file,'index',i,'info',input_finfo));
	im(:,:,i) = newim;
end;

CC = bwconncomp(im,parameters.connectivity);
L = labelmatrix(CC);

try, mkdir([mia.miadir.getpathname(atd) filesep 'ROIs' filesep output_itemname]); end;
save(roi_out_file,'CC','-mat');
save(L_out_file,'L','-mat');

h = mia.miadir.gethistory(atd,'images',input_itemname);
h(end+1) = struct('parent',input_itemname,'operation','mia.roi.makers.connect','parameters',parameters,...
	'description',['Found ' int2str(CC.NumObjects) ' ROIs with conn=' num2str(parameters.connectivity) ' to image ' input_itemname '.']);
mia.miadir.sethistory(atd,'ROIs',output_itemname,h);

str2text([mia.miadir.getpathname(atd) filesep 'ROIs' filesep output_itemname filesep 'parent.txt'], input_itemname);

mia.roi.functions.parameters(atd,roi_out_file);

out = 1;

