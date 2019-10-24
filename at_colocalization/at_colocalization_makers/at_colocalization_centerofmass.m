function out = at_colocalization_centerofmass(atd, input_itemname, output_itemname, parameters)
% AT_COLOCALIZATION_CENTEROFMASS - Estimate colocalization by center-of-mass distance
% 
%  OUT = AT_COLOCALIZATION_CENTEROFMASS(ATD, INPUT_ITEMNAME, OUTPUT_ITEMNAME, PARAMETERS)
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
			out_choice = at_colocalization_centerofmass;
			choices = cat(2,out_choice{3},'Cancel');
			buttonname = questdlg('By which method should we choose parameters?',...
				'Which method?', choices{:},'Cancel');
			if ~strcmp(buttonname,'Cancel'),
				out = at_colocalization_centerofmass(atd,input_itemname,output_itemname,buttonname);
			else,
				out = [];
			end;
		case 'choose_inputdlg',
			out_p = at_colocalization_centerofmass;
			default_parameters.distance_threshold = 5;
			default_parameters.distance_infinity = 50;
			default_parameters.show_graphical_progress = 1;
			default_parameters.roi_set_2 = '';
			parameters = dlg2struct('Choose parameters',out_p{1},out_p{2},default_parameters);
			if isempty(parameters),
				out = [];
			else,
				if isempty(parameters.roi_set_2),
					itemliststruct = getitems(atd,'ROIs');
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
				out = at_colocalization_centerofmass(atd,input_itemname,output_itemname,parameters);
			end;
	end;
	return;
end;

 % now actually do it

 % Step 1: load the data
 %   Step 1A:
 %    need the roi files for the 2 channels

if parameters.show_graphical_progress, progressbar('Setting up for ROI overlap calculation'); end;

rois{1} = getroifilename(atd,input_itemname);
L{1} = getlabeledroifilename(atd,input_itemname);

if parameters.show_graphical_progress, progressbar(0.2); end;

rois{2} = getroifilename(atd,parameters.roi_set_2);
L{2} = getlabeledroifilename(atd,parameters.roi_set_2);

if parameters.show_graphical_progress, progressbar(0.4); end;

rois_{1} = load(rois{1},'-mat');
L_{1} = load(L{1},'-mat');
rois_{2} = load(rois{2},'-mat');
L_{2} = load(L{2},'-mat');

if parameters.show_graphical_progress, progressbar(0.6); end;

 %   Step 1B:
 %    need the RAW data files for the 2 channels

 % TODO: READ HERE

h{1} = gethistory(atd,'ROIs',input_itemname);
h{2} = gethistory(atd,'ROIs',parameters.roi_set_2);


for j=1:2,
	im_filename{j} = getimagefilename(atd, h{j}(1).parent);
	image_info{j} = imfinfo(im_filename{j});
	IM{j} = [];
	for i=1:numel(image_info{j}),
		IM{j} = cat(3,IM{j},at_image_read(im_filename{j},i,'iminfo',image_info{j}));
	end;
	if j==1&parameters.show_graphical_progress, progressbar(0.8); end;
end;

if parameters.show_graphical_progress, progressbar(0.9); end;

 % Step 2: compute 

 %   compute center-of-mass for all ROIs

 % TODO: WRITETHIS

com_a = regionprops(rois_{1}.CC, IM{1},'WeightedCentroid'); 
com_b = regionprops(rois_{2}.CC, IM{2}, 'WeightedCentroid');

com_a2 = cat(1,com_a.WeightedCentroid);
com_b2 = cat(1,com_b.WeightedCentroid);


if parameters.show_graphical_progress, progressbar(1); end;

if 0,
tic
stepsize = 1;


Is = [];
Js = [];
Vs = [];

for i=1:stepsize:size(com_a2,1),
	if mod(i,1000)==0, i, toc, end;
	distances_here = 0.1+sqrt(sum((repmat(com_a2(i,:)',1, size(com_b2,1)) - com_b2').^2));
	[justright_j] = find(distances_here<parameters.distance_infinity);
	Is = [Is; repmat(i,numel(justright_j),1)];
	Js = [Js; justright_j(:)];
	Vs = [Vs;colvec(distances_here(justright_j))];
end;

distances = sparse(Is,Js,Vs);
end;

tic,
[distances,Is,Js,Vs] = ROI_centerofmassdistance(com_a2, L_{1}.L, com_b2, L_{2}.L, parameters.distance_infinity, 0.1,'ShowGraphicalProgress',parameters.show_graphical_progress);
if parameters.show_graphical_progress,
	toc,
end;

overlaps = find(Vs>0 & Vs<= parameters.distance_threshold);

overlap_thresh = sparse(Is(overlaps),Js(overlaps),Vs(overlaps));

parameters.roi_set_1 = input_itemname;

com_a = com_a2;
com_b = com_b2;

colocalization_data = var2struct('distances','overlap_thresh','parameters','com_a','com_b');

 % step 3: save and add history

colocalizationdata_out_file = [getpathname(atd) filesep 'CLAs' filesep output_itemname filesep output_itemname '_CLA' '.mat'];

try, mkdir([getpathname(atd) filesep 'CLAs' filesep output_itemname]); end;
save(colocalizationdata_out_file,'colocalization_data','-mat');

overlapped_objects = numel(overlaps);

h = gethistory(atd,'images',input_itemname);
h(end+1) = struct('parent',input_itemname,'operation','at_colocalization_centerofmass','parameters',parameters,...
	'description',['Found ' int2str(overlapped_objects) ' CLs with distance threshold <= ' num2str(parameters.distance_threshold) ...
	' pixels of ROI ' input_itemname ' onto ROI ' parameters.roi_set_2 '.']);

sethistory(atd,'CLAs',output_itemname,h);

str2text([getpathname(atd) filesep 'CLAs' filesep output_itemname filesep 'parent.txt'], input_itemname);

out = 1;

