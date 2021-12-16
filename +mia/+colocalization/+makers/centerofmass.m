function out = centerofmass(mdir, input_itemname, output_itemname, parameters)
% CENTEROFMASS - Estimate colocalization by center-of-mass distance
% 
%  OUT = MIA.COLOCALIZATION.MAKERS.CENTEROFMASS(MDIR, INPUT_ITEMNAME, OUTPUT_ITEMNAME, PARAMETERS)
%
%  If the function is called with no arguments, then a description of the parameters
%  is returned in OUT. OUT{1}{n} is the name of the nth parameter, and OUT{2}{n} is a
%  human-readable description of the parameter. 
%  OUT{3} is a list of methods for user-guided selection of these parameters.
% 

if nargin==0,
	out{1} = {'distance_threshold','distance_infinity', 'show_graphical_progress', 'roi_set_2'};
	out{2} = {'Distance threshold (pixels) that determines when 2 ROIs will be considered colocalized.' , 'Distance at which ROIs are considered very far apart (saves memory)', '0/1 Should we show a progress bar?', 'Name of second ROI set with which to compute overlap (leave blank to choose)'};
	out{3} = {'choose_inputdlg'};
	return;
end;

if ischar(parameters),
	switch lower(parameters),
		case 'choose',
			out_choice = mia.colocalization.makers.centerofmass;
			choices = cat(2,out_choice{3},'Cancel');
			buttonname = questdlg('By which method should we choose parameters?',...
				'Which method?', choices{:},'Cancel');
			if ~strcmp(buttonname,'Cancel'),
				out = mia.colocalization.makers.centerofmass(mdir,input_itemname,output_itemname,buttonname);
			else,
				out = [];
			end;
		case 'choose_inputdlg',
			out_p = mia.colocalization.makers.centerofmass;
			default_parameters.distance_threshold = 5;
			default_parameters.distance_infinity = 50;
			default_parameters.show_graphical_progress = 1;
			default_parameters.roi_set_2 = '';
			parameters = dlg2struct('Choose parameters',out_p{1},out_p{2},default_parameters);
			if isempty(parameters),
				out = [];
			else,
				if isempty(parameters.roi_set_2),
					itemliststruct = mdir.getitems('ROIs');
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
				out = mia.colocalization.makers.centerofmass(mdir,input_itemname,output_itemname,parameters);
			end;
	end;
	return;
end;

 % now actually do it

 % Step 1: load the data
 %   Step 1A:
 %    need the roi files for the 2 channels

if parameters.show_graphical_progress, progressbar('Setting up for ROI overlap calculation'); end;

rois{1} = mdir.getroifilename(input_itemname);
L{1} = mdir.getlabeledroifilename(input_itemname);
try,
	roipfilename{1} = mdir.getroiparametersfilename(input_itemname);
	if isempty(roipfilename{1}), error('filename is empty.'); end;
catch,
	mia.roi.functions.parameters(mdir,rois{1});
	roipfilename{1} = mdir.getroiparametersfilename(input_itemname);
end;

if parameters.show_graphical_progress, progressbar(0.2); end;

rois{2} = mdir.getroifilename(parameters.roi_set_2);
L{2} = mdir.getlabeledroifilename(parameters.roi_set_2);
try,
	roipfilename{2} = mdir.getroiparametersfilename(parameters.roi_set_2);
catch,
	mia.roi.functions.parameters(mdir,rois{2});
	roipfilename{2} = mdir.getroiparametersfilename(parameters.roi_set_2);
end

if parameters.show_graphical_progress, progressbar(0.4); end;

rois_{1} = load(rois{1},'-mat');
L_{1} = load(L{1},'-mat');
rois_{2} = load(rois{2},'-mat');
L_{2} = load(L{2},'-mat');
ROIp{1} = load(roipfilename{1},'-mat');
ROIp{2} = load(roipfilename{2},'-mat');

if parameters.show_graphical_progress, progressbar(0.6); end;

if parameters.show_graphical_progress, progressbar(0.9); end;

if parameters.show_graphical_progress, progressbar(1); end;

stepsize = 1;

tic,
[distances,Is,Js,Vs] = ROI_centerofmassdistance(cat(1,ROIp{1}.ROIparameters.params3d.WeightedCentroid) , L_{1}.L, ...
		cat(1,ROIp{2}.ROIparameters.params3d.WeightedCentroid), L_{2}.L, parameters.distance_infinity, ...
		0.1,'ShowGraphicalProgress',parameters.show_graphical_progress);

if parameters.show_graphical_progress,
	toc,
end;

overlaps = find(Vs>0 & Vs<= parameters.distance_threshold);

overlap_thresh = sparse(Is(overlaps),Js(overlaps),Vs(overlaps));

parameters.roi_set_1 = input_itemname;

colocalization_data = var2struct('distances','overlap_thresh','parameters');

 % step 3: save and add history

colocalizationdata_out_file = [mdir.getpathname() filesep 'CLAs' filesep output_itemname filesep output_itemname '_CLA' '.mat'];

try, mkdir([mdir.getpathname() filesep 'CLAs' filesep output_itemname]); end;
save(colocalizationdata_out_file,'colocalization_data','-mat');

overlapped_objects = numel(overlaps);

h = mdir.gethistory('images',input_itemname);
h(end+1) = struct('parent',input_itemname,'operation','mia.colocalization.makers.centerofmass','parameters',parameters,...
	'description',['Found ' int2str(overlapped_objects) ' CLs with distance threshold <= ' num2str(parameters.distance_threshold) ...
	' pixels of ROI ' input_itemname ' onto ROI ' parameters.roi_set_2 '.']);

mdir.sethistory('CLAs',output_itemname,h);

str2text([mdir.getpathname() filesep 'CLAs' filesep output_itemname filesep 'parent.txt'], input_itemname);

out = 1;

