function s = at_colocalization_editors_list
% AT_COLOCALIZATION_COLOCALIZATION_LIST - List of available AT_COLOCALIZATION editor functions
%
%  S = AT_COLOCALIZATION_EDITORS LIST
%
%  Returns in S a cell list of strings with the names of all available functions
%  for editing CLA calculations in array tomography images
%

dirname = fileparts(which('at_colocalization_rethreshold')); %grab an example from the directory

d = dir([dirname filesep '*.m']);

s = {};

for i=1:length(d),
	if ~strcmp(lower(d(i).name),lower('Contents.m')),
		[dummy,s{end+1,1},ext] = fileparts(d(i).name);
	end;
end;

