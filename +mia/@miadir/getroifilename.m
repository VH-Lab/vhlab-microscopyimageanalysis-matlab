function roifilename = getroifilename(atd, itemname)
% GETROIFILENAME - get the image file from an ATDIR
%
%  ROIFILENAME = GETROIFILENAME(ATD, ITEMNAME)
%
%  Returns the filename associated with the ROI item name
%  ITEMNAME.
%

roifilename = '';

dnames = {};
d = dir([getpathname(atd) filesep 'ROIs' filesep itemname filesep '*ROI.mat']);
dnames = cat(1,dnames,d.name);

if ~isempty(dnames),
	roifilename = [getpathname(atd) filesep 'ROIs' filesep itemname filesep dnames{1}];
end;

if isempty(roifilename),
	errordlg(['Could not locate the ROI file in ' [getpathname(atd) filesep 'ROIs' filesep itemname filesep] '; this directory should be deleted.']);
end
