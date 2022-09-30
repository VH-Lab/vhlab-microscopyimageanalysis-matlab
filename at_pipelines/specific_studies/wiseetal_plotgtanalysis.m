function out = wiseetal_plotgtanalysis(s)


volume_low_filters = [0 20 50 75 100 125];
false_positive_overlap_threshold_index = 1;
true_positive_overlap_threshold_index = 4;

psd_experindex = [];
psd_falsepositives = [];
psd_truepositives = [];
vg_experindex = [];
vg_falsepositives = [];
vg_truepositives = [];

for i=1:numel(s),
	if isstruct(s(i).groundtruth_analysis.PSD),
		fn = fieldnames(s(i).groundtruth_analysis.PSD);
	else,
		fn = {};
	end;
	for j=1:numel(fn),
		n = sscanf(fn{j},'PSDv%d');
		h = getfield(s(i).groundtruth_analysis.PSD,fn{j});
		for k=1:numel(h),
			[parentname,thefilename,theext] = fileparts(h(k).full_parameters_gt);
			switch (thefilename),
				case 'PSD_ROI_DW_ROIres_ROI_roiparameters',
					u = 1;
				case 'PSD_ROI_DWL_ROIres_ROI_roiparameters',
					u = 2;
				case 'PSD_ROI_SG_ROIres_ROI_roiparameters',
					u = 3;
				case 'PSD_ROI_KC_ROIres_ROI_roiparameters',
					u = 4;
				otherwise, 
					u = 5; 
			end;
			psd_experindex(end+1) = i;
			psd_truepositives(end+1,1) = n;
			psd_falsepositives(end+1,1) = n;
			psd_truepositives(end,2) = u;
			psd_falsepositives(end,2) = u;
			for v=1:numel(volume_low_filters),
				%good_roi_gt = find(h(k).vol_gt>volume_low_filters(v)); %&h(k).maxbright_gt>=h(k).thresholds(1));
				good_roi_gt = find(h(k).vol_gt>-Inf); % every ground truth ROI should count, they are called real
				good_roi_cs = find(h(k).vol_comp_substantial>volume_low_filters(v));
				psd_falsepositives(end,2+v) = sum(h(k).N_overlaps_comp_substantial_onto_gt(good_roi_cs,false_positive_overlap_threshold_index)==0)/numel(good_roi_cs);
				psd_truepositives(end,2+v) = sum(h(k).N_overlaps_gt_onto_comp(good_roi_gt,true_positive_overlap_threshold_index)>0)/numel(good_roi_gt);
			end;
			
		end;
	end;
	if isstruct(s(i).groundtruth_analysis.VG),
		fn = fieldnames(s(i).groundtruth_analysis.VG);
	else,
		fn = {};
	end;
	for j=1:numel(fn),
		n = sscanf(fn{j},'VGv%d');
		h = getfield(s(i).groundtruth_analysis.VG,fn{j});
		for k=1:numel(h),
			[parentname,thefilename,theext] = fileparts(h(k).full_parameters_gt);
			switch (thefilename),
				case 'VG_ROI_DW_ROIres_ROI_roiparameters',
					u = 1;
				case 'VG_ROI_DWL_ROIres_ROI_roiparameters',
					u = 2;
				case 'VG_ROI_SG_ROIres_ROI_roiparameters',
					u = 3;
				case 'VG_ROI_KC_ROIres_ROI_roiparameters',
					u = 4;
				otherwise, 
					u = 5;
			end;
			vg_experindex(end+1) = i;
			vg_falsepositives(end+1,1) = n;
			vg_truepositives(end+1,1) = n;
			vg_falsepositives(end,1) = u;
			vg_truepositives(end,1) = u;
			for v=1:numel(volume_low_filters),
				%good_roi_gt = find(h(k).vol_gt>volume_low_filters(v)&h(k).maxbright_gt>=h(k).thresholds(1));
				good_roi_gt = find(h(k).vol_gt>-Inf); 
				good_roi_cs = find(h(k).vol_comp_substantial>volume_low_filters(v));
				vg_falsepositives(end,2+v) = sum(h(k).N_overlaps_comp_substantial_onto_gt(good_roi_cs,false_positive_overlap_threshold_index)==0)/numel(good_roi_cs);
				vg_truepositives(end,2+v) = sum(h(k).N_overlaps_gt_onto_comp(good_roi_gt,true_positive_overlap_threshold_index)>0)/numel(good_roi_gt);
			end;
		end;
	end;
end;

out = workspace2struct();
