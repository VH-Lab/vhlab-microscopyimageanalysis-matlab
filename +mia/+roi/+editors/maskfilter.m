function out = maskfilter(atd, input_itemname, output_itemname, parameters)
% VOLUMEFILTER - Filter ROIs by volume
% 
%  OUT = MIA.ROI.EDITORS.VOLUMEFILTER(ATD, INPUT_ITEMNAME, OUTPUT_ITEMNAME, PARAMETERS)
%
%  If the function is called with no arguments, then a description of the parameters
%  is returned in OUT. OUT{1}{n} is the name of the nth parameter, and OUT{2}{n} is a
%  human-readable description of the parameter. 
%  OUT{3} is a list of methods for user-guided selection of these parameters.
% 
 
if nargin==0,
	out{1} = {'mask_file'};
	out{2} = {'Mask file (leave blank to choose)'};
	out{3} = {'choose_inputdlg'};
	return;
end;

if ischar(parameters),
	switch lower(parameters),
		case 'choose',
			out = mia.roi.editors.maskfilter(atd,input_itemname,output_itemname,'choose_inputdlg');
		case 'choose_inputdlg',
			out_p = mia.roi.editors.maskfilter;
			default_parameters.mask_file = '';
			parameters = dlg2struct('Choose parameters',out_p{1},out_p{2},default_parameters);
			if isempty(parameters),
				out = [];
			else,
				out = mia.roi.editors.maskfilter(atd,input_itemname,output_itemname,parameters);
			end;
	end;
	return;
end;

 % edit this part

if isempty(parameters.mask_file),
        [fname,fpath] = uigetfile('*');
        parameters.mask_file = fullfile(fpath,fname);
end;

input_finfo = imfinfo(parameters.mask_file);
im = [];
for i=1:numel(input_finfo),
	im = cat(3,im,imread(parameters.mask_file,'index',i,'info',input_finfo));
end;

L_in_file = getlabeledroifilename(atd,input_itemname);
roi_in_file = mia.miadir.getroifilename(atd,input_itemname);
load(roi_in_file,'CC','-mat');
load(L_in_file,'L','-mat');

good_indexes = setdiff(unique(L(find(im>0))),0);

h = mia.miadir.gethistory(atd,'ROIs',input_itemname),
h(end+1) = struct('parent',input_itemname,'operation','mia.roi.editors.maskfilter','parameters',parameters,...
	'description',['Filtered all but ' int2str(numel(good_indexes)) ' ROIs based on ' parameters.mask_file ' of ROIS ' input_itemname '.']);

mia.roi.functions.savesubset(atd,input_itemname, good_indexes, output_itemname, h);

out = 1;

