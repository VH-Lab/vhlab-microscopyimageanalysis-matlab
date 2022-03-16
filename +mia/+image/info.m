function [info] = info(filename)
% INFO - Read in a information of a file for AT analysis
%
%  IM = mia.image.info(FILENAME)
%
%  Gets image info for an image file for AT analysis.
%
%  At present, this function returns the Matlab
%  IMFINFO structure for the first image, and adds a field
%  'number_of_frames', but could be expanded in the future.  
%

info = imfinfo(filename);

number_of_frames = length(info);

info = info(1);
info.number_of_frames = number_of_frames;
info.dim_per_sample = length(info.BitsPerSample);