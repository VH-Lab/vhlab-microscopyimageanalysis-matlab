function s = wiseetal_summary(d)
% WISEETAL_SUMMARY - generate a summary structure of the experiments of Wise et al
%
%
% S = WISEETAL_SUMMARY(D)
%
% D is a directory list of all experiments.
%

s = vlt.data.emptystruct('metadata','groundtruth_analysis');

for i=1:numel(d),
	s_here.metadata = vlt.file.loadStructArray([d{i} filesep 'metadata.tsv']);
	s_here.groundtruth_analysis = wiseetal_loadgtanalysis(d{i});
	s(end+1) = s_here;
end;


