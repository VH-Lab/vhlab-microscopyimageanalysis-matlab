function [t, out] = at_estimatethresholds(im, varargin)
% AT_ESTIMATETHRESHOLDS - estimate thresholds for object detection
%
% [T,OUT] = AT_ESTIMATETHRESHOLDS(IM, ...)
%
% Estimate the thresholds for detecting objects in the array tomography
% (or sparse confocal image) IM.
%
% First, the signal is assumed to be present primarily in the top 
% 75th percentile of the data. The noise is modeled as a skewed gauss-like
% process after removing the top 75th percentile of the data.
% (See vlt.fit.skewgauss)
%
%
% Outputs:
%   t - Recommended thresholds to be 80% and 30% sure one is reading signal compared to noise
%   out - A structure with fields:
%      bin_centers - bin centers for automatic histogram used to examine data
%      bin_edges - the edges used in the automatic histogram
%      counts - count of data in each
%      p_noise - parameters of the noise model for vlt.fit.skewgaussian
%      noise_fit - fit of the noise distribution (bin_centers as x values)
%      signal_y - [30 80 95 99 99.9 99.99]
%      signal_x - conservative estimates of the values of IM that stand out
%                   beyond the noise signal at the 30th, 80th, 95th 99th, 99.9th, 99.99th percentile
%      detection_quality - [0:95], detection quality reference
%      threshold_signal_to_noise - same size as detection_quality; the ith value indicates
%                                  the value of IM that stands out beyond noise at the ith
%                                  percentile; estimated linearly based on conservative estimates
%                                  for the range 30-80
%      detection_quality_better - [ 30:99 99.01:99.99 99.991:0.001:99.999 ]
%      threshold_signal_to_noise_better - same size as detection_quality;_better the ith value indicates
%                                  the value of IM that stands out beyond noise at the ith
%                                  percentile; estimated based on conservative estimates
%                                  for the range 30-99.9999

% This function also takes names/value pairs that modify its behavior:
% Parameter (default)            | Description
% ---------------------------------------------------------------------
% noisePrctile (75)              | Percentile cut-off for defining likely noise.
%                                |   Values below this percentile will be considered noise.
% plotit (0)                     | 0/1 Should we plot our model and histograms?
% plotinnewfigure (1)            | 0/1 If we plot, should we do it in a new figure?
% medfilterwindow (10)           | Window for median filter (1 for none)
% t_levels ([80 30])             | Threshold levels to use
%
%
% See also: vlt.fit.skewgauss
%

noisePrctile = 75;
plotit = 0;
plotinnewfigure = 1;
medfilterwindow = 10;
t_levels = [80 30];

vlt.data.assign(varargin{:});

t = [];
out = [];

im = double(im); % in case it is not already

MX = max(im(:));

out.bin_edges = [-0.5:1:MX+0.5];
out.bin_centers = 0.5+out.bin_edges;
out.counts = histc(im(:),out.bin_edges);
out.counts = out.counts(:)';

  % don't do it this way anymore; produces sub pixel bins that have 0 entries
  % [out.counts,out.bin_centers, out.bin_edges] = autohistogram(im(:));

noiseCutOff = prctile(im(:),noisePrctile);

idx = find(im(:)<noiseCutOff);

bin_range = find(out.bin_centers<=noiseCutOff);
bin_range = bin_range(end);

[p_noise1,gof1]=vlt.fit.skewgaussfit_constraints(out.bin_centers(1:bin_range)', out.counts(1:bin_range)',...
	'a_range',[0 0],'d_hint',5*(0.1*(bin_range-1))); 
[p_noise2,gof2]=vlt.fit.skewgaussfit_constraints(out.bin_centers(1:bin_range)', out.counts(1:bin_range)',...
	'a_range',[0 0]);
if gof1.sse<gof2.sse,
    out.p_noise = p_noise1;
    gof = gof1;
else,
    out.p_noise = p_noise2;
    gof = gof2;
end;


out.noise_fit = vlt.fit.skewgauss(out.bin_centers,out.p_noise);

percent_signal_to_noise = 100 * (out.counts-out.noise_fit)./out.counts;

valid_pts = ~isinf(percent_signal_to_noise) & ~isnan(percent_signal_to_noise);
percent_signal_to_noise = percent_signal_to_noise(valid_pts);
valid_bin_centers = out.bin_centers(valid_pts);

percent_signal_to_noise_orig = percent_signal_to_noise;
percent_signal_to_noise = medfilt1(percent_signal_to_noise,medfilterwindow);

signal_95 = 1+find(percent_signal_to_noise(1:end-1)<95&percent_signal_to_noise(2:end)>=95);
signal_80 = 1+find(percent_signal_to_noise(1:end-1)<80 & percent_signal_to_noise(2:end)>=80);
signal_30 = 1+find(percent_signal_to_noise(1:end-1)<30 & percent_signal_to_noise(2:end)>=30);

signal_99 = 1+find(percent_signal_to_noise(1:end-1)<99 & percent_signal_to_noise(2:end)>=99);
signal_999 = 1+find(percent_signal_to_noise(1:end-1)<99.9 & percent_signal_to_noise(2:end)>=99.9);
signal_9999 = 1+find(percent_signal_to_noise(1:end-1)<99.99 & percent_signal_to_noise(2:end)>=99.99);

 % find the last time it goes above those thresholds and doesn't drop below ever again, moving up
signal_95 = signal_95(end);
signal_80 = signal_80(end); % the last time it happens and doesn't drop below
signal_30 = signal_30(end);

signal_99 = signal_99(end);
signal_999 = signal_999(end);
signal_9999 = signal_9999(end);


out.signal_y = [30 80 95 99 99.9 99.99]';
out.signal_x = [valid_bin_centers([signal_30 signal_80 signal_95 signal_99 signal_999 signal_9999])]';
w = warning; % get the warning state
warning('off');
[slope,offset] = vlt.stats.quickregression(percent_signal_to_noise(signal_30:signal_80)', valid_bin_centers([signal_30:signal_80])', 0.05);
warning(w);
out.detection_quality = 0:95;
out.threshold_signal_to_noise = offset + slope * out.detection_quality;

threshold_locs = [];
for i=1:numel(t_levels),
	ind = vlt.data.findclosest(out.detection_quality,t_levels(i));
	threshold_locs(i) = ind;
end;

out.detection_quality_better = colvec([ 30:99 99.01:99.99 99.991:0.001:99.999 99.9991:0.0001:99.9999 99.99991:0.00001:99.99999]);

signal_nn = [];
for i=1:numel(out.detection_quality_better),
	signal_nnn = 1+find(percent_signal_to_noise(1:end-1)<out.detection_quality_better(i) &...
		percent_signal_to_noise(2:end)>=out.detection_quality_better(i));
	if isempty(signal_nnn), disp('empty here'); i, end;
	signal_nn(end+1) = signal_nnn(end);
end;

out.threshold_signal_to_noise_better = valid_bin_centers(signal_nn(:));

%t = out.threshold_signal_to_noise(threshold_locs);
t = interp1(out.detection_quality_better(:),out.threshold_signal_to_noise_better(:),t_levels(:),'linear');

out.t_levels = t_levels;

if plotit,
	if plotinnewfigure, 
		figure;
	end;

	if 0,
		subplot(2,1,1);
		bar(out.bin_centers, out.counts,1);
		hold on;
		plot(out.bin_centers,out.noise_fit,'r','linewidth',2);
		box off;
		ylabel('Counts');
		xlabel('Brightness bins');

		subplot(2,1,2);
		plot(valid_bin_centers,percent_signal_to_noise);
		hold on;
		plot(valid_bin_centers([signal_30 signal_80 signal_95]),[30 80 95],'ko');
		plot(out.threshold_signal_to_noise, out.detection_quality, 'k-');
		box off;
		ylabel('Signal better than noise likelihood (%)');
		xlabel('Brightness bins');
	end;

	if 1,
		yyaxis left
		bar(out.bin_centers,out.counts,1);
		hold on;
		plot(out.bin_centers,out.noise_fit,'g-','linewidth',2);
		set(gca,'ylim',[0 max(out.counts(:))]);
		ylabel('Counts');

		yyaxis right
		plot(valid_bin_centers,percent_signal_to_noise_orig,'r');
		hold on;
		plot(valid_bin_centers,percent_signal_to_noise,'m');
		plot(valid_bin_centers([signal_30 signal_80 signal_95]),[30 80 95],'ko');
		plot(out.threshold_signal_to_noise, out.detection_quality, 'k-','linewidth',1);

		for i=1:numel(threshold_locs),
			plot(out.threshold_signal_to_noise(threshold_locs(i))*[1 1],[0 100],'k--');
		end;

		ylabel('Signal : noise likelihood (%)');
		xlabel('Brightness bins');
		box off;

		ind = min(find(out.counts(:)>10));
		dx = valid_bin_centers(signal_95) - out.bin_centers(ind);

		set(gca,'ylim',[0 101]);
		set(gca,'xlim',[out.bin_centers(ind) valid_bin_centers(signal_95)+0.5*dx]);
	end;
end;


