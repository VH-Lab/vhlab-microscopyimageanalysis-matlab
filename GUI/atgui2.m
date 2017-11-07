function out = atgui2(name, varargin)
% ATGUI2 - 2nd generation GUI for Array Tomography analysis
%
%   ATGUI2 
%
%   Launches a graphical user interface for Array Tomography
%   analysis. 
%


if nargin==0,
	name = char(65+ceil(rand(1,16)*25)); % make a random name, don't burden user
end;

command = [name 'init'];

ud = [];
pathname = '';

varlist = {'pathname'};

assign(varargin{:});

if strcmp(lower(command),'init'),
	command = [name 'init'];
end;

command_extract_success = 0;
if length(command)>length(name),
	if strcmp(name,command(1:length(name))),
		command = lower(command(length(name)+1:end));
		command_extract_success = 1;
	end;
end;

if ~command_extract_success,
	error(['Command must include ATGUI2 name']);
end;

% initialize our internal variables or pull it
if strcmp(lower(command),'init'),
        for i=1:length(varlist),
                eval(['ud.' varlist{i} '=' varlist{i} ';']);
        end;
elseif strcmp(lower(command),'set_vars'), % if it is set_vars, leave ud alone, user had to set it
elseif ~strcmp(lower(command),'get_vars') & ~strcmp(lower(command),'get_handles'), % let the routine below handle it
        ud = atgui2(name,'command',[name 'Get_Vars']);
end;

if ~strcmp(lower(command),'init')
	fig = gcf;
end;

switch lower(command),
	case 'init',
		fig = figure;

		p = get(fig,'position');
		set(fig,'position',[p(1) p(2) 915 685]);

		uidefs = basicuitools_defs('callbackstr',['callbacknametag(''atgui2'',''' name ''');']);

		uicontrol(uidefs.txt,'units','pixels','position',[5 620+35 450 25],'fontweight','bold',...
				'fontsize',16,'string','Array Tomography Analysis GUI','tag',[name 'ATGUI_Title']);
		uicontrol(uidefs.txt,'units','pixels','position',[5 620+5 50 20],...
				'string','Path:','tag',[name 'ATGUI_PathTxt']);
		uicontrol(uidefs.edit,'units','pixels','position',[5+50+5 620+5 275 20],...
				'string',ud.pathname,'tag',[name 'ATGUI_PathEdit']);
		uicontrol(uidefs.button,'units','pixels','position',[5+50+5+275+5 620+5 50 20],...
				'string','Change','tag',[name 'ATGUI_PathChangeButton']);
		uicontrol(uidefs.button,'units','pixels','position',[5+50+5+275+5+50+5 620+5 50 20],...
				'string','Update','tag',[name 'ATGUI_PathUpdateButton']);

		at_itemeditlist_gui('ROIg','itemtype','ROIs','itemtype_singular','ROI','itemtype_plural','ROIs',...
				'UpperRightPoint',[450 300],'LowerLeftPoint',[5 5],'new_functions',at_roi_makers_list,'new_items','IMl',...
				'edit_functions',at_roi_editors_list,'edit_items','ROIg','visiblecbstring','Draw lines',...
				'drawaction','atgui2','drawaction_userinputs',{name,'command',[name 'ATGUI_DrawROIs']},...
				'extracbstring','Overlay','useextracb',1);
		at_itemeditlist_gui('IMl','UpperRightPoint',[450 605],'LowerLeftPoint',[5 305],'useedit',0,'usevisible',0,'viewselectiononly',1,...
				'drawaction','atgui2','drawaction_userinputs',{name,'command',[name 'ATGUI_DrawImage']},...
				'new_functions',at_image_process_list);
		at_itemeditlist_gui('COLg','UpperRightPoint',[450+455 300],'LowerLeftPoint',[455 5],...
				'itemtype','CLAs','itemtype_singular','CLA','itemtype_plural','Colocalization Analyses','visiblecbstring','Draw lines',...
				'drawaction','atgui2','drawaction_userinputs',{name,'command',[name 'ATGUI_DrawColocalizations']},...
				'new_functions',at_colocalization_makers_list,'new_items','ROIg',...
				'extracbstring','Overlay','useextracb',1);

		image_viewer_gui('IMv','LowerLeftPoint',[455 305],'UpperRightPoint',[455+450 685-5],'showhistogram',0,...
				'drawcompletionfunc',['atgui2(''' name ''', ''command'', [''' name ''' ''ATGUI_ImageMoved'']);']);

        case 'get_vars',
                handles = atgui2(name,'command',[name 'get_handles'],'fig',fig);
                out = get(handles.ATGUI_Title,'userdata');
        case 'set_vars',  % needs 'ud' to be passed by caller
                handles = atgui2(name,'command',[name 'get_handles'],'fig',fig);
                set(handles.ATGUI_Title,'userdata',ud);
        case 'get_handles',
                handle_base_names = {'ATGUI_Title','ATGUI_PathTxt','ATGUI_PathEdit','ATGUI_PathChangeButton','ATGUI_PathUpdateButton'};
                out = [];
                for i=1:length(handle_base_names),
                        out=setfield(out,handle_base_names{i},findobj(fig,'tag',[name handle_base_names{i}]));
                end;

	case lower('ATGUI_PathChangeButton'),
		newpath = uigetdir(pwd);
		if ~eqlen(newpath,0),
                	handles = atgui2(name,'command',[name 'get_handles'],'fig',fig);
			set(handles.ATGUI_PathEdit','string',newpath);
                	atgui2(name,'command',[name 'ATGUI_PathUpdateButton'],'fig',fig);
		end;

	case lower('ATGUI_PathUpdateButton'),
                handles = atgui2(name,'command',[name 'get_handles'],'fig',fig);
		newpath = get(handles.ATGUI_PathEdit','string');
		if exist(newpath)==7,
			ud.pathname = newpath;
                	atgui2(name,'command',[name 'set_vars'],'ud',ud);

			% need to update lists here
			atd = atdir(ud.pathname);
			items = {'images','ROIs','CLAs'};
			itemlists = {'IMl','ROIg','COLg'};
			for i=1:length(items),
				itemstruct = getitems(atd,items{i});
				at_itemeditlist_gui(itemlists{i},'command',[itemlists{i} 'update_itemlist'],'atd',atd);
			end;
		else,
			error(['New pathname ' newpath ' does not exist.']);
		end;
	case lower('ATGUI_ImageMoved'),
		at_itemeditlist_gui('ROIg','command',['ROIg' 'drawaction'],'fig',fig);
	case lower('ATGUI_DrawImage'), % NEEDS INPUT ARGUMENT theinput.itemname
                handles = atgui2(name,'command',[name 'get_handles'],'fig',fig);
		atd = atdir(ud.pathname);
		imfile = getimagefilename(atd,theinput.itemname);
		image_viewer_gui('IMv','command',['IMv' 'Set_Image'],'imfile',imfile);
		atgui2(name,'command',[name 'ATGUI_ImageMoved'],'fig',fig);
	case lower('ATGUI_DrawROIs'), % NEEDS INPUT ARGUMENT theinput.itemstruct_parameters
		disp(['Got request to draw ROIs.']);

		atgui2(name,'command',[name 'ATGUI_DrawROIOverlay'],'fig',fig,'theinput',theinput);
		atgui2(name,'command',[name 'ATGUI_DrawROILines'],'fig',fig,'theinput',theinput);

	case lower('ATGUI_DrawROILines'),% NEEDS INPUT ARGUMENT theinput.itemstruct_parameters
		disp(['Got request to draw ROIs as lines and numbers.']);
                handles = atgui2(name,'command',[name 'get_handles'],'fig',fig);
		atd = atdir(ud.pathname);

		itemstruct_parameters = theinput.itemstruct_parameters;

		% step 1 - get a list of all the types

		imhandles = image_viewer_gui('IMv','command',['IMv' 'get_handles'],'fig',fig);
		currentAxes = gca;
		axes(imhandles.ImageAxes);

		plothandles_line = findobj(gca,'-regexp','tag','**_line');
		plothandles_linetags = unique(get(plothandles_line,'tag'));


		zdim = image_viewer_gui('IMv','command',['IMv' 'getslice'],'fig',fig);
		for i=1:length(itemstruct_parameters),
			if itemstruct_parameters(i).visible,
				z=find(ismember(plothandles_linetags,[itemstruct_parameters(i).itemname '_' int2str(zdim) '_line']));
				if ~isempty(z), % already there, leave it alone
					plothandles_linetags = plothandles_linetags([1:z-1 z+1:end]);
				else, % need to draw
					roifile = getroifilename(atd,itemstruct_parameters(i).itemname);
					ROI = load([roifile],'-mat');
					ROI_3dplot2d(ROI.CC,12,itemstruct_parameters(i).color,[itemstruct_parameters(i).itemname '_' int2str(zdim) '_line'],...
						[itemstruct_parameters(i).itemname '_' int2str(zdim) '_text'],zdim);
				end;
			else,
				z=find(ismember(plothandles_linetags,[itemstruct_parameters(i).itemname '_' int2str(zdim) '_line']));
				if ~isempty(z),
					delete(findobj(gca,'tag',[itemstruct_parameters(i).itemname '_' int2str(zdim) '_line']));
					delete(findobj(gca,'tag',[itemstruct_parameters(i).itemname '_' int2str(zdim) '_text']));
					plothandles_linetags = plothandles_linetags([1:z-1 z+1:end]);
				end;
			end;
		end;

		for i=1:length(plothandles_linetags), % if there are any left, delete
			delete(findobj(gca,'tag',plothandles_linetags{i}));
			delete(findobj(gca,'tag',[plothandles_linetags{i}([1:end-4]) 'text' ]));
		end;
		
		axes(currentAxes);

	case lower('ATGUI_DrawROIOverlay'),
		disp(['Got request to draw ROIs as overlay.']);

                handles = atgui2(name,'command',[name 'get_handles'],'fig',fig);
		atd = atdir(ud.pathname);

		itemstruct_parameters = theinput.itemstruct_parameters;

		imhandles = image_viewer_gui('IMv','command',['IMv' 'get_handles'],'fig',fig);
		currentAxes = gca;
		axes(imhandles.ImageAxes);

		for i=1:length(itemstruct_parameters),
			if itemstruct_parameters(i).extracb,
				%disp(['doing nothing but I should do something']);
			else,
				%disp(['doing nothing and I should not do anything']);
			end;
		end;

		axes(currentAxes);

	case lower('ATGUI_DrawColocalizations'), % NEEDS INPUT ARGUMENT theinput.itemstruct_parameters
                handles = atgui2(name,'command',[name 'get_handles'],'fig',fig);
		atd = atdir(ud.pathname);
		disp(['Got request to draw CLA.']);

		itemstruct_parameters = theinput.itemstruct_parameters,

		% step 1 - get a lost of all the types

		imhandles = image_viewer_gui('IMv','command',['IMv' 'get_handles'],'fig',fig);
		currentAxes = gca;
		axes(imhandles.ImageAxes);

		plothandles_claline = findobj(gca,'-regexp','tag','**_claline');
		plothandles_clalinetags = unique(get(plothandles_claline,'tag'));

		zdim = image_viewer_gui('IMv','command',['IMv' 'getslice'],'fig',fig);
		for i=1:length(itemstruct_parameters),
			if itemstruct_parameters(i).visible,
				z=find(ismember(plothandles_clalinetags,[itemstruct_parameters(i).itemname '_' int2str(zdim) '_claline']));
				if ~isempty(z), % already there, leave it alone
					plothandles_clalinetags = plothandles_clalinetags([1:z-1 z+1:end]);
				else, % need to draw
					cfile = getcolocalizationfilename(atd,itemstruct_parameters(i).itemname);
					load(cfile);
					rois_to_draw = find(colocalization_data.overlap_thresh);
					roifile = getroifilename(atd,getparent(atd,'CLAs',itemstruct_parameters(i).itemname));
					ROI = load([roifile],'-mat');
					ROI.CC.PixelIdxList = ROI.CC.PixelIdxList(rois_to_draw);
					ROI.CC.NumObjects = length(rois_to_draw);
					ROI_3dplot2d(ROI.CC,12,itemstruct_parameters(i).color,[itemstruct_parameters(i).itemname '_' int2str(zdim) '_claline'],...
						[itemstruct_parameters(i).itemname '_' int2str(zdim) '_clatext'],zdim);
				end;
			else,
				z=find(ismember(plothandles_clalinetags,[itemstruct_parameters(i).itemname '_' int2str(zdim) '_claline']));
				if ~isempty(z),
					delete(findobj(gca,'tag',[itemstruct_parameters(i).itemname '_' int2str(zdim) '_claline']));
					delete(findobj(gca,'tag',[itemstruct_parameters(i).itemname '_' int2str(zdim) '_clatext']));
					plothandles_clalinetags = plothandles_clalinetags([1:z-1 z+1:end]);
				end;
			end;
		end;

		for i=1:length(plothandles_clalinetags), % if there are any left, delete
			delete(findobj(gca,'tag',plothandles_clalinetags{i}));
			delete(findobj(gca,'tag',[plothandles_clalinetags{i}([1:end-4]) 'text' ]));
		end;

		axes(currentAxes);

		image_viewer_gui('IMv','command',['IMv' 'movetoback'],'fig',fig);

	otherwise,
		disp(['Unknown command to ATGUI2: ' command ', name = ' name ]);
end;

