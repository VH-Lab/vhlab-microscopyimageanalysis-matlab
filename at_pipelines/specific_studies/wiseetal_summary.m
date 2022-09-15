function s = wiseetal_summary(d)
% WISEETAL_SUMMARY - generate a summary structure of the experiments of Wise et al
%
%
% S = WISEETAL_SUMMARY(D)
%
% D is a directory list of all experiments.
%

s = vlt.data.emptystruct('metadata','groundtruth_analysis','groundtruth_analysis2','groundtruth_analysisC','dirname');

for i=1:numel(d),
	disp(['Working on ' int2str(i) ' of ' int2str(numel(d)) '...']);
	s_here.metadata = vlt.file.loadStructArray([d{i} filesep 'metadata.tsv']);
	s_here.groundtruth_analysis = wiseetal_loadgtanalysis(d{i});
	s_here.groundtruth_analysis2 = wiseetal_loadgtanalysis2(d{i});
	s_here.groundtruth_analysisC = wiseetal_loadgtanalysisC(d{i});
	s_here.dirname = d{i};
	s(end+1) = s_here;
end;


