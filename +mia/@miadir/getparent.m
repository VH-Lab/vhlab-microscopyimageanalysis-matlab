function p = getparent(md, itemtype, itemname)
% GETPARENT - Get the parent of an item from MIADIR directory
%  
%  P = GETPARENT(MD, ITEMTYPE, ITEMNAME)
%
%  Returns the parent name of item ITEMNAME that is
%  of type ITEMTYPE in the directory managed by the MIADIR 
%  object MD.
% 
%  If there is no parent, P is an empty string.
%
%  ITEMNAME and ITEMTYPE must be valid directory names.
%

p = '';

try,
	p = text2cellstr([md.pathname filesep itemtype filesep ...
			itemname filesep 'parent.txt']);
	p = p{1};
end;

