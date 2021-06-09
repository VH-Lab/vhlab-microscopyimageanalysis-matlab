function [indexes, good_gt] = wiseetal_gt_truepositive_matches(gt_struct)

overlap_fraction_true_positive = 0.3;

 % Condition 1: the nearest ROIs must match by overlap_fraction_true_positive

 % ROI set A is the GT, ROI set B is the computer

[bestMatches,best_distance] = vlt.image.roi.ROI_bestcolocalization(...
	gt_struct.cla_comp_gt.colocalization_data.overlap_ab',...
	overlap_fraction_true_positive);

 % Condition 2: we don't care about ROIs that are dimmer than the first
 %    threshold

good_gt = find(gt_struct.maxbright_gt>=gt_struct.thresholds(1));

indexes = bestMatches(good_gt);


