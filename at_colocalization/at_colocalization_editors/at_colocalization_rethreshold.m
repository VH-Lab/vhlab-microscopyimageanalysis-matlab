function out = at_colocalization_rethreshold(atd, input_itemname, output_itemname, parameters)
% AT_COLOCALIZATION_RETHRESHOLD - Redo colocalization labeling by changing threshold
% 
%  OUT = AT_COLOCALIZATION_RETHRESHOLD(ATD, INPUT_ITEMNAME, OUTPUT_ITEMNAME, PARAMETERS)
%
%  If the function is called with no arguments, then a description of the parameters
%  is returned in OUT. OUT{1}{n} is the name of the nth parameter, and OUT{2}{n} is a
%  human-readable description of the parameter. 
%  OUT{3} is a list of methods for user-guided selection of these parameters.
% 

if nargin==0,
	out{1} = {'threshold'};
	out{2} = {'threshold of ROI overlap to label as colocalization'}
	out{3} = {'choose_inputdlg'};
	return;
end;

if ischar(parameters),
	switch lower(parameters),
		case 'choose',
			out_choice = at_colocalization_rethreshold;
			choices = cat(2,out_choice{3},'Cancel');
			buttonname = questdlg('By which method should we choose parameters?',...
				'Which method?', choices{:},'Cancel');
			if ~strcmp(buttonname,'Cancel'),
				out = at_colocalization_rethreshold(atd,input_itemname,output_itemname,buttonname);
			else,
				out = [];
			end;
		case 'choose_inputdlg',
			out_p = at_colocalization_rethreshold;
			default_parameters.threshold = 0.33;
			parameters = dlg2struct('Choose parameters',out_p{1},out_p{2},default_parameters);
			if isempty(parameters),
				out = [];
			else,
				out = at_colocalization_rethreshold(atd,input_itemname,output_itemname,parameters);
			end;

	end;
	return;
end;

 % edit this part

cfile = getcolocalizationfilename(atd,input_itemname);

load(cfile,'colocalization_data','-mat');

parent = getparent(atd, 'CLAs', input_itemname);
allrois = getitems(atd, 'ROIs');

if ~isfield(colocalization_data.parameters,'roi_set_1') & ~isempty(intersect(parent,{allrois.name})),
	colocalization_data.parameters.roi_set_1 = parent;
end;

colocalization_data.parameters.threshold = parameters.threshold;
colocalization_data.overlap_thresh = colocalization_data.overlap_ab >= parameters.threshold;

overlapped_objects = sum(colocalization_data.overlap_thresh(:));

colocalization_out_file = [getpathname(atd) filesep 'CLAs' filesep output_itemname filesep output_itemname '_CLA' '.mat'];

try, mkdir([getpathname(atd) filesep 'CLAs' filesep output_itemname]); end;
save(colocalization_out_file,'colocalization_data','-mat');

h = gethistory(atd,'CLAs',input_itemname),
h(end+1) = struct('parent',input_itemname,'operation','at_colocalization_rethreshold','parameters',parameters,...
	'description',['Rethresholded with new threshold ' num2str(parameters.threshold) '. Found ' int2str(overlapped_objects) ' CLs.' ]);
sethistory(atd,'CLAs',output_itemname,h);

str2text([getpathname(atd) filesep 'CLAs' filesep output_itemname filesep 'parent.txt'], input_itemname);

out = 1;

