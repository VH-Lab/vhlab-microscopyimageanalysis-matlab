function out = wiseetal_plotgtanalysis(s)


psd_experindex = [];
psd_falsepositives = [];
psd_truepositives = [];

for i=1:numel(s),
	if isstruct(s(i).groundtruth_analysisC.PSD),
		fn = fieldnames(s(i).groundtruth_analysisC.PSD);
	else,
		fn = {};
	end;
	for j=1:numel(fn),
		n = sscanf(fn{j},'PSDv%d');
		h = getfield(s(i).groundtruth_analysisC.PSD,fn{j});
		for k=1:numel(h),
			psd_experindex(end+1) = i;
			psd_falsepositives(end+1,1) = n;
			psd_truepositives(end+1,1) = n;
			psd_falsepositives(end,1:11) = h.compA.false_positives_rate;
			psd_truepositives(end,1+v) = h.true_positive_rate;
		end;
	end;
end;

out = workspace2struct();
