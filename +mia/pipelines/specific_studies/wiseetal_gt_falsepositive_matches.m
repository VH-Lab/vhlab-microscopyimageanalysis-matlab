function [indexes, good_fp] = wiseetal_gt_falsepositive_matches(gt_struct, varargin)
% WISEETAL_GT_FALSEPOSITIVE_MATCHES - calculate false positive matches
%
% [INDEXES, GOOD_GT] = WISEETAL_GT_FALSEPOSITIVE_MATCHES(GT_STRUCT)
%
% Given a ground-truth structure (such as that output by AT_GROUNDTRUTHCORRESPONDENCE)
% this function calculates the index of each computer-generated ROI that has the
% most overlap with each ground-truth ROIs. Ground-truth ROIs are filtered for those
% that are at least as bright as the highest first threshold.
%
% This function also takes name/value pairs that modify its behavior (see `help namevaluepair`):
% --------------------------------------------------_----------------------------------|
% | Parameter (default)             | Description                                      |
% |---------------------------------|--------------------------------------------------|
% | overlap_fraction_false_positive | The fraction that a computer-generated ROI must  |
% |   (0.01)                        | overlap a human-generated ROI mark to be a match |
% |---------------------------------|--------------------------------------------------|
%

overlap_fraction_false_positive = 0.01;

vlt.data.assign(varargin{:});


 % Condition 1: the nearest ROIs must match by overlap_fraction_true_positive

 % ROI set A is the GT, ROI set B is the computer

[bestMatches,best_distance] = vlt.image.roi.ROI_bestcolocalization(...
	gt_struct.cla_comp_gt.colocalization_data.overlap_ba(gt_struct.comp_rois_substantially_in_mask,:)',...
	overlap_fraction_false_positive);

 % Condition 2: we don't care about ROIs that are dimmer than the first
 %    threshold

good_fp = find(gt_struct.maxbright_comp_substantial>=gt_struct.thresholds(1));

indexes = bestMatches(good_fp);

good_fp = gt_struct.comp_rois_substantially_in_mask(good_fp);

 % now find only the ones with no match

thenans = find(isnan(indexes));

indexes = indexes(thenans);
good_fp = good_fp(thenans);


