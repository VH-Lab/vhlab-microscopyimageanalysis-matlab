function [stats] = wiseetal_plotstatisticalmore(s, analysiscode, vol_threshold)

stats = vlt.data.emptystruct('ROI_properties_true_positives','ROI_properties_false_positives','experindex');

for i=1:numel(s),
	gt_struct = getfield(s(i).groundtruth_analysis.PSD,['PSDv' analysiscode]);
	for j=1:numel(gt_struct)
		[indexes,good_gt] = wiseetal_gt_truepositive_matches(gt_struct(j));
		indexes_with_match = find(~isnan(indexes));
		indexes = indexes(indexes_with_match);
		good_gt = good_gt(indexes_with_match);
		stats_here.ROI_properties_true_positives = gt_struct(j).full_parameters_comp.ROIparameters;
		stats_here.ROI_properties_true_positives.params2d = stats_here.ROI_properties_true_positives.params2d(indexes);
		stats_here.ROI_properties_true_positives.params3d = stats_here.ROI_properties_true_positives.params3d(indexes);

		vol_good = find([stats_here.ROI_properties_true_positives.param3d.Volume]>=vol_threshold);
		stats_here.ROI_properties_true_positives.params2d = stats_here.ROI_properties_true_positives.params2d(vol_good);
		stats_here.ROI_properties_true_positives.params3d = stats_here.ROI_properties_true_positives.params3d(vol_good);
		
		[I,good_fp] = wiseetal_gt_falsepositive_matches(gt_struct(j));
		stats_here.ROI_properties_false_positives = gt_struct(j).full_parameters_comp.ROIparameters;
		stats_here.ROI_properties_false_positives.params2d = stats_here.ROI_properties_false_positives.params2d(good_fp);
		stats_here.ROI_properties_false_positives.params3d = stats_here.ROI_properties_false_positives.params3d(good_fp);

		vol_good = find([stats_here.ROI_properties_false_positives.param3d.Volume]>=vol_threshold);
		stats_here.ROI_properties_false_positives.params2d = stats_here.ROI_properties_false_positives.params2d(vol_good);
		stats_here.ROI_properties_false_positives.params3d = stats_here.ROI_properties_false_positives.params3d(vol_good);
		
		stats_here.experindex = i;

		stats(end+1) = stats_here;
	end;
end;


