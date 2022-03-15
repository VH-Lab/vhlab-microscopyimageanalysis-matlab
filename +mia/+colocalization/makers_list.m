function s = makers_list
% MAKERS_LIST - List of available MIA.CREATOR.COLOCALIZATION MAKERS functions
%
%  S = MIA.COLOCALIZATION.MAKERS_LIST
%
%  Returns in S a cell list of strings with the names of all available functions
%  for making COLOCALIZATION analyses in array tomography images
%

dirname = fileparts(which('mia.creator.colocalization.shift')); %grab an example from the directory

d = dir([dirname filesep '*.m']);

s = {};

for i=1:length(d),
    try,
        [dummy,objname,ext] = fileparts(d(i).name);
        eval(['myobj = mia.creator.colocalization.' objname '();'])
        if myobj.iseditor == 0,
            s{end+1,1} = ['mia.creator.colocalization.' objname];
        end;
    end;
end;


