function labeledroifilename = getlabeledroifilename(atd, itemname)
% GETLABELEDROIFILENAME - get the image file from an ATDIR
%
%  ROIFILENAME = GETLABELEDROIFILENAME(ATD, ITEMNAME)
%
%  Returns the labeled ROI filename associated with the ROI item name
%  ITEMNAME.
%

labeledroifilename = '';

dnames = {};
d = dir([getpathname(atd) filesep 'ROIs' filesep itemname filesep '*L.mat']);
dnames = cat(1,dnames,d.name);

if ~isempty(dnames),
	labeledroifilename = [getpathname(atd) filesep 'ROIs' filesep itemname filesep dnames{1}];
end;
