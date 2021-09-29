function [brightstats] = wiseetal_plotstatisticalbrightness(s)

brightstats = vlt.data.emptystruct('experindex','rawbright','pbright');

figure;

subplot(2,2,1);

lumped = [];

for i=1:numel(s),
	for j=1:numel(s(i).groundtruth_analysis.PSD.PSDv101),
		rawbright = s(i).groundtruth_analysis.PSD.PSDv101(j).nonres_maxbright_gt;
		ti = s(i).groundtruth_analysis.PSD.PSDv101(j).thresholdinfo;
		pbright = [];
		for k=1:numel(rawbright),
			Gi = findclosest(double(ti.threshold_signal_to_noise_better(:)), double(rawbright(k)));
			pbright(end+1) = ti.detection_quality_better(Gi);
		end;
		brightstats(end+1) = struct('experindex',i,'rawbright',rawbright','pbright',pbright);

		plot(brightstats(end).rawbright,brightstats(end).pbright,'ko');	
		hold on;
		lumped = cat(1,lumped,brightstats(end).pbright(:));
	end;
end;


subplot(2,2,2);

edges = [30:1:101]-0.5;
N = histc(lumped,edges);

bin_centers = (edges(1:end-1) + edges(2:end))/2;

N = 100* N/sum(N);

bar(bin_centers,N(1:end-1));

[colvec(bin_centers) colvec(cumsum(N(1:end-1)))]
