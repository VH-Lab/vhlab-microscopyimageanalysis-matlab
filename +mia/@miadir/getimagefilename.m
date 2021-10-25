function imfilename = getimagefilename(md, itemname)
% GETIMAGEFILENAME - get the image file from an ATDIR
%
%  IMFILENAME = GETIMAGEFILENAME(MD, ITEMNAME)
%
%  Returns the image filename associated with the item name
%  ITEMNAME.
%
%  It will examine the directory and return the first image file
%  encountered (searches .tiff, .tif, .gif, .jpg, .jpeg).
%  Returns empty string ('') if none.
% 

imfilename = '';

extensions = {'.tiff','.tif','.gif','.jpg','.jpeg'};

dnames = {};
for i=1:length(extensions),
	d = dir([getpathname(md) filesep 'images' filesep itemname filesep '*' extensions{i}]);
	dnames = cat(1,dnames,d.name);
	if ~isempty(dnames), break; end; % if we have a match it is good
end;

if ~isempty(dnames),
	dnames = sort(dnames);
	imfilename = [getpathname(md) filesep 'images' filesep itemname filesep dnames{1}];
end;
