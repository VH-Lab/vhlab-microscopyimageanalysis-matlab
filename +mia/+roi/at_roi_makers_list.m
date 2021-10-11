function s = at_roi_makers_list
% AT_ROI_MAKERS_LIST - List of available AT_ROI_MAKERS functions
%
%  S = mia.roi.at_roi_makers_list
%
%  Returns in S a cell list of strings with the names of all available functions
%  for making ROIs in array tomography images
%

dirname = fileparts(which('mia.roi.makers.at_roi_connect')); % grab an example from the directory

d = dir([dirname filesep '*.m']);

s = {};

for i=1:length(d),
	if ~strcmp(lower(d(i).name),lower('mia.image.process.Contents.m')),
		[dummy,s{end+1,1},ext] = fileparts(d(i).name);
	end;
end;


 
