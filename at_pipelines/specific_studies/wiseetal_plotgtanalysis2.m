function out = wiseetal_plotgtanalysis(s)


volume_low_filters = [0 20 50 75 100 125];
false_positive_overlap_threshold_index = 2;
true_positive_overlap_threshold_index = 4;

psd_experindex = [];
psd_falsepositives = [];
psd_truepositives = [];
vg_experindex = [];
vg_falsepositives = [];
vg_truepositives = [];

for i=1:numel(s),
	n = 1; %sscanf(fn{j},'PSDv%d');
	h = s(i).groundtruth_analysis2.PSD_DEC_auto;
	for k=1:numel(h),
		psd_experindex(end+1) = i;
		psd_falsepositives(end+1,1) = n;
		psd_truepositives(end+1,1) = n;
		for v=1:numel(volume_low_filters),
			good_roi_gt = find(h(k).vol_gt>volume_low_filters(v)&h(k).maxbright_gt>=h(k).thresholds(1));
			good_roi_cs = find(h(k).vol_comp_substantial>volume_low_filters(v));
			psd_falsepositives(end,1+v) = sum(h(k).N_overlaps_comp_substantial_onto_gt(good_roi_cs,false_positive_overlap_threshold_index)==0)/numel(good_roi_cs);
			psd_truepositives(end,1+v) = sum(h(k).N_overlaps_gt_onto_comp(good_roi_gt,true_positive_overlap_threshold_index)>0)/numel(good_roi_gt);
		end;
		
	end;
	n = 1; %sscanf(fn{j},'VGv%d');
	h = s(i).groundtruth_analysis2.VG_DEC_auto;
	for k=1:numel(h),
		vg_experindex(end+1) = i;
		vg_falsepositives(end+1,1) = n;
		vg_truepositives(end+1,1) = n;
		for v=1:numel(volume_low_filters),
			good_roi_gt = find(h(k).vol_gt>volume_low_filters(v)&h(k).maxbright_gt>=h(k).thresholds(1));
			good_roi_cs = find(h(k).vol_comp_substantial>volume_low_filters(v));
			vg_falsepositives(end,1+v) = sum(h(k).N_overlaps_comp_substantial_onto_gt(good_roi_cs,false_positive_overlap_threshold_index)==0)/numel(good_roi_cs);
			vg_truepositives(end,1+v) = sum(h(k).N_overlaps_gt_onto_comp(good_roi_gt,true_positive_overlap_threshold_index)>0)/numel(good_roi_gt);
		end;
	end;
end;

out = workspace2struct();
