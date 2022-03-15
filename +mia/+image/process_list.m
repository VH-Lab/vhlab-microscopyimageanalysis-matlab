function s = process_list
% PROCESS_LIST - List of available MIA.CREATOR.IMAGE functions
%
%  S = mia.image.process_list
%
%  Returns in S a cell list of strings with the names of all available functions
%  for processing array tomography images
%

dirname = fileparts(which('mia.creator.image.threshold')); % grab an example from the directory

d = dir([dirname filesep '*.m']);

s = {};

for i=1:length(d),
	if ~strcmp(lower(d(i).name),lower('mia.creator.image.Contents.m')),
		[dummy,s{end+1},ext] = fileparts(d(i).name);
	end;
end;


 
