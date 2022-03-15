function s = editors_list
% EDITORS_LIST - List of available MIA.CREATOR.ROI EDITORS functions
%
%  S = mia.roi.editors_list
%
%  Returns in S a cell list of strings with the names of all available functions
%  for making ROIs in array tomography images
%

dirname = fileparts(which('mia.creator.roi.connect')); %grab an example from the directory

d = dir([dirname filesep '*.m']);

s = {};

for i=1:length(d),
    try,
        [dummy,objname,ext] = fileparts(d(i).name);
        eval(['myobj = mia.creator.roi.' objname '();'])
        if myobj.iseditor == 1,
            s{end+1,1} = ['mia.creator.roi.' objname];
        end;
    end;
end;

 
