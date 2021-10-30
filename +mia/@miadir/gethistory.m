function h = gethistory(md, itemtype, itemname)
% GETHISTORY - Get the history of an item from MIADIR directory
%  
%  H = GETHISTORY(MD, ITEMTYPE, ITEMNAME)
%
%  Returns the history structure of item ITEMNAME that is
%  of type ITEMTYPE in the directory managed by the MIADIR 
%  object MD.
% 
%  If there is no history, H is an empty structure.
%
%  ITEMNAME and ITEMTYPE must be valid directory names.
%
%  The history structure has the following fields, and is in
%  chronological order of the operations performed on the ITEMTYPE:
%
%  Fieldnames:    | Description: 
%  ---------------------------------------------------------
%  parent         | If the item has a parent, the item name corresponding
%                 |   to the parent is listed here. Otherwise it is an empty
%                 |   string ('').
%  operation      | The text of the function call is described here
%  parameters     | The parameters that were used
%  description    | A human-readable description of the operation

h = emptystruct('parent','operation','parameters','description');

try,
	h = load([md.pathname filesep itemtype filesep ...
			itemname filesep 'history.mat']);
	h = h.history;
catch,
	% warning(['History loading error: ' lasterr]);
end;

