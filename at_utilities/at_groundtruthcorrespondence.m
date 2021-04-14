function [stats] = at_groundtruthcorrespondence(atd, computer_rois, maskregion_rois, groundtruth_rois, varargin)
% AT_GROUNDTRUTHCORRESPONDENCE 
%
%
% 


overlap_threshold_mask = 0.1;
overlap_comp_onto_gt = 0.1;
overlap_gt_onto_comp = 0.1;

vlt.data.assign(varargin{:});

cla_list = getitems(atd, 'CLAs');

cla_comp_mask_fname = getcolocalizationfilename(atd, [maskregion_rois '_x_' computer_rois '_CLA']);
cla_comp_gt_fname = getcolocalizationfilename(atd, [groundtruth_rois '_x_' computer_rois '_CLA']);

cla_comp_mask = load(cla_comp_mask_fname,'-mat');
cla_comp_gt = load(cla_comp_gt_fname,'-mat');

% which ROIs detected by the computer have some overlap with the masked region?
[comp_rois_with_some_mask,J] = find(cla_comp_mask.colocalization_data.overlap_ba>overlap_threshold_mask);

% which ROIs detected by the computer substantially overlap the groundtruth ROIs?

N_overlap_comp_onto_gt_thresholds = 10;
N_comp_rois = numel(comp_rois_with_some_mask);
N_groundtruth_rois = size(cla_comp_gt.colocalization_data.overlap_ab,1);

N_overlaps_comp_onto_gt = zeros(N_comp_rois,N_overlap_comp_onto_gt_thresholds);
N_overlaps_gt_onto_comp = zeros(N_groundtruth_rois,N_overlap_comp_onto_gt_thresholds);

os = linspace(0,0.9,N_overlap_comp_onto_gt_thresholds);

for i=1:length(os),
	N_overlaps_comp_onto_gt(:,i) = [ full(sum(cla_comp_gt.colocalization_data.overlap_ba(comp_rois_with_some_mask,:)>os(i),2)) ];
	N_overlaps_gt_onto_comp(:,i) = [ full(sum(cla_comp_gt.colocalization_data.overlap_ab(:,comp_rois_with_some_mask)>os(i),2)) ]';
end;

roi_comp_params_file = getroiparametersfilename(atd,cla_comp_gt.colocalization_data.parameters.roi_set_2);
roi_gt_params_file = getroiparametersfilename(atd,cla_comp_gt.colocalization_data.parameters.roi_set_1);

roi_comp_params = load(roi_comp_params_file,'-mat');
roi_gt_params = load(roi_gt_params_file,'-mat');

vol_comp = [roi_comp_params.ROIparameters.params3d(comp_rois_with_some_mask).Volume];
vol_gt = [roi_gt_params.ROIparameters.params3d(:).Volume];

[dummy,volorder_comp] = sort(vol_comp);
[dummy,volorder_gt] = sort(vol_gt);

