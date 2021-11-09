function roipfilename = getroiparametersfilename(md, itemname, showerror)
% GETROIPARAMETERSFILENAME - get the image file from an MIADIR
%
%  ROIPFILENAME = GETROIFILENAME(MD, ITEMNAME, SHOWERROR)
%
%  Returns the filename associated with the ROI parameters for item name
%  ITEMNAME.
%

if nargin<3,
	showerror = 0;
end;

roipfilename = '';

dnames = {};
d = dir([mia.miadir.getpathname(md) 'ROIs' filesep itemname filesep '*ROI_roiparameters.mat']);
dnames = cat(1,dnames,d.name);

if ~isempty(dnames),
	roipfilename = [mia.miadir.getpathname(md) 'ROIs' filesep itemname filesep dnames{1}];
end;

if isempty(roipfilename),
	if showerror,
		errordlg(['Could not locate the ROI parameter file in ' [mia.miadir.getpathname(md) 'ROIs' filesep itemname filesep] '; this directory should be deleted.']);
	end;
end;
