function s = at_colocalization_makers_list
% AT_COLOCALIZATION_MAKERS_LIST - List of available AT_COLOCALIZATION_MAKERS functions
%
%  S = mia.colocalization.at_colocalization_makers_list
%
%  Returns in S a cell list of strings with the names of all available functions
%  for making COLOCALIZATION analyses in array tomography images
%

dirname = fileparts(which('mia.colocalization.at_colocalization_makers.at_colocalization_shift')); % grab an example from the directory

d = dir([dirname filesep '*.m']);

s = {};

for i=1:length(d),
	if ~strcmp(lower(d(i).name),lower('mia.image.at_image_process.Contents.m')),
		[dummy,s{end+1,1},ext] = fileparts(d(i).name);
	end;
end;


 
