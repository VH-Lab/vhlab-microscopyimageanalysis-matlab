function cfilename = getcolocalizationfilename(md, itemname)
% GETCOLOCALIZATIONFILENAME - get the image file from an MIADIR
%
%  CFILENAME = GETCOLOCALIZATIONFILENAME(MD, ITEMNAME)
%
%  Returns the colocalization filename associated with the item name
%  ITEMNAME.
%
%  Returns empty string ('') if none.
%

cfilename = '';

extensions = {'.mat'};

dnames = {};
for i=1:length(extensions),
	d = dir([mia.miadir.getpathname(md) filesep 'CLAs' filesep itemname filesep '*_CLA' extensions{i}]);
	dnames = cat(1,dnames,d.name);
	if ~isempty(dnames), break; end; % if we have a match it is good
end;

if ~isempty(dnames),
	dnames = sort(dnames);
	cfilename = [mia.miadir.getpathname(md) filesep 'CLAs' filesep itemname filesep dnames{1}];
end;
