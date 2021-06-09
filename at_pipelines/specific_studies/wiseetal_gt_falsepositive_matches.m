function [indexes, good_fp] = wiseetal_gt_falsepositive_matches(gt_struct)

overlap_fraction_false_positive = 0.2;


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


