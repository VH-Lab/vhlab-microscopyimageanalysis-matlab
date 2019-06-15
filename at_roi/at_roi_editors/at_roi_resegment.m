function out = at_roi_resegment(atd, input_itemname, output_itemname, parameters)
% AT_ROI_COMBINE - Filter ROIs by volume
% 
%  OUT = AT_ROI_COMBINE(ATD, INPUT_ITEMNAME, OUTPUT_ITEMNAME, PARAMETERS)
%
%  If the function is called with no arguments, then a description of the parameters
%  is returned in OUT. OUT{1}{n} is the name of the nth parameter, and OUT{2}{n} is a
%  human-readable description of the parameter. 
%  OUT{3} is a list of methods for user-guided selection of these parameters.
%
%  The PARAMETERS for this function can just be empty, there are no parameters. All ROIs are
%  resegmented using ROI_RESEGMENT_ALL.
% 

if nargin==0,
	out{1} = {'resegment_algorithm','connectivity','values_outside_roi','use_bwdist','imagename'};
	out{2} = {'Algorithm to be used','connectivity (0 for default)', 'use values outside roi? 0/1', ...
			'use thresholded image instead of raw (0/1)?','Image name to use (leave blank to choose' };
	out{3} = {'choose_inputdlg'};
	return;
end;

if ischar(parameters),
	switch lower(parameters),
		case 'choose',
			out_choice = at_roi_resegment;
			choices = cat(2,out_choice{3},'Cancel');
			buttonname = questdlg('By which method should we choose parameters?',...
				'Which method?', choices{:},'Cancel');
			if ~strcmp(buttonname,'Cancel'),
				out = at_roi_resegment(atd,input_itemname,output_itemname,buttonname);
			else,
				out = [];
			end;
		case 'choose_inputdlg',
			out_p = at_roi_resegment;
			defaultparameters.resegment_algorithm = 'watershed';
			defaultparameters.connectivity = 0;
			defaultparameters.values_outside_roi = 0;
			defaultparameters.use_bwdist = 0;
			defaultparameters.imagename = '';
			parameters = dlg2struct('Choose parameters', out_p{1}, out_p{2}, defaultparameters);
			if isempty(parameters),
				out = [];
			else,
				out = at_roi_resegment(atd,input_itemname,output_itemname,parameters);
			end
	end; % switch
	return;
end;

 % edit this part

L_in_file = getlabeledroifilename(atd,input_itemname);
roi_in_file = getroifilename(atd,input_itemname);
load(roi_in_file,'CC','-mat');
load(L_in_file,'L','-mat');

oldobjects = CC.NumObjects;

if ischar(parameters.values_outside_roi),
	parameters.values_outside_roi = eval(parameters.values_outside_roi);
end; 
if ischar(parameters.use_bwdist),
	parameters.use_bwdist = eval(parameters.use_bwdist);
end; 

nvp = struct2namevaluepair(rmfield(parameters,'imagename'));

if isempty(parameters.imagename), % choose it 
	itemliststruct = getitems(atd,'images');
	if ~isempty(itemliststruct),
		itemlist_names = {itemliststruct.name};
	else,
		itemlist_names = {};
	end;
	itemlist_names = setdiff(itemlist_names,input_itemname);
	if isempty(itemlist_names),
		errordlg(['No image to choose for raw data.']);
		out = [];
		return;
	end;
	[selection,ok] = listdlg('PromptString','Select the raw image:',...
		'SelectionMode','single','ListString',itemlist_names);
	if ok,
		parameters.imagename = itemlist_names{selection};
	else,
		out = [];
		return;
	end;
end;

im_in_file = getimagefilename(atd,parameters.imagename);
[dummy,image_raw_filename,ext]=fileparts(im_in_file);
input_finfo = imfinfo(im_in_file);

im = double([]);
for i=1:length(input_finfo)
        newim = double(imread(im_in_file,'index',i,'info',input_finfo));
        im(:,:,i) = newim;
end;

[CC,L] = ROI_resegment_all(CC, L, im, 'resegment_namevaluepairs', nvp,'UseProgressBar',1);
newobjects = CC.NumObjects;

L_out_file = [getpathname(atd) filesep 'ROIs' filesep output_itemname filesep output_itemname '_L' '.mat'];
roi_out_file = [getpathname(atd) filesep 'ROIs' filesep output_itemname filesep output_itemname '_ROI' '.mat'];

try, mkdir([getpathname(atd) filesep 'ROIs' filesep output_itemname]); end;
save(roi_out_file,'CC','-mat');
save(L_out_file,'L','-mat');

h = gethistory(atd,'ROIs',input_itemname);
h(end+1) = struct('parent',input_itemname,'operation','at_roi_resegment','parameters',parameters,...
	'description',['Resegmented ' int2str(oldobjects) ' ROIs into ' int2str(newobjects) ' from ' input_itemname '.']);
sethistory(atd,'ROIs',output_itemname,h);

str2text([getpathname(atd) filesep 'ROIs' filesep output_itemname filesep 'parent.txt'], input_itemname);

out = 1;

