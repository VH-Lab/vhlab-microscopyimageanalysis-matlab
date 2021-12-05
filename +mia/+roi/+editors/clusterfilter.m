function out = clusterfilter(atd, input_itemname, output_itemname, parameters)
% VOLUMEFILTER - Filter ROIs by volume
% 
%  OUT = MIA.ROI.EDITORS.CLUSTERFILTER(ATD, INPUT_ITEMNAME, OUTPUT_ITEMNAME, PARAMETERS)
%
%  If the function is called with no arguments, then a description of the parameters
%  is returned in OUT. OUT{1}{n} is the name of the nth parameter, and OUT{2}{n} is a
%  human-readable description of the parameter. 
%  OUT{3} is a list of methods for user-guided selection of these parameters.
% 
 
if nargin==0,
	out{1} = {'indexes_to_include'};
	out{2} = {'Indexes of ROIs to include'};
	out{3} = {'choose_inputdlg','choose_graphical'};
	return;
end;

if ischar(parameters),
	switch lower(parameters),
		case 'choose',
			out_choice = mia.roi.editors.clusterfilter;
			choices = cat(2,out_choice{3},'Cancel');
			buttonname = questdlg('By which method should we choose parameters?',...
				'Which method?', choices{:},'Cancel');
			if ~strcmp(buttonname,'Cancel'),
				out = mia.roi.editors.clusterfilter(atd,input_itemname,output_itemname,buttonname);
			else,
				out = [];
			end;
		case 'choose_inputdlg',
			out_p = mia.roi.editors.clusterfilter;
			default_parameters.indexes_to_include = 1;
			parameters = dlg2struct('Choose parameters',out_p{1},out_p{2},default_parameters);
			if isempty(parameters),
				out = [];
			else,
				out = mia.roi.editors.clusterfilter(atd,input_itemname,output_itemname,parameters);
			end;
		case 'choose_graphical',
			out = [];
			roi_pfile = mia.miadir.getroiparametersfilename(atd,input_itemname);
			ROIp = load(roi_pfile,'-mat');
			o = mia.roi.functions.parameters2struct(ROIp.ROIparameters);
			
			[cl,ci] = cluster_points_gui('points',o);

			if isempty(cl), return; end;

			indexes = [];

			for i=1:numel(ci),
				if strcmpi(ci(i).qualitylabel,'Usable'),
					indexes = [indexes(:) ; colvec(find(cl==i))];
				end;
			end;

			parameters = [];
			parameters.indexes_to_include = indexes;
			out = mia.roi.editors.clusterfilter(atd,input_itemname,output_itemname,parameters);
	end;
	return;
end;

h = atd.gethistory(atd,'ROIs',input_itemname);
h(end+1) = struct('parent',input_itemname,'operation','mia.roi.editors.clusterfilter','parameters',parameters,...
	'description',['Filtered all but ' int2str(numel(parameters.indexes_to_include)) ' of ROIS ' input_itemname '.']);

mia.roi.functions.savesubset(atd,input_itemname, parameters.indexes_to_include, output_itemname, h);

out = 1;
