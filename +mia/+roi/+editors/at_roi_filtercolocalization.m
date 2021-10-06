function out = at_roi_filtercolocalization(atd, input_itemname, output_itemname, parameters)
% AT_ROI_FILTERCOLOCALIZATION - Filter ROIs by volume
% 
%  OUT = mia.roi.roi_editors.at_roi_filtercolocalization(ATD, INPUT_ITEMNAME, OUTPUT_ITEMNAME, PARAMETERS)
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
	out{1} = {'colocalization_name','include_overlaps'};
	out{2} = {'Name of colocalization record to use to filter ROIs','Should we include ROIs that overlap (or exclude) (0/1)?'};
	out{3} = {'choose_inputdlg'};
	return;
end;

if ischar(parameters),
	switch lower(parameters),
		case 'choose',
			out_choice = mia.roi.roi_editors.at_roi_filtercolocalization;
			choices = cat(2,out_choice{3},'Cancel');
			buttonname = questdlg('By which method should we choose parameters?',...
				'Which method?', choices{:},'Cancel');
			if ~strcmp(buttonname,'Cancel'),
				out = mia.roi.roi_editors.at_roi_filtercolocalization(atd,input_itemname,output_itemname,buttonname);
			else,
				out = [];
			end;
		case 'choose_inputdlg',
			out_p = mia.roi.roi_editors.at_roi_filtercolocalization;
			defaultparameters.colocalization_name = '';
			defaultparameters.include_overlaps = 1;
			parameters = dlg2struct('Choose parameters', out_p{1}, out_p{2}, defaultparameters);
			if isempty(parameters),
				out = [];
			else,
				out = mia.roi.roi_editors.at_roi_filtercolocalization(atd,input_itemname,output_itemname,parameters);
			end
	end; % switch
	return;
end;

L_in_file = getlabeledroifilename(atd,input_itemname);
roi_in_file = getroifilename(atd,input_itemname);
load(roi_in_file,'CC','-mat');
load(L_in_file,'L','-mat');

oldobjects = CC.NumObjects;

if ~isempty(parameters.include_overlaps), % DLW
include_overlaps = parameters.include_overlaps;
end

if ~isempty(parameters.colocalization_name), % DLW
    cfile = getcolocalizationfilename(atd,parameters.colocalization_name);
    load(cfile,'colocalization_data','-mat');
    
elseif 0, % ask the user to choose it
	itemliststruct = getitems(atd,'CLAs');
	if ~isempty(itemliststruct),
		itemlist_names = {itemliststruct.name};
	else,
		itemlist_names = {};
	end;
	itemlist_names = setdiff(itemlist_names,input_itemname);
	if isempty(itemlist_names),
		errordlg(['No CLAs to choose for raw data.']);
		out = [];
		return;
	end;
	[selection,ok] = listdlg('PromptString','Select the colocalizations image:',...
		'SelectionMode','single','ListString',itemlist_names);
	if ok,
		parameters.colocalization_name = itemlist_names{selection};
	else,
		out = [];
		return;
	end;
end;

% DLW
if include_overlaps == 1;
[A B] = find(colocalization_data.overlap_thresh);
CC.NumObjects = size(A,1); 
CC.PixelIdxList = CC.PixelIdxList(A);
L = labelmatrix(CC);
newobjects = CC.NumObjects;

elseif include_overlaps == 0,
[A B] = find(colocalization_data.overlap_thresh);
comp = [1:CC.NumObjects];
A = setdiff(comp,A)';
CC.NumObjects = size(A,1); 
CC.PixelIdxList = CC.PixelIdxList(A);
L = labelmatrix(CC);
newobjects = CC.NumObjects;
end
% end DLW

L_out_file = [getpathname(atd) filesep 'ROIs' filesep output_itemname filesep output_itemname '_L' '.mat'];
roi_out_file = [getpathname(atd) filesep 'ROIs' filesep output_itemname filesep output_itemname '_ROI' '.mat'];

try,
	mkdir([getpathname(atd) filesep 'ROIs' filesep output_itemname]);
end;

save(roi_out_file,'CC','-mat');
save(L_out_file,'L','-mat');

h = gethistory(atd,'ROIs',input_itemname);
h(end+1) = struct('parent',input_itemname,'operation','mia.roi.roi_editors.at_roi_filtercolocalization','parameters',parameters,...
	'description',['Filtered by colocalization: ' int2str(oldobjects) ' ROIs became ' int2str(newobjects) ' from ' input_itemname '.']);
sethistory(atd,'ROIs',output_itemname,h);

str2text([getpathname(atd) filesep 'ROIs' filesep output_itemname filesep 'parent.txt'], input_itemname);

mia.roi.roi_functions.at_roi_parameters(atd,roi_out_file);

out = 1;
