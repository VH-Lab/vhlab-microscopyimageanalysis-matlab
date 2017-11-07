function out = at_itemeditlist_gui(name,varargin)
% AT_ITEMLIST_GUI - Manage the view of a multi-frame image in a Matlab GUI
%
%   AT_ITEMLIST_GUI
%
%   Creates and manages a panel appropriate for examining a list of items
%   in a Matlab GUI. 
%
%   To create a item edit list panel, call AT_ITEMLIST_GUI(NAME,'command','init') where 
%   NAME is a unique name on your figure (you can have more than one viewer per figure
%   if you use different names).  You can pass additional name/value pairs that govern the
%   behavior of the GUI.
%
%   Commands and parameters are not case sensitive. Name IS case sensitive.
%
%   Parameter (default value)    | Description
%   --------------------------------------------------------------------------- 
%   fig (gcf)                    | Figure number where the viewer is located
%   Units ('pixels')             | The units we will use
%   LowerLeftPoint ([0 0])       | The lower left point to use in drawing, in units of "units"
%   UpperRightPoint ([400 300])  | The upper right point to use in drawing, in units of "units"
%   itemtype ('images')          | The name of type of items to be managed (known to atdir)
%   itemtype_singular ('image')  | The English name of type of items to be managed (singular)
%   itemtype_plural ('images')   | The plural of the type
%   itemstruct ([])              | If calling command='update_itemlist', an itemstruct should be
%                                |    passed.
%   viewselectiononly (0)        | 0/1 Should we view the current selection only, ignoring the
%                                |    settings in 'visible'?
%   usevisible (1)               | 0/1 Should we give the user the option to set the visibility
%                                |    and color of each item?
%   visiblecbstring ('Visible')  | String. The name we should use for the 'Visible' checkbox.
%   useedit (1)                  | 0/1 Should we keep the edit menu available?
%   drawaction([])               | Name of a function for the draw action. It provides a structure
%                                |   as a name/value pair with name 'theinput', and value a structure with fields:
%                                |     itemname  - a string with the name of the item
%                                |     itemstruct_parameters - the viewing parameters (visible,etc)
%  drawaction_userinputs ({})    | A list of user-provided inputs to the drawaction function.
%                                |   The function is called as DRAWACTION(DRAWACTION_USERINPUTS{:},'theinput',thestructabove)
%  new_functions ({})            | Functions that can be called from the "New [item]" pull down menu
%  new_items ('')                | The AT_ITEMLIST_GUI name to use for the item list for new functions. If empty,
%                                |   then the current AT_ITEMLIST_GUI is used.
%  edit_functions ({})           | Functions that can be called from the "Edit [item]" pull down menu
%  edit_items ('')               | The AT_ITEMLIST_GUI name to be used for the item list for edit functions. If empty,
%                                |   then the current AT_ITEMLIST_GUI is used.
%  atd ([])                      | ATDIR that manages the data directory
%  extracbstring (' ')           | String for the optional extra checkbox ui control
%  useextracb (0)                | 0/1 Should we use the extra checkbox ui control?
%  extracbcallsdrawaction (1)    | 0/1 Should the extra checkbox ui control call drawaction?
%   
%   
%   One can also query the internal variables by calling
%
%   AT_ITEMLIST_GUI(NAME, 'command', 'Get_Vars')
%  
%   Or obtain the uicontrol and axes handles by using:
%
%   AT_ITEMLIST_GUI(NAME, 'command', 'Get_Handles')
%   

sizeparams.DefaultHeight = 300;
sizeparams.DefaultWidth = 450;
sizeparams.DefaultRowHeight = 30;
sizeparams.DefaultRowSpace = 35;
sizeparams.DefaultEdgeSpace = 10;

Units = 'pixels';
LowerLeftPoint = [0 0];
UpperRightPoint = [ sizeparams.DefaultWidth sizeparams.DefaultHeight ];
ud = [];
itemtype = 'images';
itemtype_singular = 'image';
itemtype_plural = 'Images';
itemstruct = [];
itemstruct_parameters = emptystruct('itemname','info','visible','extracb','color');
viewselectiononly = 0;
usevisible = 1;
visiblecbstring = 'Visible';
useedit = 1;
drawaction= '';
drawaction_userinputs = {};
new_functions = {};
new_items = '';
edit_functions = {};
edit_items = '';
atd = [];
extracbstring = ' ';
useextracb = 0;
extracbcallsdrawaction = 1;

command = [name 'init']; 
fig = gcf;

varlist = {'sizeparams','LowerLeftPoint','UpperRightPoint','itemtype','itemtype_singular','itemtype_plural','itemstruct',...
		'viewselectiononly','itemstruct_parameters','usevisible','visiblecbstring','useedit',...
		'drawaction','drawaction_userinputs','new_functions','edit_functions','atd','new_items','edit_items','extracbstring','useextracb','extracbcallsdrawaction'};

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
	error(['Command must include AT_ITEMLIST_GUI name (see help at_itemeditlist_gui)']);
end;

% initialize our internal variables or pull it
if strcmp(lower(command),'init'), 
	for i=1:length(varlist),
		eval(['ud.' varlist{i} '=' varlist{i} ';']);
	end;
elseif strcmp(lower(command),'set_vars'), % if it is set_vars, leave ud alone, user had to set it
elseif ~strcmp(lower(command),'get_vars') & ~strcmp(lower(command),'get_handles'), % let the routine below handle it
	ud = at_itemeditlist_gui(name,'command',[name 'Get_Vars'],'fig',fig);
end;

switch lower(command),
	case 'init',
		uidefs = basicuitools_defs('callbackstr', ['callbacknametag(''at_itemeditlist_gui'',''' name ''');']);

		w = ud.sizeparams.DefaultWidth;
		h = ud.sizeparams.DefaultHeight;
		r = ud.sizeparams.DefaultRowHeight;
		rs = ud.sizeparams.DefaultRowSpace;
		ws = ud.sizeparams.DefaultEdgeSpace;

		listwidth = 150;
		listheight = 225;
		uiitemsize = 100;
		popupwidth = 125;
		rgbtextlabelwidth = 50;

		target_rect = rect2rect([ud.LowerLeftPoint ud.UpperRightPoint],'lbrt2lbwh');

		uicontrol(uidefs.frame,'units','pixels','position',...
			rescale_subrect([0 0 w h],[0 0 w h],target_rect,3),'tag',[name 'OuterFrame']);

		frameBG = get(findobj(gcf,'tag',[name 'OuterFrame']),'BackgroundColor');

		uicontrol(uidefs.txt,'fontweight','bold','string',[upper(ud.itemtype_plural(1)) ud.itemtype_plural(2:end)],...
			'units','pixels','position',...
			rescale_subrect([ws h-r-ws listwidth r],[0 0 w h],target_rect,3),...
			'tag',[name 'ItemTitleTxt'],'backgroundcolor',frameBG,'horizontalalignment','center');

		uicontrol(uidefs.list,'string',{}, ...
			'units','pixels','position',...
			rescale_subrect([ws h-ws-r-listheight listwidth listheight],[0 0 w h],target_rect,3),...
			'tag',[name 'ItemList']);

		uicontrol(uidefs.txt,'string',['New ' ud.itemtype_singular ':'],...
			'units','pixels','position',...
			rescale_subrect([2*ws+listwidth h-ws-2*rs uiitemsize  r],[0 0 w h],target_rect,3),...
			'tag',[name 'NewItemTitleTxt'],'BackgroundColor',frameBG);

		uicontrol(uidefs.popup,'string',cat(1,{['New ' ud.itemtype_singular]}, {'-'}, new_functions{:}),...
			'units','pixels','position',...
			rescale_subrect([3*ws+listwidth+uiitemsize h-ws-2*rs popupwidth r],[0 0 w h],target_rect,3),...
			'tag',[name 'NewItemPopup']);

		vis = 'on';
		if ~ud.useedit,
			vis = 'off';
		end;

		uicontrol(uidefs.txt,'string',['Edit ' ud.itemtype_singular ':'],...
			'units','pixels','position',...
			rescale_subrect([2*ws+listwidth h-ws-3*rs uiitemsize  r],[0 0 w h],target_rect,3),...
			'tag',[name 'EditItemTitleTxt'],'BackgroundColor',frameBG,'visible',vis);

		uicontrol(uidefs.popup,'string',cat(1,{['Edit ' ud.itemtype_singular]}, {'-'}, edit_functions{:}),...
			'units','pixels','position',...
			rescale_subrect([3*ws+listwidth+uiitemsize h-ws-3*rs popupwidth r],[0 0 w h],target_rect,3),...
			'tag',[name 'EditItemPopup'],'visible',vis);

		vis = 'on';
		if ~ud.usevisible,
			vis = 'off';
		end;

		uicontrol(uidefs.cb,'string',visiblecbstring,...
			'units','pixels','position',...
			rescale_subrect([2*ws+listwidth h-ws-4*rs uiitemsize  r],[0 0 w h],target_rect,3),...
			'tag',[name 'VisibleCB'],'BackgroundColor',frameBG,'visible',vis);

		uicontrol(uidefs.txt,'string','[R G B]',...
			'units','pixels','position',...
			rescale_subrect([3*ws+listwidth+uiitemsize h-ws-4*rs rgbtextlabelwidth r],[0 0 w h],target_rect,3),...
			'tag',[name 'ColorTxt'],'enable','inactive','backgroundColor',frameBG,'visible',vis);

		uicontrol(uidefs.edit,'string','[R G B]',...
			'units','pixels','position',...
			rescale_subrect([3*ws+listwidth+uiitemsize+rgbtextlabelwidth h-ws-4*rs uiitemsize r],[0 0 w h],target_rect,3),...
			'tag',[name 'ColorEdit'],'visible',vis,'callback',uidefs.button.Callback);

		vis = 'on';
		if ~ud.useextracb,
			vis = 'off';
		end;

		uicontrol(uidefs.cb,'string',extracbstring,...
			'units','pixels','position',...
			rescale_subrect([2*ws+listwidth h-ws-5*rs uiitemsize  r],[0 0 w h],target_rect,3),...
			'tag',[name 'ExtraCB'],'BackgroundColor',frameBG,'visible',vis);

		uicontrol(uidefs.button,'string',['Delete'],...
			'units','pixels','position',...
			rescale_subrect([w-ws/2-uiitemsize h-ws-5*rs uiitemsize  r-2],[0 0 w h],target_rect,3),...
			'tag',[name 'DeleteBt'],'BackgroundColor',frameBG);

%			rescale_subrect([w-ws-uiitemsize 4*ws+listwidth+uiitemsize h-ws-5*rs uiitemsize  r-2],[0 0 w h],target_rect,3),...
		uicontrol(uidefs.txt,'string',['Info:'],...
			'units','pixels','position',...
			rescale_subrect([2*ws+listwidth h-ws-6*rs+5 uiitemsize  r],[0 0 w h],target_rect,3),...
			'tag',[name 'InfoLabelTxt'],'BackgroundColor',frameBG);

		uicontrol(uidefs.list,'string',['[Info here]'],...
			'units','pixels','position',...
			rescale_subrect([2*ws+listwidth h-ws-r-listheight uiitemsize+ws+popupwidth -5.5*rs+r+listheight],[0 0 w h],target_rect,3),...
			'tag',[name 'InfoList'],'BackgroundColor',[1 1 1],'Max',2,'value',[]);

		at_itemeditlist_gui(name,'command',[name 'Set_Vars'],'ud',ud);
	
	case 'get_vars',
		handles = at_itemeditlist_gui(name,'command',[name 'get_handles'],'fig',fig);
		out = get(handles.ItemList,'userdata');
	case 'set_vars',  % needs 'ud' to be passed by caller
		handles = at_itemeditlist_gui(name,'command',[name 'get_handles'],'fig',fig);
		set(handles.ItemList,'userdata',ud);
	case 'get_handles',
		handle_base_names = {'OuterFrame','ItemTitleTxt','ItemList','NewItemTitleTxt','NewItemPopup','InfoList','DeleteBt','ColorEdit','ColorTxt','VisibleCB','ExtraCB',...
			'EditItemPopup','EditItemTitleTxt'};
		out = [];
		for i=1:length(handle_base_names),
			out=setfield(out,handle_base_names{i},findobj(fig,'tag',[name handle_base_names{i}]));
		end;

	case 'update_itemlist', % requires atd
		itemstruct = getitems(atd,ud.itemtype);
		[liststr,info] = at_itemstruct2list(itemstruct);
		ud.atd = atd;
		handles = at_itemeditlist_gui(name,'command',[name 'get_handles'],'fig',fig);
		set(handles.ItemList,'string',liststr,'value',1);

		% really need something to merge changes with the previous version
		currentnames = {ud.itemstruct_parameters.itemname};
		for i=1:length(liststr),
			[ia,locb] = ismember(currentnames,trimws(liststr{i}));
			inds = find(ia);
			if isempty(inds), % no entry
				ud.itemstruct_parameters(end+1) = struct('itemname',trimws(liststr{i}),...
					'info','','visible',0,'extracb',0,'color',colorlist(i));
				ud.itemstruct_parameters(end).info = info{i};
			else,
				ud.itemstruct_parameters(inds).info = info{i};
			end;
		end;
		ud.itemstruct = itemstruct;
		at_itemeditlist_gui(name,'command',[name 'Set_Vars'],'ud',ud);
		at_itemeditlist_gui(name,'command',[name 'itemlist'],'ud',ud);

	case 'itemlist',
		handles = at_itemeditlist_gui(name,'command',[name 'get_handles'],'fig',fig);
		liststr = get(handles.ItemList,'string');
		listval = get(handles.ItemList,'value');

		if isempty(listval) | isempty(liststr), return; end;
		
		currentnames = {ud.itemstruct_parameters.itemname};
		[ia,locb] = ismember(currentnames,trimws(liststr{listval(1)}));
		inds = find(ia);
		if isempty(inds),
			error(['Cannot find entry for item name ' trimws(liststr{listval(1)}) '.']);
			% should not happen
		elseif length(inds)>1,
			error(['Found more than one match. Should not happen. item list was ' trimws(liststr{listval(1)}) '.']);
		else,
			set(handles.VisibleCB,'value',ud.itemstruct_parameters(inds).visible);
			set(handles.ExtraCB,'value',ud.itemstruct_parameters(inds).extracb);
			set(handles.ColorEdit,'string',mat2str(ud.itemstruct_parameters(inds).color));
			set(handles.InfoList','string',ud.itemstruct_parameters(inds).info);
		end;

		if ud.viewselectiononly,
			if ~isempty(ud.drawaction),
				% invoke draw action
				myinput.itemname = trimws(liststr{listval(1)});
				myinput.itemstruct_parameters = ud.itemstruct_parameters;
				feval(ud.drawaction,ud.drawaction_userinputs{:},'theinput',myinput);
			end;
		end;

	case 'drawaction',
		if ~isempty(ud.drawaction),
			if ~ud.viewselectiononly,
				myinput.itemstruct_parameters = ud.itemstruct_parameters;
				feval(ud.drawaction,ud.drawaction_userinputs{:},'theinput',myinput);
			end;
		end;

	case 'newitempopup',  % use alternate list location
		handles = at_itemeditlist_gui(name,'command',[name 'get_handles'],'fig',fig);
		menustr = get(handles.NewItemPopup,'string');
		menuval = get(handles.NewItemPopup,'value');
		if isempty(ud.new_items),
			liststr = get(handles.ItemList,'string');
			listval = get(handles.ItemList,'value');
		else,
			otherhandles = at_itemeditlist_gui(ud.new_items,'command',[ud.new_items 'get_handles'],'fig',fig);
			liststr = get(otherhandles.ItemList,'string');
			listval = get(otherhandles.ItemList,'value');
		end;
		set(handles.NewItemPopup,'value',1); % reset menu
		if (menuval > 2 & ~strcmp(unique(menustr{menuval}),'-')) & ~isempty(listval) & ~isempty(liststr),
			for j=1:length(liststr), liststr{j} = trimws(liststr{j}); end;
			good = 0;
			while ~good,
				prompt = {'Enter new unique name for new item (please begin with a letter, no spaces):'};
				windowname = 'Name your new item:';
				defaultanswer = {liststr{listval}};
				answer=inputdlg(prompt,windowname,1,defaultanswer);
				if isempty(answer), return; end;
				good = ~any(ismember(liststr,answer{1}));
				if ~good, errordlg(['Item name ' answer{1} ' already exists. Please choose another.']); end;
			end;
			feval(menustr{menuval},ud.atd,liststr{listval},answer{1},'choose');
			at_itemeditlist_gui(name,'command',[name 'update_itemlist'],'fig',fig,'atd',ud.atd);
		end;

	case 'edititempopup',
		handles = at_itemeditlist_gui(name,'command',[name 'get_handles'],'fig',fig);
		menustr = get(handles.EditItemPopup,'string');
		menuval = get(handles.EditItemPopup,'value');
		if isempty(ud.edit_items),
			liststr = get(handles.ItemList,'string');
			listval = get(handles.ItemList,'value');
		else,
			otherhandles = at_itemeditlist_gui(ud.edit_items,'command',[ud.edit_items 'get_handles'],'fig',fig);
			liststr = get(otherhandles.ItemList,'string');
			listval = get(otherhandles.ItemList,'value');
		end;
		set(handles.EditItemPopup,'value',1); % reset menu
		if (menuval > 2 & ~strcmp(unique(menustr{menuval}),'-')) & ~isempty(listval) & ~isempty(liststr),
			for j=1:length(liststr), liststr{j} = trimws(liststr{j}); end;
			good = 0;
			while ~good,
				prompt = {'Enter new unique name for new item (please begin with a letter, no spaces):'};
				windowname = 'Name your new item:';
				defaultanswer = {liststr{listval}};
				answer=inputdlg(prompt,windowname,1,defaultanswer);
				if isempty(answer), return; end;
				good = ~any(ismember(liststr,answer{1}));
				if ~good, errordlg(['Item name ' answer{1} ' already exists. Please choose another.']); end;
			end;
			feval(menustr{menuval},ud.atd,liststr{listval},answer{1},'choose');
			at_itemeditlist_gui(name,'command',[name 'update_itemlist'],'fig',fig,'atd',ud.atd);
		end;

	case 'deletebt',
		handles = at_itemeditlist_gui(name,'command',[name 'get_handles'],'fig',fig);
		liststr = get(handles.ItemList,'string');
		listval = get(handles.ItemList,'value');

		if isempty(listval) | isempty(liststr), return; end;
		itemname = trimws(liststr{listval});

		buttonname = questdlg(['Are you sure you want to delete the item ' itemname '?'],'Are you sure?','Yes','No','No');
		if strcmp(lower(buttonname),'yes'),
			deleteitem(ud.atd,ud.itemtype,itemname);
			at_itemeditlist_gui(name,'command',[name 'update_itemlist'],'fig',fig,'atd',ud.atd);
		end;

	case 'visiblecb',
		handles = at_itemeditlist_gui(name,'command',[name 'get_handles'],'fig',fig);
		liststr = get(handles.ItemList,'string');
		listval = get(handles.ItemList,'value');
		if isempty(listval) | isempty(liststr), return; end;
		itemname = trimws(liststr{listval});
		if isempty(itemname), return; end;
		l = find(ismember({ud.itemstruct_parameters.itemname},itemname));
		if ~isempty(l),
			ud.itemstruct_parameters(l).visible = get(handles.VisibleCB,'value');
			at_itemeditlist_gui(name,'command',[name 'Set_Vars'],'ud',ud);
			at_itemeditlist_gui(name,'command',[name 'drawaction'],'ud',ud);
		end;

	case 'extracb',
		handles = at_itemeditlist_gui(name,'command',[name 'get_handles'],'fig',fig);
		liststr = get(handles.ItemList,'string');
		listval = get(handles.ItemList,'value');
		if isempty(listval) | isempty(liststr), return; end;
		itemname = trimws(liststr{listval});
		if isempty(itemname), return; end;
		l = find(ismember({ud.itemstruct_parameters.itemname},itemname));
		if ~isempty(l),
			ud.itemstruct_parameters(l).extracb= get(handles.ExtraCB,'value');
			at_itemeditlist_gui(name,'command',[name 'Set_Vars'],'ud',ud);
			vars = at_itemeditlist_gui(name,'command',[name 'get_vars'],'fig',fig);
			if vars.extracbcallsdrawaction,
				at_itemeditlist_gui(name,'command',[name 'drawaction'],'ud',ud);
			end;
		end;

	case 'coloredit',
		handles = at_itemeditlist_gui(name,'command',[name 'get_handles'],'fig',fig);
		liststr = get(handles.ItemList,'string');
		listval = get(handles.ItemList,'value');
		if isempty(listval) | isempty(liststr), return; end;
		itemname = trimws(liststr{listval});
		if isempty(itemname), return; end;
		l = find(ismember({ud.itemstruct_parameters.itemname},itemname));
		if ~isempty(l),
			colorstr = get(handles.ColorEdit,'string');
			valid = 1;
			try,
				rgb = eval([colorstr]);
			catch,
				valid = 0;
			end;
			if ((size(rgb,1)~=1) | (size(rgb,2)~=3) | ~isnumeric(rgb) | ~(max(rgb)<=1) | ~(min(rgb)<=0)),
				valid = 0;
			end;

			if ~valid,
				errordlg(['RGB values must be between 0 and 1, and must be a [1x3] matrix.']);
			else,
				ud.itemstruct_parameters(l).color = rgb;
				at_itemeditlist_gui(name,'command',[name 'Set_Vars'],'ud',ud);
				at_itemeditlist_gui(name,'command',[name 'drawaction'],'ud',ud);
			end;
		end;

	case 'infolist',
			set(gcbo,'value',[]);
			% no action

	otherwise,
		disp(['Unknown command ' command ]);

end;

