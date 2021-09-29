function [stats] = wiseetal_plotstatisticalmore(s, analysiscode, vol_threshold, N_threshold)

roiname = ['VG_DECsv' int2str(str2num(analysiscode)-100) '_roiresbf']

stats = vlt.data.emptystruct('ROI_properties_true_positives','ROI_properties_false_positives','experindex', 'true_pbright','false_pbright','true_positive_rate','false_positive_rate','true_numabovethreshold','false_numabovethreshold','threshold1','threshold2');

for i=1:numel(s),
	atd = atdir(s(i).dirname);
	disp(['On ' int2str(i) ' of ' int2str(numel(s)) '...']);
	gt_struct = getfield(s(i).groundtruth_analysis.VG,['VGv' analysiscode]);
	for j=1:numel(gt_struct)
		[indexes,good_gt] = wiseetal_gt_truepositive_matches(gt_struct(j));
		indexes_with_match = find(~isnan(indexes));
		total_gt = numel(indexes);
		missing = numel(indexes)-numel(indexes_with_match);
		indexes = indexes(indexes_with_match);
		good_gt = good_gt(indexes_with_match);
		full_parameters_comp = load(gt_struct(j).full_parameters_comp,'-mat');
		stats_here.ROI_properties_true_positives = full_parameters_comp.ROIparameters;
		stats_here.ROI_properties_true_positives.params2d = stats_here.ROI_properties_true_positives.params2d(indexes);
		stats_here.ROI_properties_true_positives.params3d = stats_here.ROI_properties_true_positives.params3d(indexes);

		vol_good = find([stats_here.ROI_properties_true_positives.params3d.Volume]>=vol_threshold);
		stats_here.ROI_properties_true_positives.params2d = stats_here.ROI_properties_true_positives.params2d(vol_good);
		stats_here.ROI_properties_true_positives.params3d = stats_here.ROI_properties_true_positives.params3d(vol_good);

                ti = gt_struct(j).thresholdinfo;
		true_pbright = [];
		true_numabovethreshold = [];
		for k=1:numel(stats_here.ROI_properties_true_positives.params3d),
			Gi = findclosest(double(ti.threshold_signal_to_noise_better(:)), double(stats_here.ROI_properties_true_positives.params3d(k).MaxIntensity));
			true_pbright(end+1) = ti.detection_quality_better(Gi);
			true_numabovethreshold(end+1) = sum(stats_here.ROI_properties_true_positives.params3d(k).VoxelValues >= gt_struct(j).thresholds(1));
		end;

		Ngood = find(true_numabovethreshold>=N_threshold);
		stats_here.ROI_properties_true_positives.params2d = stats_here.ROI_properties_true_positives.params2d(Ngood);
		stats_here.ROI_properties_true_positives.params3d = stats_here.ROI_properties_true_positives.params3d(Ngood);
		
		stats_here.true_pbright = true_pbright;
		stats_here.true_positive_rate = numel(Ngood) / total_gt;
		stats_here.true_numabovethreshold = true_numabovethreshold;
		stats_here.threshold1 = gt_struct(j).thresholds(1);
		stats_here.threshold2 = gt_struct(j).thresholds(2);
	
		[I,good_fp] = wiseetal_gt_falsepositive_matches(gt_struct(j));
		
		stats_here.ROI_properties_false_positives = full_parameters_comp.ROIparameters;
		stats_here.ROI_properties_false_positives.params2d = stats_here.ROI_properties_false_positives.params2d(good_fp);
		stats_here.ROI_properties_false_positives.params3d = stats_here.ROI_properties_false_positives.params3d(good_fp);

		vol_good = find([stats_here.ROI_properties_false_positives.params3d.Volume]>=vol_threshold);
		stats_here.ROI_properties_false_positives.params2d = stats_here.ROI_properties_false_positives.params2d(vol_good);
		stats_here.ROI_properties_false_positives.params3d = stats_here.ROI_properties_false_positives.params3d(vol_good);

                ti = gt_struct(j).thresholdinfo;
		false_pbright = [];
		false_numabovethreshold = [];
                for k=1:numel(stats_here.ROI_properties_false_positives.params3d),
			Gi = findclosest(double(ti.threshold_signal_to_noise_better(:)), double(stats_here.ROI_properties_false_positives.params3d(k).MaxIntensity));
			false_pbright(end+1) = ti.detection_quality_better(Gi);
			false_numabovethreshold(end+1) = sum(stats_here.ROI_properties_false_positives.params3d(k).VoxelValues >= gt_struct(j).thresholds(1));
		end;

		Ngood = find(false_numabovethreshold>=N_threshold);
		stats_here.ROI_properties_false_positives.params2d = stats_here.ROI_properties_false_positives.params2d(Ngood);
		stats_here.ROI_properties_false_positives.params3d = stats_here.ROI_properties_false_positives.params3d(Ngood);
		
		h = gethistory(atd,'ROIs',roiname);
		h(end+1) = struct('parent',roiname,'operation','candidate_false_positives','parameters',[],'description',['Candidate false positive filtered all but ' int2str(numel(good_fp(vol_good))) ' ROIs']);
		[parentdir,filename,ext] = fileparts(gt_struct(j).full_parameters_gt);
		filename_split = strsplit(filename,'_');
		at_roi_savesubset(atd, roiname, good_fp(vol_good(Ngood)), [roiname '_FPC_' filename_split{3}], h);


		stats_here.false_pbright = false_pbright;

		stats_here.false_positive_rate = numel(good_fp(Ngood)) / numel(gt_struct(j).comp_rois_substantially_in_mask);

		stats_here.false_numabovethreshold = false_numabovethreshold;
		
		stats_here.experindex = i;

		stats(end+1) = stats_here;
	end;
end;


