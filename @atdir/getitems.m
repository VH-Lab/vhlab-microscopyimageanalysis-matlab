function itemstruct = getitems(atd, itemtype)
% GETITEMS - Get items of a particular type in an ATDIR experiment directory
%  
%   ITEMSTRUCT = GETITEMS(ATD, ITEMTYPE)
%
%  Returns an item struct array with all items of ITEMTYPE
%  in the ATDIR director ATD.
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

d = dir([atd.pathname filesep itemtype]);
dirnumbers = find([d.isdir]);
dirlist = {d(dirnumbers).name};
dirlist = dirlist_trimdots(dirlist);

for i=1:length(dirlist),
	n.name = dirlist{i};
	n.parent = '';
	pfname = [atd.pathname filesep itemtype filesep n.name filesep 'parent.txt'];
	if exist(pfname),
		n.parent = strtrim(textfile2char(pfname));
	end;
	n.history = gethistory(atd,itemtype,n.name);
	itemstruct(end+1) = n;
end;


