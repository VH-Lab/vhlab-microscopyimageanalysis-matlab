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
%      signal_y - [30 80 95]
%      signal_x - conservative estimates of the values of IM that stand out
%                   beyond the noise signal at the 30th, 80th, and 95th percentile
%      detection_quality - [0:95], detection quality reference
%      threshold_signal_to_noise - same size as detection_quality; the ith value indicates
%                                  the value of IM that stands out beyond noise at the ith
%                                  percentile; estimated linearly based on conservative estimates
%                                  for the range 30-80
%
% This function also takes names/value pairs that modify its behavior:
% Parameter (default)            | Description
% ---------------------------------------------------------------------
% noisePrctile (75)              | Percentile cut-off for defining likely noise.
%                                |   Values below this percentile will be considered noise.
% plotit (0)                     | 0/1 Should we plot our model and histograms?
% plotinnewfigure (1)            | 0/1 If we plot, should we do it in a new figure?
%
%
% See also: vlt.fit.skewgauss
%

noisePrctile = 75;
plotit = 0;
plotinnewfigure = 1;

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

[out.p_noise,gof]=vlt.fit.skewgaussfit_constraints(out.bin_centers(1:bin_range)', out.counts(1:bin_range)',...
	'a_range',[0 0]); 

out.noise_fit = vlt.fit.skewgauss(out.bin_centers,out.p_noise);

percent_signal_to_noise = 100 * (out.counts-out.noise_fit)./out.counts;

valid_pts = ~isinf(percent_signal_to_noise) & ~isnan(percent_signal_to_noise);
percent_signal_to_noise = percent_signal_to_noise(valid_pts);
valid_bin_centers = out.bin_centers(valid_pts);

signal_95 = 1+find(percent_signal_to_noise(1:end-1)<95&percent_signal_to_noise(2:end)>=95);
signal_80 = 1+find(percent_signal_to_noise(1:end-1)<80 & percent_signal_to_noise(2:end)>=80);
signal_30 = 1+find(percent_signal_to_noise(1:end-1)<30 & percent_signal_to_noise(2:end)>=30);

 % find the last time it goes above those thresholds and doesn't drop below ever again, moving up
signal_95 = signal_95(end);
signal_80 = signal_80(end); % the last time it happens and doesn't drop below
signal_30 = signal_30(end);

out.signal_y = [30 80 95]';
out.signal_x = [valid_bin_centers([signal_30 signal_80 signal_95])]';
w = warning; % get the warning state
warning('off');
[slope,offset] = vlt.stats.quickregression(percent_signal_to_noise(signal_30:signal_80)', valid_bin_centers([signal_30:signal_80])', 0.05);
warning(w);
out.detection_quality = 0:95;
out.threshold_signal_to_noise = offset + slope * out.detection_quality;

if plotit,
	if plotinnewfigure, 
		figure;
	end;

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

t = out.threshold_signal_to_noise([81 31]);
