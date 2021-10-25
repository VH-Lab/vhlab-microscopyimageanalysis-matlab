function roifilename = getroifilename(md, itemname)
% GETROIFILENAME - get the image file from an MIADIR
%
%  ROIFILENAME = GETROIFILENAME(MD, ITEMNAME)
%
%  Returns the filename associated with the ROI item name
%  ITEMNAME.
%

roifilename = '';

dnames = {};
d = dir([getpathname(md) filesep 'ROIs' filesep itemname filesep '*ROI.mat']);
dnames = cat(1,dnames,d.name);

if ~isempty(dnames),
	roifilename = [getpathname(md) filesep 'ROIs' filesep itemname filesep dnames{1}];
end;

if isempty(roifilename),
	errordlg(['Could not locate the ROI file in ' [getpathname(md) filesep 'ROIs' filesep itemname filesep] '; this directory should be deleted.']);
end
