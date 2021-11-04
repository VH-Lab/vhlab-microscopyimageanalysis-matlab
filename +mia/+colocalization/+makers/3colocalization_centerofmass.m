function out = 3colocalization_centerofmass(atd, input_itemname, output_itemname, parameters)
% 3COLOCALIZATION_CENTEROFMASS - Estimate colocalization by center-of-mass distance, triple
% 
%  OUT = MIA.COLOCALIZATION.MAKERS.3COLOCALIZATION_CENTEROFMASS(ATD, INPUT_ITEMNAME, OUTPUT_ITEMNAME, PARAMETERS)
%
%  If the function is called with no arguments, then a description of the parameters
%  is returned in OUT. OUT{1}{n} is the name of the nth parameter, and OUT{2}{n} is a
%  human-readable description of the parameter. 
%  OUT{3} is a list of methods for user-guided selection of these parameters.
% 

if nargin==0,
	out{1} = {'distance_threshold','distance_infinity', 'show_graphical_progress', 'roi_set_2', 'roi_set_3'};
	out{2} = {'Distance threshold (pixels) that determines when 2 ROIs will be considered colocalized.' , ...
		'Distance at which ROIs are considered very far apart (saves memory)', ...
		'0/1 Should we show a progress bar?', ...
		'Name of second ROI set with which to compute overlap (leave blank to choose)', ...
		'Name of third ROI set with which to compute overlap (leave blank to choose)'};
	out{3} = {'choose_inputdlg'};
	return;
end;

if ischar(parameters),
	switch lower(parameters),
		case 'choose',
			out_choice = mia.colocalization.makers.3colocalization_centerofmass;
			choices = cat(2,out_choice{3},'Cancel');
			buttonname = questdlg('By which method should we choose parameters?',...
				'Which method?', choices{:},'Cancel');
			if ~strcmp(buttonname,'Cancel'),
				out = mia.colocalization.makers.3colocalization_centerofmass(atd,input_itemname,output_itemname,buttonname);
			else,
				out = [];
			end;
		case 'choose_inputdlg',
			out_p = mia.colocalization.makers.3colocalization_centerofmass;
			default_parameters.distance_threshold = 5;
			default_parameters.distance_infinity = 50;
			default_parameters.show_graphical_progress = 1;
			default_parameters.roi_set_2 = '';
			default_parameters.roi_set_3 = '';
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
				if isempty(parameters.roi_set_3),
					itemliststruct = mia.miadir.getitems(atd,'ROIs');
					if ~isempty(itemliststruct), 
						itemlist_names = {itemliststruct.name};
					else,
						itemlist_names = {};
					end;
					itemlist_names = setdiff(itemlist_names,input_itemname);
					if isempty(itemlist_names),
						errordlg(['No additional ROIs to choose for 3rd set.']);
						out = [];
						return;
					end;
					[selection,ok] = listdlg('PromptString','Select the 3rd ROI set:',...
						'SelectionMode','single','ListString',itemlist_names);
					if ok,
						parameters.roi_set_3 = itemlist_names{selection};
					else,
						out = [];
						return;
					end;
				end;

				out = mia.colocalization.makers.3colocalization_centerofmass(atd,input_itemname,output_itemname,parameters);
			end;
	end;
	return;
end;

 % now actually do it

 % Step 1: load the data
 %   Step 1A:
 %    need the roi files for the 3 channels

if parameters.show_graphical_progress, progressbar('Setting up for ROI overlap calculation'); end;

rois{1} = mia.miadir.getroifilename(atd,input_itemname);
L{1} = getlabeledroifilename(atd,input_itemname);
try,
	roipfilename{1} = mia.miadir.getroiparametersfilename(atd, input_itemname);
	if isempty(roipfilename{1}), error('filename is empty.'); end;
catch,
	mia.roi.functions.parameters(atd,rois{1});
	roipfilename{1} = mia.miadir.getroiparametersfilename(atd, input_itemname);
end;

if parameters.show_graphical_progress, progressbar(0.2); end;

rois{2} = mia.miadir.getroifilename(atd,parameters.roi_set_2);
L{2} = getlabeledroifilename(atd,parameters.roi_set_2);
try,
	roipfilename{2} = mia.miadir.getroiparametersfilename(atd, parameters.roi_set_2);
    if isempty(roipfilename{2}), error(['file is empty.']); end;
catch,
	mia.roi.functions.parameters(atd,rois{2});
	roipfilename{2} = mia.miadir.getroiparametersfilename(atd, parameters.roi_set_2);
end

if parameters.show_graphical_progress, progressbar(0.3); end;

rois{3} = mia.miadir.getroifilename(atd,parameters.roi_set_3);
L{3} = getlabeledroifilename(atd,parameters.roi_set_3);
try,
	roipfilename{3} = mia.miadir.getroiparametersfilename(atd, parameters.roi_set_3);
    if isempty(roipfilename{3}), error(['file is empty.']); end;
catch,
	mia.roi.functions.parameters(atd,rois{3});
	roipfilename{3} = mia.miadir.getroiparametersfilename(atd, parameters.roi_set_3);
end

if parameters.show_graphical_progress, progressbar(0.4); end;

rois_{1} = load(rois{1},'-mat');
L_{1} = load(L{1},'-mat');
rois_{2} = load(rois{2},'-mat');
L_{2} = load(L{2},'-mat');
rois_{3} = load(rois{3},'-mat');
L_{3} = load(L{3},'-mat');

ROIp{1} = load(roipfilename{1},'-mat');
ROIp{2} = load(roipfilename{2},'-mat');
ROIp{3} = load(roipfilename{3},'-mat');

if parameters.show_graphical_progress, progressbar(0.6); end;

if parameters.show_graphical_progress, progressbar(0.9); end;

if parameters.show_graphical_progress, progressbar(1); end;

stepsize = 1;

tic,
[distances_ab,Is_ab,Js_ab,Vs_ab] = ROI_centerofmassdistance(cat(1,ROIp{1}.ROIparameters.params3d.WeightedCentroid) , L_{1}.L, ...
		cat(1,ROIp{2}.ROIparameters.params3d.WeightedCentroid), L_{2}.L, parameters.distance_infinity, ...
		0.1,'ShowGraphicalProgress',parameters.show_graphical_progress);

[distances_bc,Is_bc,Js_bc,Vs_bc] = ROI_centerofmassdistance(cat(1,ROIp{2}.ROIparameters.params3d.WeightedCentroid) , L_{2}.L, ...
		cat(1,ROIp{3}.ROIparameters.params3d.WeightedCentroid), L_{3}.L, parameters.distance_infinity, ...
		0.1,'ShowGraphicalProgress',parameters.show_graphical_progress);

[distances_ac,Is_ac,Js_ac,Vs_ac] = ROI_centerofmassdistance(cat(1,ROIp{1}.ROIparameters.params3d.WeightedCentroid) , L_{1}.L, ...
		cat(1,ROIp{3}.ROIparameters.params3d.WeightedCentroid), L_{3}.L, parameters.distance_infinity, ...
		0.1,'ShowGraphicalProgress',parameters.show_graphical_progress);
if parameters.show_graphical_progress,
	toc,
end;

overlaps = ( (distances_ab > 0 & distances_ab <= parameters.distance_threshold) * ...
		(distances_bc > 0 & distances_bc <= parameters.distance_threshold) ) .* ...
		(distances_ac>0&distances_ac<=parameters.distance_threshold);

overlap_thresh = sum(overlaps,2)>0;

parameters.roi_set_1 = input_itemname;

colocalization_data = var2struct('distances_ac','distances_ac','distances_bc','overlap_thresh','parameters');

 % step 3: save and add history

colocalizationdata_out_file = [mia.miadir.getpathname(atd) filesep 'CLAs' filesep output_itemname filesep output_itemname '_CLA' '.mat'];

try, mkdir([mia.miadir.getpathname(atd) filesep 'CLAs' filesep output_itemname]); end;
save(colocalizationdata_out_file,'colocalization_data','-mat');

overlapped_objects = numel(find(overlap_thresh));

h = mia.miadir.gethistory(atd,'images',input_itemname);
h(end+1) = struct('parent',input_itemname,'operation','mia.colocalization.makers.centerofmass','parameters',parameters,...
	'description',['Found ' int2str(overlapped_objects) ' CLs with distance threshold <= ' num2str(parameters.distance_threshold) ...
	' pixels of ROI ' input_itemname ' onto ROI ' parameters.roi_set_2 ' and ROI ' parameters.roi_set_3 '.']);

mia.miadir.sethistory(atd,'CLAs',output_itemname,h);

str2text([mia.miadir.getpathname(atd) filesep 'CLAs' filesep output_itemname filesep 'parent.txt'], input_itemname);

out = 1;

