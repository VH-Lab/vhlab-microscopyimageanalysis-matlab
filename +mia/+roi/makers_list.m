function s = makers_list
% MAKERS_LIST - List of available ROI_MAKERS functions
%
%  S = mia.roi.makers_list
%
%  Returns in S a cell list of strings with the names of all available functions
%  for making ROIs in array tomography images
%

dirname = fileparts(which('mia.roi.makers.connect')); % grab an example from the directory

d = dir([dirname filesep '*.m']);

s = {};

for i=1:length(d),
	if ~strcmp(lower(d(i).name),lower('mia.image.process.Contents.m')),
		[dummy,s{end+1,1},ext] = fileparts(d(i).name);
	end;
end;


 
