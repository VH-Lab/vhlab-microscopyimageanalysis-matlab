function [stats] = at_groundtruthcorrespondenceC(atd, maskregion_rois, computerA_rois, groundtruthA_rois, computerB_rois, groundtruthB_rois, varargin)
% AT_GROUNDTRUTHCORRESPONDENCE 
%
% STATS = AT_GROUNDTRUTHCORRESPONDENCEC(ATD, MASKREGION_ROIS, COMPUTERA_ROIS, GROUNDTRUTHA_ROIS, COMPUTERB_ROIS, GROUNDTRUTHB_ROIS, ...)
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
% | thresholdinfo                  | Threshold estimation info              |
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
% function [stats] = at_groundtruthcorrespondenceC(atd, markregion_rois, computerA_rois, groundtruthA_rois, computerB_rois, groundtruthB_rois, varargin)
%    computerA_rois = 'PSD_DECsv9_roiresbf';
%    groundtruthA_rois = 'PSD_ROI_KC_ROIres';
%    maskregion_rois = 'spine_ROI_DLW_ROI';
%    computerB_rois = 'VG_DECsv9_roiresbf';
%    groundtruthB_rois = 'VG_ROI_KC_ROIres';
%    stats = at_groundtruthcorrespondenceC(atd, maskregion_rois, computerA_rois, groundtruthA_rois, computerB_rois, groundtruthB_rois);
%    % edit this
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
synaptic_overlap_threshold = 0.00001;

vlt.data.assign(varargin{:});

cla_list = getitems(atd, 'CLAs');

cla_compA_mask_fname = getcolocalizationfilename(atd, [maskregion_rois '_x_' computerA_rois '_CLA']);
if isempty(cla_compA_mask_fname),
	error(['No colocalization analysis ' [maskregion_rois '_x_' computerA_rois '_CLA'] ' found. It needs to be computed before running this function.']);
end;

cla_gt_compA_fname = getcolocalizationfilename(atd, [groundtruthA_rois '_x_' computerA_rois '_CLA']);
if isempty(cla_gt_compA_fname),
	error(['No colocalization analysis ' [groundtruthA_rois '_x_' computerA_rois '_CLA'] ' found. It needs to be computed before running this function.']);
end;

cla_gtA_mask_fname = getcolocalizationfilename(atd, [maskregion_rois '_x_' groundtruthA_rois '_CLA']);
if isempty(cla_gtA_mask_fname),
	error(['No colocalization analysis ' [maskregion_rois '_x_' groundtruthA_rois '_CLA'] ' found. It needs to be computed before running this function.']);
end;

cla_compB_mask_fname = getcolocalizationfilename(atd, [maskregion_rois '_x_' computerB_rois '_CLA']);
if isempty(cla_compB_mask_fname),
	error(['No colocalization analysis ' [maskregion_rois '_x_' computerB_rois '_CLA'] ' found. It needs to be computed before running this function.']);
end;
cla_compB_gt_fname = getcolocalizationfilename(atd, [groundtruthB_rois '_x_' computerB_rois '_CLA']);
if isempty(cla_compB_gt_fname),
	error(['No colocalization analysis ' [groundtruthA_rois '_x_' computerB_rois '_CLA'] ' found. It needs to be computed before running this function.']);
end;

cla_groundtruth_fname = getcolocalizationfilename(atd, [groundtruthA_rois '_x_' groundtruthB_rois ]);
if isempty(cla_groundtruth_fname),
	error(['No colocalization analysis ' [groundtruthA_rois '_x_' groundtruthB_rois ] ' found. It needs to be computed before running this function.']);
end;

cla_computerAB_fname = getcolocalizationfilename(atd, [computerA_rois '_X_' computerB_rois]);
if isempty(cla_computerAB_fname),
	error(['No colocalization analysis ' [computerA_rois '_X_' computerB_rois] ' found. It needs to be computed before running this function.']);
end;

hist = gethistory(atd,'ROIs',computerA_rois);

thresholdsA = [];
if ~isempty(hist),

	doublethreshnameA = hist(2).parent;
	hh = gethistory(atd,'images',doublethreshnameA);
	thresholdinfoA = hh(end).parameters.thresholdinfo;

	if isfield(hist(1).parameters,'threshold1'),
		thresholdsA(end+1) = hist(1).parameters.threshold1;
	end;
	if isfield(hist(1).parameters,'threshold2'),
		thresholdsA(end+1) = hist(1).parameters.threshold2;
	end;
end;

hist = gethistory(atd,'ROIs',computerB_rois);

thresholdsB = [];
if ~isempty(hist),

	doublethreshnameB = hist(2).parent;
	hh = gethistory(atd,'images',doublethreshnameB);
	thresholdinfoB = hh(end).parameters.thresholdinfo;

	if isfield(hist(1).parameters,'threshold1'),
		thresholdsB(end+1) = hist(1).parameters.threshold1;
	end;
	if isfield(hist(1).parameters,'threshold2'),
		thresholdsB(end+1) = hist(1).parameters.threshold2;
	end;
end;


cla_compA_mask = load(cla_compA_mask_fname,'-mat');
cla_gt_compA = load(cla_gt_compA_fname,'-mat');

cla_compB_mask = load(cla_compB_mask_fname,'-mat');
cla_compB_gt = load(cla_compB_gt_fname,'-mat');
cla_groundtruthAB = load(cla_groundtruth_fname,'-mat');
cla_groundtruthA_mask = load(cla_gtA_mask_fname,'-mat');
cla_compAB = load(cla_computerAB_fname,'-mat');


 % thinking:
 % true positives:
 %    Step 1:
 %    To be considered as a groundtruth positive, a groundtruthA ROI must
 %    1) be colocalized with a groundtruthB ROI (synaptic colocalization)
 %    2) must have some overlap with the mask region
 %    Step 2:
 %    A groundtruth positive is considered detected if there exists a compA ROI that
 %    1) is colocalized with a compB ROI
 %    2) overlaps the groundtruthA roi by amount THRESHOLD (fraction 0..1)  (compA onto groundtruthA)
 %
 % false positives:
 %    To be considered as a false positive, a compA ROI must
 %    1) overlap the mask region substantially (it had a chance to be marked by the human observer)
 %    2) be colocalized with a compB ROI
 %    3) the compB ROI has to be substantially in the viewing region
 %    4) NOT exhibit any overlap with any groundtruthA ROI that is colocalized with groundtruthB ROI
 %
 % now the code:
 % TRUE POSITIVES
 % step 1: groundtruthA ROI must
 %    1) be colocalized with a groundtruthB ROI (synaptic colocalization)
groundtruthA_colocalized = [full(sum(cla_groundtruthAB.colocalization_data.overlap_ab>synaptic_overlap_threshold,2))]>0;
 %    2) must have some overlap with the mask region
groundtruthA_somemaskoverlap = [ full(sum(cla_groundtruthA_mask.colocalization_data.overlap_ba>overlap_threshold_mask,2))] >0;

groundtruthA_toconsider_indexes = intersect(find(groundtruthA_colocalized),find(groundtruthA_somemaskoverlap));

 % true positives step 2:groundtruth positive is considered detected if there exists a compA ROI that
 %    1) is colocalized with a compB ROI
 %    2) overlaps the groundtruthA roi by amount THRESHOLD (fraction 0..1)  (compA onto groundtruthA)
compAB_colocalized = [full(sum(cla_compAB.colocalization_data.overlap_ab>synaptic_overlap_threshold,2))]>0;
compAB_colocalized_indexes = find(compAB_colocalized);

N_gt_detected_thresholds = 10;
os = linspace(0,0.9,N_gt_detected_thresholds);
gt_detected = zeros(1,N_gt_detected_thresholds);
gt_possible = numel(groundtruthA_toconsider_indexes);
gt_hit = {};
gt_miss = {};
true_positive_rate = zeros(1,N_gt_detected_thresholds);

disp(['Size of cla_gt_compA (gt x compA): ' int2str(size(cla_gt_compA.colocalization_data.overlap_ab)) '.']);
disp(['Size of cla_compA_compB (compA x compB): ' int2str(size(cla_compAB.colocalization_data.overlap_ab)) '.']);


for i=1:numel(os),
	THRESHOLD = os(i);
	compA_groundtruthA_colocalized = [full(sum(cla_gt_compA.colocalization_data.overlap_ab(groundtruthA_toconsider_indexes,compAB_colocalized_indexes)>=THRESHOLD,2))]>0;
	gt_detected(i) = sum(compA_groundtruthA_colocalized);
	gt_hit{i} = groundtruthA_toconsider_indexes(find(compA_groundtruthA_colocalized));
	gt_miss{i} = groundtruthA_toconsider_indexes(find(compA_groundtruthA_colocalized==0));
	true_positive_rate(i) = gt_detected(i)/gt_possible;
end;


 % now FALSE POSITIVES
 %    To be considered as a false positive, a compA ROI must
 %    1) overlap the mask region substantially (it had a chance to be marked by the human observer)
 %    2) be colocalized with a compB ROI
 %    3) the compB ROI has to be substantially in the viewing region
 %    4) NOT exhibit any overlap with any groundtruthA ROI that is colocalized with groundtruthB ROI
 %    To determine the false positive RATE, we consider the number of the total false positives
 %    out of all colocalized compA ROIs that are substantially in the mask region

% which ROIs detected by the computer are substantially in the masked region?
[compA_rois_substantially_in_mask,J] = find(cla_compA_mask.colocalization_data.overlap_ba>=overlap_threshold_substantially_in_mask);
[compB_rois_substantially_in_mask,J] = find(cla_compB_mask.colocalization_data.overlap_ba>=overlap_threshold_substantially_in_mask);

compAB_colocalized_Binmask = [full(sum(cla_compAB.colocalization_data.overlap_ab(:,compB_rois_substantially_in_mask)>synaptic_overlap_threshold,2))]>0;
compAB_colocalized_Binmask_indexes = find(compAB_colocalized_Binmask);

compA_potential_false_positives = intersect(compA_rois_substantially_in_mask,compAB_colocalized_indexes);

compA_false_positives_count = zeros(1,N_gt_detected_thresholds);
compA_false_positives_rate = zeros(1,N_gt_detected_thresholds);
false_positives_not = {};
false_positives_are = {};

for i=1:numel(os),
	THRESHOLD = os(i);
	compA_false_positives = [full(sum(cla_gt_compA.colocalization_data.overlap_ba(compA_potential_false_positives,:)>=THRESHOLD,2))]==0;
	compA_false_positives_count(i) = sum(compA_false_positives);
	false_positives_not{i} = compA_potential_false_positives(find(compA_false_positives==0));
	false_positives_are{i} = compA_potential_false_positives(find(compA_false_positives));
	compA_false_positives_rate(i) = compA_false_positives_count(i) / numel(compA_potential_false_positives);
end;


stats = vlt.data.var2struct('false_positives_not','false_positives_are','compA_false_positives_rate','compA_false_positives_count','compA_potential_false_positives',...
	'gt_detected','gt_possible','gt_hit','gt_miss','true_positive_rate','os','N_gt_detected_thresholds');

return;


 % garbage from previous version that only looked at puncta

% which ROIs detected by the computer substantially overlap the groundtruth ROIs?

N_comp_rois = numel(comp_rois_with_some_mask);
N_groundtruth_rois = size(cla_comp_gt.colocalization_data.overlap_ab,1);
N_comp_rois_substantial = numel(comp_rois_substantially_in_mask);

N_overlaps_comp_onto_gt = zeros(N_comp_rois,N_overlap_comp_onto_gt_thresholds);
N_overlaps_gt_onto_comp = zeros(N_groundtruth_rois,N_overlap_comp_onto_gt_thresholds);
N_overlaps_comp_substantial_onto_gt = zeros(N_comp_rois_substantial,N_overlap_comp_onto_gt_thresholds);


for i=1:length(os),
	N_overlaps_comp_onto_gt(:,i) = [ full(sum(cla_comp_gt.colocalization_data.overlap_ba(comp_rois_with_some_mask,:)>os(i),2)) ];
	N_overlaps_gt_onto_comp(:,i) = [ full(sum(cla_comp_gt.colocalization_data.overlap_ab(:,comp_rois_with_some_mask)>os(i),2)) ]';
	N_overlaps_comp_substantial_onto_gt(:,i) = [ full(sum(cla_comp_gt.colocalization_data.overlap_ba(comp_rois_substantially_in_mask,:)>os(i),2)) ];
end;

roi_compA_params_file = getroiparametersfilename(atd,cla_compA_gt.colocalization_data.parameters.roi_set_2);
roi_gtA_params_file = getroiparametersfilename(atd,cla_compA_gt.colocalization_data.parameters.roi_set_1);

%roi_compA_params = load(roi_compA_params_file,'-mat');
%roi_gtA_params = load(roi_gtA_params_file,'-mat');

vol_comp = [roi_comp_params.ROIparameters.params3d(comp_rois_with_some_mask).Volume];
vol_gt = [roi_gt_params.ROIparameters.params3d(:).Volume];
vol_comp_substantial = [roi_comp_params.ROIparameters.params3d(comp_rois_substantially_in_mask).Volume];

maxbright_comp = [roi_comp_params.ROIparameters.params3d(comp_rois_with_some_mask).MaxIntensity];
maxbright_gt = [roi_gt_params.ROIparameters.params3d(:).MaxIntensity];
maxbright_comp_substantial = [roi_comp_params.ROIparameters.params3d(comp_rois_substantially_in_mask).MaxIntensity];

full_parameters_gt = roi_gt_params_file;
full_parameters_comp = roi_comp_params_file;

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


 % non-resegmented ROIs
nonres_roi_gt_params_file = getroiparametersfilename(atd,cla_comp_gt.colocalization_data.parameters.roi_set_1(1:end-3));
nonres_roi_gt_params = load(nonres_roi_gt_params_file,'-mat');
nonres_vol_gt = [nonres_roi_gt_params.ROIparameters.params3d(:).Volume];
nonres_maxbright_gt = [nonres_roi_gt_params.ROIparameters.params3d(:).MaxIntensity];

stats = vlt.data.var2struct('N_overlaps_comp_onto_gt','N_overlaps_gt_onto_comp','N_overlaps_comp_substantial_onto_gt',...
	'vol_gt', 'volorder_gt','vol_comp_substantial','volorder_comp_substantial','vol_comp','volorder_comp',...
	'true_positives','false_positives','gt_positives','comp_positives','maxbright_comp','maxbright_gt','maxbright_comp_substantial',...
	'thresholds','thresholdinfo','nonres_vol_gt','nonres_maxbright_gt',...
	'full_parameters_gt','full_parameters_comp', ...
	'comp_rois_with_some_mask','comp_rois_substantially_in_mask',...
	'nonres_roi_gt_params','cla_comp_gt','cla_comp_mask');
