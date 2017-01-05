function [IM] = at_image_read(filename, frame_index, varargin)
% AT_IMAGE_READ - Read in a stacked image file for AT analysis
%
%  IM = AT_IMAGE_READ(FILENAME, FRAME_INDEX, ...)
%
%  Reads in FRAME_INDEX of a potentially multi stack image file
%  for AT analysis.  FILENAME is the name of the file, IM is the
%  image output.
%
%  In the future, this function may be able to handle different
%  organizations (like many TIF files representing a stack, etc).
%
%  This function takes name/value pairs:
%  Parameter (default) | Description
%  -------------------------------------------------------
%  iminfo ([])         | Matlab image info returned from
%                      |   IMFINFO
%

iminfo = [];

assign(varargin{:});

extra_vars = {};
if ~isempty(iminfo),
	extra_vars = {'Info',iminfo};
end;

IM = imread(filename,'index',frame_index,extra_vars{:});


