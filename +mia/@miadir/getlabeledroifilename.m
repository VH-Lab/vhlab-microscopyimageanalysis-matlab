function labeledroifilename = getlabeledroifilename(md, itemname)
% GETLABELEDROIFILENAME - get the image file from an MIADIR
%
%  ROIFILENAME = GETLABELEDROIFILENAME(MD, ITEMNAME)
%
%  Returns the labeled ROI filename associated with the ROI item name
%  ITEMNAME.
%

labeledroifilename = '';

dnames = {};
d = dir([mia.miadir.getpathname(md) 'ROIs' filesep itemname filesep '*L.mat']);
dnames = cat(1,dnames,d.name);

if ~isempty(dnames),
	labeledroifilename = [mia.miadir.getpathname(md) filesep 'ROIs' filesep itemname filesep dnames{1}];
end;
