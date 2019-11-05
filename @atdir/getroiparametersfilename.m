function roipfilename = getroiparametersfilename(atd, itemname)
% GETROIPARAMETERSFILENAME - get the image file from an ATDIR
%
%  ROIPFILENAME = GETROIFILENAME(ATD, ITEMNAME)
%
%  Returns the filename associated with the ROI parameters for item name
%  ITEMNAME.
%

roipfilename = '';

dnames = {};
d = dir([getpathname(atd) filesep 'ROIs' filesep itemname filesep '*ROI_roiparameters.mat']);
dnames = cat(1,dnames,d.name);

if ~isempty(dnames),
	roipfilename = [getpathname(atd) filesep 'ROIs' filesep itemname filesep dnames{1}];
end;

if isempty(roipfilename),
	errordlg(['Could not locate the ROI file in ' [getpathname(atd) filesep 'ROIs' filesep itemname filesep] '; this directory should be deleted.']);
end
