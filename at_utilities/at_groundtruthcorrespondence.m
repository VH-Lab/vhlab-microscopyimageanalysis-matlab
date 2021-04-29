function [stats] = at_groundtruthcorrespondence(atd, computer_rois, maskregion_rois, groundtruth_rois, varargin)
% AT_GROUNDTRUTHCORRESPONDENCE 
%
% STATS = AT_GROUNDTRUTHCORRESPONDENCE(ATD, COMPUTER_ROIS, MASKREGION_ROIS, GROUNDTRUTH_ROIS, ...)
%
% Given an array tomography directory object (ATDIR object) ATD and the names of ROIs that were
% generated by the computer (COMPUTER_ROIS), a mask region (such as a spine mask) MASKREGION_ROIS,
% and the ROIs that correspond to some ground truth measurement (GROUNDTRUTH_ROIS), this function
% calculates overlap.
%
% It is assumed that the ground truth ROIs only exist within the mask and not in other regions.
%
%
% Returns several statistics in STATS, a structure:
% --------------------------------------------------------------------------|
% | Fieldname                      | Description                            |
% | -----------------------------------------------|------------------------|
% | N_overlaps_comp_onto_gt        | Number of ROIs defined by the computer |
% |                                |   that have some overlap with          |
% |                                |   the ground truth. This calculation is|
% |                                |   performed for the subset of computer |
% |                                |   ROIs that have at least a little     |
% |                                |   overlap with the mask.  (Checking for|
% |                                |   true positives.)                     |
% |                                |   Each column provides this            |
% |                                |   value for overlap (comp onto gt)     |
% |                                |   thresholds of 0.1, 0.2, ..., 0.9.    |
% | N_overlaps_gt_onto_comp        | Number of ground truth ROIs that have  |
% |                                |   some overlap with the computer ROIs  |
% |                                |   that have some overlap with the mask.|
% |                                |   Each column provides this            |
% |                                |   value for overlap (gt onto comp)     |
% |                                |   thresholds of 0.1, 0.2, ..., 0.9.    |
% | N_overlaps_comp_substantial... | Number of ROIs defined by the computer |
% |    onto_gt                     |   that have some overlap with          |
% |                                |   the ground truth. This calculation is|
% |                                |   performed for the subset of computer |
% |                                |   ROIs that have a substantial         |
% |                                |   overlap with the mask. (Checking for |
% |                                |     false positives.)                  |
% |                                |   Each column provides this            |
% |                                |   value for overlap (comp onto gt)     |
% |                                |   thresholds of 0.1, 0.2, ..., 0.9.    |
% | vol_gt                         | The volume of each ground truth ROI    |
% | volorder_gt                    | The sort order of vol_gt               |
% | vol_comp                       | The volume of computer ROIs that have  |
% |                                |   some minimal overlap with mask.      |
% | volorder_comp                  | The sort order of vol_comp             |
% | vol_comp_substantial           | The volume of computer ROIs that have  |
% |                                |   substantial overlap with mask.       |
% | volorder_comp_substantial      | The sort order of vol_comp_substantial |
% | maxbright_gt                   | Maximum brightness of each GT ROI      |
% | maxbright_comp                 | Max brightness of computer ROIs that   |
% |                                |   have some minimal overlap with mask  |
% | maxbright_comp_substantial     | Max brightness of computer ROIs that   |
% |                                |   have substantial overlap with mask   |
% | thresholds                     | Thresholds used for comp ROIs          |
% ---------------------------------------------------------------------------
% 
%
% This function's behavior can be modified by passing name/value pairs:
% --------------------------------------------------------------------------|
% | Parameter (default)                            | Description            |
% | -----------------------------------------------|------------------------|
% | overlap_threshold_mask (0)                     |  How much should the   |
% |                                                |   computer ROIs overlap|
% |                                                |   the mask region in   |
% |                                                |   order to be counted? |
% |                                                |  (Fraction, strictly   |
% |                                                |    greater than)       |
% | overlap_threshold_substantially_in_mask (0.5)  | How much should the    |
% |                                                |   computer ROIs overlap|
% |                                                |   the mask region to be|
% |                                                |   examined for false   |
% |                                                |   positives?           |
% ---------------------------------------------------------------------------
%
% Example:
%    stats = at_groundtruthcorrespondence(atd,computer_rois,maskregion_rois,groundtruth_rois);
%    figure;
%    subplot(2,1,1);
%    plot(stats.vol_gt,stats.N_overlaps_gt_onto_comp(stats.volorder_gt,4),'o'); % threshold: 4 = 30%
%    xlabel('Volume of ground truth ROIs');
%    ylabel('Number of computer-identified ROIs that match the ground-truth ROIs');
%    title(['How many ground truth ROIs have matches in the computer-identified ROIs? (1s are true positives.)']);
%    subplot(2,1,2);
%    plot(stats.vol_comp_substantial,stats.N_overlaps_comp_substantial_onto_gt(stats.volorder_comp_substantial,2),'o'); % threshold: 2= 10%
%    xlabel('Volume of computer-identified ROIs that overlap the mask substantially');
%    ylabel('Number of ground-truth ROIs that match the computer-identified ROIs');
%    title(['How many computer-identified ROIs are valid? (0s are false positives.)']);
%    disp(['Estimated true positive rate: ' num2str(stats.true_positives(4)/stats.gt_positives) ]);
%    disp(['Upper bound estimate of false positive rate: ' num2str(stats.false_positives(2)/stats.comp_positives) ]);
%    
%    

overlap_threshold_mask = 0.0;
overlap_threshold_substantially_in_mask = 0.75; 

vlt.data.assign(varargin{:});

cla_list = getitems(atd, 'CLAs');

cla_comp_mask_fname = getcolocalizationfilename(atd, [maskregion_rois '_x_' computer_rois '_CLA']);
if isempty(cla_comp_mask_fname),
	error(['No colocalization analysis ' [maskregion_rois '_x_' computer_rois '_CLA'] ' found. It needs to be computed before running this function.']);
end;
cla_comp_gt_fname = getcolocalizationfilename(atd, [groundtruth_rois '_x_' computer_rois '_CLA']);
if isempty(cla_comp_gt_fname),
	error(['No colocalization analysis ' [groundtruth_rois '_x_' computer_rois '_CLA'] ' found. It needs to be computed before running this function.']);
end;

hist = gethistory(atd,'ROIs',computer_rois);
thresholds = [];
if ~isempty(hist),
	if isfield(hist(1).parameters,'threshold1'),
		thresholds(end+1) = hist(1).parameters.threshold1;
	end;
	if isfield(hist(1).parameters,'threshold2'),
		thresholds(end+1) = hist(1).parameters.threshold2;
	end;
end;

cla_comp_mask = load(cla_comp_mask_fname,'-mat');
cla_comp_gt = load(cla_comp_gt_fname,'-mat');

% which ROIs detected by the computer have some overlap with the masked region?
[comp_rois_with_some_mask,J] = find(cla_comp_mask.colocalization_data.overlap_ba>overlap_threshold_mask);
% which ROIs detected by the computer are substantially in the masked region?
[comp_rois_substantially_in_mask,J] = find(cla_comp_mask.colocalization_data.overlap_ba>=0.5);

% which ROIs detected by the computer substantially overlap the groundtruth ROIs?

N_overlap_comp_onto_gt_thresholds = 10;
N_comp_rois = numel(comp_rois_with_some_mask);
N_groundtruth_rois = size(cla_comp_gt.colocalization_data.overlap_ab,1);
N_comp_rois_substantial = numel(comp_rois_substantially_in_mask);

N_overlaps_comp_onto_gt = zeros(N_comp_rois,N_overlap_comp_onto_gt_thresholds);
N_overlaps_gt_onto_comp = zeros(N_groundtruth_rois,N_overlap_comp_onto_gt_thresholds);
N_overlaps_comp_substantial_onto_gt = zeros(N_comp_rois_substantial,N_overlap_comp_onto_gt_thresholds);

os = linspace(0,0.9,N_overlap_comp_onto_gt_thresholds);

for i=1:length(os),
	N_overlaps_comp_onto_gt(:,i) = [ full(sum(cla_comp_gt.colocalization_data.overlap_ba(comp_rois_with_some_mask,:)>os(i),2)) ];
	N_overlaps_gt_onto_comp(:,i) = [ full(sum(cla_comp_gt.colocalization_data.overlap_ab(:,comp_rois_with_some_mask)>os(i),2)) ]';
	N_overlaps_comp_substantial_onto_gt(:,i) = [ full(sum(cla_comp_gt.colocalization_data.overlap_ba(comp_rois_substantially_in_mask,:)>os(i),2)) ];
end;

roi_comp_params_file = getroiparametersfilename(atd,cla_comp_gt.colocalization_data.parameters.roi_set_2);
roi_gt_params_file = getroiparametersfilename(atd,cla_comp_gt.colocalization_data.parameters.roi_set_1);

roi_comp_params = load(roi_comp_params_file,'-mat');
roi_gt_params = load(roi_gt_params_file,'-mat');

vol_comp = [roi_comp_params.ROIparameters.params3d(comp_rois_with_some_mask).Volume];
vol_gt = [roi_gt_params.ROIparameters.params3d(:).Volume];
vol_comp_substantial = [roi_comp_params.ROIparameters.params3d(comp_rois_substantially_in_mask).Volume];

maxbright_comp = [roi_comp_params.ROIparameters.params3d(comp_rois_with_some_mask).MaxIntensity];
maxbright_gt = [roi_gt_params.ROIparameters.params3d(:).MaxIntensity];
maxbright_comp_substantial = [roi_comp_params.ROIparameters.params3d(comp_rois_substantially_in_mask).MaxIntensity];


[dummy,volorder_comp] = sort(vol_comp);
[dummy,volorder_comp_substantial] = sort(vol_comp_substantial);
[dummy,volorder_gt] = sort(vol_gt);

%This is an interesting thing to analyze: this is related to the probability that a ground truth object is actually detected
%[volorder_gt(:) vol_gt(volorder_gt)' N_overlaps_gt_onto_comp(volorder_gt,:)]

% This is an interesting thing to analyze; this is related to the probability that a computer-detected object is a false positive
%[comp_rois_substantially_in_mask(volorder_comp_substantial(:)) vol_comp_substantial(volorder_comp_substantial)' N_overlaps_comp_substantial_onto_gt(volorder_comp_substantial,:)]

gt_positives = N_groundtruth_rois;
true_positives = sum(N_overlaps_gt_onto_comp > 0);

comp_positives = N_comp_rois_substantial;
false_positives = sum(N_overlaps_comp_substantial_onto_gt == 0);

stats = vlt.data.var2struct('N_overlaps_comp_onto_gt','N_overlaps_gt_onto_comp','N_overlaps_comp_substantial_onto_gt',...
	'vol_gt', 'volorder_gt','vol_comp_substantial','volorder_comp_substantial','vol_comp','volorder_comp',...
	'true_positives','false_positives','gt_positives','comp_positives','maxbright_comp','maxbright_gt','maxbright_comp_substantial',...
	'thresholds');
