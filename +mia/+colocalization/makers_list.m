function s = makers_list
% MAKERS_LIST - List of available AT_COLOCALIZATION_MAKERS functions
%
%  S = MIA.COLOCALIZATION.MAKERS_LIST
%
%  Returns in S a cell list of strings with the names of all available functions
%  for making COLOCALIZATION analyses in array tomography images
%

dirname = fileparts(which('mia.colocalization.makers.shift')); % grab an example from the directory

d = dir([dirname filesep '*.m']);

s = {};

for i=1:length(d),
	if ~strcmp(lower(d(i).name),lower('mia.image.process.Contents.m')),
		[dummy,s{end+1,1},ext] = fileparts(d(i).name);
	end;
end;


