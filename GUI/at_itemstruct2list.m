function [liststr, infostr] = at_itemstruct2list(itemstruct, varargin)
% AT_ITEMSTRUCT2LIST - Convert an itemstruct to a set of strings that can be listed
%
%   [LISTSTR, INFOSTR] = AT_ITEMSTRUCT2LIST(ITEMSTRUCT,...)
%
%   Takes an ITEMSTRUCT (see ATDIR/GETITEMS) and produces a 
%   cell array of strings LISTSTR that indicates the parental relationships among
%   the data. Children are listed below their "parents" and are indented.
%   Note that the order of LISTSTR need not match the list of items in ITEMSTRUCT.
% 
%   INFOSTR is a human readable information string for each item, based on the
%   'history' field. INFOSTR{i} is a cell list of strings for the ITEMSTRUCT.
%   The order of INFOSTR{:} WILL match the list of ITEMSTRUCTs.
%
%   This function can take extra name/value pairs that modify its functionality:
%   Parameter (default):        | Description:
%   -------------------------------------------------------------------
%   indent ('  ')               | The indentation of a child relative to its parent.
%

indent = '  ';

assign(varargin{:});

indentinc = indent;

 % first, find all of the items that have no parents (or no parents that are present here),
 %     put them at the root level

liststr = {};
infostr = {};

if isempty(itemstruct), 
	liststr = {' '};
	infostr = {' '};
	return;
end;

item_names = {itemstruct.name};

G = zeros(length(item_names));

for i=1:length(itemstruct),
	if ~isempty(itemstruct(i).parent),
		[lia,lob] = ismember(itemstruct(i).parent,item_names);
		if any(lob), % it could be empty if the parent isn't here
			G(i,lob) = 1;
		end;
	end;
end;

liststr = {};
for i=1:length(itemstruct),
	inds = find(G(i,:));
	if isempty(inds), % we have a top-level parent, add it
		liststr{end+1} = itemstruct(i).name;
		liststr = cat(2,liststr,addallchildren(item_names,G,i,indent,indentinc));
	end;
end;

infostr = {};
for i=1:length(itemstruct),
	% EDIT HERE
	if ~isempty(itemstruct(i).history),
		infostr{i} = {itemstruct(i).history.description};
	else,
		infostr{i} = {''};
	end;
end;

function str = addallchildren(item_names,G,i,indent,indentinc)
str = {};
 % add children recursively
inds = find(G(:,i));
for j=1:length(inds),
	str{end+1} = [indent item_names{inds(j)}]; % this is a child of i
	str = cat(2,str,addallchildren(item_names,G,inds(j),[indentinc indent],indentinc)); % add the children of this one
end;


