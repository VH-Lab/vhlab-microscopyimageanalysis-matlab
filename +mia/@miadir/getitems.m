function itemstruct = getitems(md, itemtype)
% GETITEMS - Get items of a particular type in an MIADIR experiment directory
%  
%   ITEMSTRUCT = GETITEMS(MD, ITEMTYPE)
%
%  Returns an item struct array with all items of ITEMTYPE
%  in the MIADIR director MD.
%
%  Examples of ITEMTYPE could be 'images', 'ROIs', etc...
%
%  The item struct is the following:
%  Fieldname:   |   Description
%  -------------------------------------------------------
%  name         |   The item name
%  parent       |   The item's parent's name, if any
%  history      |   A structure with the item's history

itemstruct = emptystruct('name','parent','history');

d = dir([md.pathname filesep itemtype]);
dirnumbers = find([d.isdir]);
dirlist = {d(dirnumbers).name};
dirlist = dirlist_trimdots(dirlist);

for i=1:length(dirlist),
	n.name = dirlist{i};
	n.parent = getparent(md,itemtype,n.name);
	n.history = gethistory(md,itemtype,n.name);
	itemstruct(i) = n;
end;


