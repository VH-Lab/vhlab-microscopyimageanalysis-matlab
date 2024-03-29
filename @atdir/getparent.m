function p = getparent(atd, itemtype, itemname)
% GETPARENT - Get the parent of an item from ATDIR directory
%  
%  P = GETPARENT(ATD, ITEMTYPE, ITEMNAME)
%
%  Returns the parent name of item ITEMNAME that is
%  of type ITEMTYPE in the directory managed by the ATDIR 
%  object ATD.
% 
%  If there is no parent, P is an empty string.
%
%  ITEMNAME and ITEMTYPE must be valid directory names.
%

p = '';

try,
	p = text2cellstr([atd.pathname filesep itemtype filesep ...
			itemname filesep 'parent.txt']);
	p = p{1};
end;

