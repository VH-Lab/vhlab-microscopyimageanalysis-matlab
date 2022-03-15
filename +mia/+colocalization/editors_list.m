function s = editors_list
% AT_COLOCALIZATION_COLOCALIZATION_LIST - List of available MIA.CREATOR.COLOCALIZATION EDITORS functions
%
%  S = AT_COLOCALIZATION_EDITORS LIST
%
%  Returns in S a cell list of strings with the names of all available functions
%  for editing CLA calculations in array tomography images
%

dirname = fileparts(which('mia.creator.colocalization.rethreshold')); %grab an example from the directory

d = dir([dirname filesep '*.m']);

s = {};

for i=1:length(d),
    try,
        [dummy,objname,ext] = fileparts(d(i).name);
        eval(['myobj = mia.creator.colocalization.' objname '();'])
        if myobj.iseditor == 1,
            s{end+1,1} = ['mia.creator.colocalization.' objname];
        end;
    end;
end;