function out = wiseetal_finaltpfpVG(s, algor, vol_range, N_range)

out.FP = [];
out.TP = [];
out.N = NaN(numel(vol_range), numel(N_range));
out.V = NaN(numel(vol_range), numel(N_range));

for v=1:numel(vol_range),
	for n=1:numel(N_range),
		out.N(v,n) = N_range(n);
		out.V(v,n) = vol_range(v);
		stats = wiseetal_plotstatisticalmoreVG(s,algor,vol_range(v),N_range(n));
		for i=1:numel(stats),
			out.FP(v,n,i) = stats(i).false_positive_rate;
			out.TP(v,n,i) = stats(i).true_positive_rate;
		end;
	end;
end;


