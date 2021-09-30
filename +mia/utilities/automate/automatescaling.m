function automatescaling(fname)
% Input e.g.
% fname = 'D:\Analysis Data\Synaptic Imaging\Analysis 6, irreversibility\inhbitory\11-17-20'

filenames = dir(fname);
for i=1:numel(filenames),
    [starts,stops] = regexp(filenames(i).name,'^[C](\d+)[-]','forceCellOutput');
    if ~isempty(starts{1})
    airyscaler3overnight([fname filesep filenames(i).name])
end, end

end