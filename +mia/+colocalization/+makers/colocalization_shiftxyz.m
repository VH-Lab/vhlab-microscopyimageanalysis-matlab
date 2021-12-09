function out = colocalization_shiftxyz(atd, input_itemname, output_itemname, parameters)
% COLOCALIZATION_SHIFTXYZ - Use BWCONNCOMP to compute ROIs from thresholded image
% 
%  OUT = MIA.COLOCALIZATION.MAKERS.COLOCALIZATION_SHIFTXYZ(ATD, INPUT_ITEMNAME, OUTPUT_ITEMNAME, PARAMETERS)
%
%  If the function is called with no arguments, then a description of the parameters
%  is returned in OUT. OUT{1}{n} is the name of the nth parameter, and OUT{2}{n} is a
%  human-readable description of the parameter. 
%  OUT{3} is a list of methods for user-guided selection of these parameters.
% 

if nargin==0,
	out{1} = {'shiftsX','shiftsY','shiftsZ','threshold','roi_set_2'};
	out{2} = {'Shifts in X to examine (such as [-2:2])',...
    'Shifts in Y to examine (such as [-2:2])',...
    'Shifts in Z to examine (such as [-2:2])',...
		'Percent by which ROIs must overlap to be called ''colocalized''',...
		'Name of second ROI set with which to compute overlap (leave blank to choose)'};
	out{3} = {'choose_inputdlg'};
	return;
end;

if ischar(parameters),
	switch lower(parameters),
		case 'choose',
			out_choice = mia.colocalization.makers.colocalization_shiftxyz;
			choices = cat(2,out_choice{3},'Cancel');
			buttonname = questdlg('By which method should we choose parameters?',...
				'Which method?', choices{:},'Cancel');
			if ~strcmp(buttonname,'Cancel'),
				out = mia.colocalization.makers.colocalization_shiftxyz(atd,input_itemname,output_itemname,buttonname);
			else,
				out = [];
			end;
		case 'choose_inputdlg',
			out_p = mia.colocalization.makers.shiftxyz;
			default_parameters.shiftsX= -2:2;
			default_parameters.shiftsY= -2:2;
			default_parameters.shiftsZ=  0;
			default_parameters.threshold = 0.33;
			default_parameters.roi_set_2 = '';
			parameters = dlg2struct('Choose parameters',out_p{1},out_p{2},default_parameters);
			if isempty(parameters),
				out = [];
			else,
				if isempty(parameters.roi_set_2),
					itemliststruct = mia.miadir.getitems(atd,'ROIs');
					if ~isempty(itemliststruct), 
						itemlist_names = {itemliststruct.name};
					else,
						itemlist_names = {};
					end;
					itemlist_names = setdiff(itemlist_names,input_itemname);
					if isempty(itemlist_names),
						errordlg(['No additional ROIs to choose for 2nd set.']);
						out = [];
						return;
					end;
					[selection,ok] = listdlg('PromptString','Select the 2nd ROI set:',...
						'SelectionMode','single','ListString',itemlist_names);
					if ok,
						parameters.roi_set_2 = itemlist_names{selection};
					else,
						out = [];
						return;
					end;
				end;
				out = mia.colocalization.makers.colocalization_shiftxyz(atd,input_itemname,output_itemname,parameters);
			end;
	end;
	return;
end;

 % now actually do it

 % step 1: load the data

rois{1} = mia.miadir.getroifilename(atd,input_itemname);
L{1} = mia.miadir.getlabeledroifilename(atd,input_itemname);

rois{2} = mia.miadir.getroifilename(atd,parameters.roi_set_2);
L{2} = mia.miadir.getlabeledroifilename(atd,parameters.roi_set_2);

rois_{1} = load(rois{1},'-mat');
L_{1} = load(L{1},'-mat');
rois_{2} = load(rois{2},'-mat');
L_{2} = load(L{2},'-mat');


 % step 2: compute 

[overlap_ab, overlap_ba] = ROI_3d_all_overlaps(rois_{1}.CC, L_{1}.L, rois_{2}.CC, L_{2}.L, parameters.shiftsX, parameters.shiftsY, parameters.shiftsZ);

search_size = size(overlap_ab,3)*size(overlap_ab,4)*size(overlap_ab,5);

overlap_thresh = overlap_ab >= parameters.threshold;

parameters.roi_set_1 = input_itemname;

colocalization_data = var2struct('overlap_ab','overlap_ba','overlap_thresh','parameters');

 % step 3: save and add history

colocalizationdata_out_file = [mia.miadir.getpathname(atd) filesep 'CLAs' filesep output_itemname filesep output_itemname '_CLA' '.mat'];

try, mkdir([mia.miadir.getpathname(atd) filesep 'CLAs' filesep output_itemname]); end;
save(colocalizationdata_out_file,'colocalization_data','-mat');

overlapped_objects = sum(overlap_thresh(:));

h = mia.miadir.gethistory(atd,'images',input_itemname);
h(end+1) = struct('parent',input_itemname,'operation','mia.colocalization.makers.colocalization_shiftxyz','parameters',parameters,...
	'description',['Found ' int2str(overlapped_objects) ' CLs with threshold = ' num2str(parameters.threshold) ' of ROI ' input_itemname ' onto ROI ' parameters.roi_set_2 '.']);

mia.miadir.sethistory(atd,'CLAs',output_itemname,h);

str2text([mia.miadir.getpathname(atd) filesep 'CLAs' filesep output_itemname filesep 'parent.txt'], input_itemname);

out = 1;
