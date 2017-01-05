function [N,bins,sizes] = plot_roi_sizes(imrois, numbins)
% PLOT_ROI_SIZES - Plot the distribution of ROI sizes
%
%  [N,BINS,SIZES] = PLOT_ROI_SIZES(IMROIS, NUMBINS)
%
%  Return the roi sizes as a frequency histogram.
%
%  Inputs:
%  IMROIS are the image ROIs that are returned from
%  SPOTDETECTOR3. NUMBINS is the number of bins to use.
%
%  Outputs:
%  N is the number of rois in each bin, BINS are the
%  size bins that can be plotted with BAR. SIZES are the
%  size of each ROI (will be the same length as IMROIS).
%
%  See also: SPOTDETECTOR3, HISTC
%

sizes = [];

for i=1:length(imrois),
	sizes(i) = length(imrois(i).pixelinds);
end;

[N,bins] = hist(sizes,numbins);
