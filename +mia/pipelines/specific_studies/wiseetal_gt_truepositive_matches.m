function [indexes, good_gt] = wiseetal_gt_truepositive_matches(gt_struct, varargin)
% WISEETAL_GT_TRUEPOSITIVE_MATCHES - calculate true positive matches
%
% [INDEXES, GOOD_GT] = WISEETAL_GT_TRUEPOSITIVE_MATCHES(GT_STRUCT)
%
% Given a ground-truth structure (such as that output by AT_GROUNDTRUTHCORRESPONDENCE)
% this function calculates the index of each computer-generated ROI that has the 
% most overlap with each ground-truth ROIs. Ground-truth ROIs are filtered for those
% that are at least as bright as the highest first threshold.
%
% This function also takes name/value pairs that modify its behavior (see `help namevaluepair`):
% ------------------------------------------------------------------------------------|
% | Parameter (default)            | Description                                      |
% |--------------------------------|--------------------------------------------------|
% | overlap_fraction_true_positive | The fraction that a ground-truth ROI mark must   |
% |   (0.3)                        | overlap a computer-generated ROI to be a match   |
% |--------------------------------|--------------------------------------------------|
% 


overlap_fraction_true_positive = 0.3;

vlt.data.assign(varargin{:});

 % Condition 1: the nearest ROIs must match by overlap_fraction_true_positive

 % ROI set A is the GT, ROI set B is the computer

[bestMatches,best_distance] = vlt.image.roi.ROI_bestcolocalization(...
	gt_struct.cla_comp_gt.colocalization_data.overlap_ab',...
	overlap_fraction_true_positive);

 % Condition 2: we don't care about ROIs that are dimmer than the first
 %    threshold

good_gt = find(gt_struct.maxbright_gt>=gt_struct.thresholds(1));

indexes = bestMatches(good_gt);


