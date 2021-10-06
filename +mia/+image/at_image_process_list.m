function s = at_image_process_list
% AT_IMAGE_PROCESS_LIST - List of available AT_IMAGE_PROCESS functions
%
%  S = AT_IMAGE_PROCESS_LIST
%
%  Returns in S a cell list of strings with the names of all available functions
%  for processing array tomography images
%

dirname = fileparts(which('at_image_threshold')); % grab an example from the directory

d = dir([dirname filesep '*.m']);

s = {};

for i=1:length(d),
	if ~strcmp(lower(d(i).name),lower('Contents.m')),
		[dummy,s{end+1},ext] = fileparts(d(i).name);
	end;
end;


