function ad = atdir(pathname)
% ATDIR - data directory management for Array Tomography data.
%
%  AD = ATDIR(PATHNAME)
%
%  Creates a data directory management object AD with full pathname
%  PATHNAME.
% 
%  The directory format is as follows. There is a directory
%  named PATHNAME that contains all the data. PATHNAME has subdirectories,
%  named 'images','rois', and 'colocalization', or other names, that contain
%  information relevant to the analysis of the data.
%
%  Graphically, the file organization looks like the following:
%  experiment/
%    images/
%        named_images/
%            (either single image or individual images of channels)
%    rois/
%        named_rois
%            rois.mat - ROI data structure
%            L.mat - Labeled image
%            history.mat - list of actions that led to these rois
%            labels - labels of these rois
%    colocalization/
%
%
% See also: METHODS('ATDIR')
%


if nargin == 0,
	pathname = '';
else,
	pathname = fixpath(pathname);
	if exist(pathname)~=7, error([pathname ' does not exist.']); end;
end;

S = struct('pathname',pathname);
ad = class(S,'atdir');

