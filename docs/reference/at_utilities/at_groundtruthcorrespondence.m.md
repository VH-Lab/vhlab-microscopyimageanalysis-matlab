# at_groundtruthcorrespondence

```
  AT_GROUNDTRUTHCORRESPONDENCE 
 
  STATS = AT_GROUNDTRUTHCORRESPONDENCE(ATD, COMPUTER_ROIS, MASKREGION_ROIS, GROUNDTRUTH_ROIS, ...)
 
  Given an array tomography directory object (ATDIR object) ATD and the names of ROIs that were
  generated by the computer (COMPUTER_ROIS), a mask region (such as a spine mask) MASKREGION_ROIS,
  and the ROIs that correspond to some ground truth measurement (GROUNDTRUTH_ROIS), this function
  calculates overlap.
 
  It is assumed that the ground truth ROIs only exist within the mask and not in other regions.
 
 
  Returns several statistics in STATS, a structure:
  --------------------------------------------------------------------------|
  | Fieldname                      | Description                            |
  | -----------------------------------------------|------------------------|
  | N_overlaps_comp_onto_gt        | Number of ROIs defined by the computer |
  |                                |   that have some overlap with          |
  |                                |   the ground truth. This calculation is|
  |                                |   performed for the subset of computer |
  |                                |   ROIs that have at least a little     |
  |                                |   overlap with the mask.  (Checking for|
  |                                |   true positives.)                     |
  |                                |   Each column provides this            |
  |                                |   value for overlap (comp onto gt)     |
  |                                |   thresholds of 0.1, 0.2, ..., 0.9.    |
  | N_overlaps_gt_onto_comp        | Number of ground truth ROIs that have  |
  |                                |   some overlap with the computer ROIs  |
  |                                |   that have some overlap with the mask.|
  |                                |   Each column provides this            |
  |                                |   value for overlap (gt onto comp)     |
  |                                |   thresholds of 0.1, 0.2, ..., 0.9.    |
  | N_overlaps_comp_substantial... | Number of ROIs defined by the computer |
  |    onto_gt                     |   that have some overlap with          |
  |                                |   the ground truth. This calculation is|
  |                                |   performed for the subset of computer |
  |                                |   ROIs that have a substantial         |
  |                                |   overlap with the mask. (Checking for |
  |                                |     false positives.)                  |
  |                                |   Each column provides this            |
  |                                |   value for overlap (comp onto gt)     |
  |                                |   thresholds of 0.1, 0.2, ..., 0.9.    |
  | vol_gt                         | The volume of each ground truth ROI    |
  | volorder_gt                    | The sort order of vol_gt               |
  | vol_comp                       | The volume of computer ROIs that have  |
  |                                |   some minimal overlap with mask.      |
  | volorder_comp                  | The sort order of vol_comp             |
  | vol_comp_substantial           | The volume of computer ROIs that have  |
  |                                |   substantial overlap with mask.       |
  | volorder_comp_substantial      | The sort order of vol_comp_substantial |
  | maxbright_gt                   | Maximum brightness of each GT ROI      |
  | maxbright_comp                 | Max brightness of computer ROIs that   |
  |                                |   have some minimal overlap with mask  |
  | maxbright_comp_substantial     | Max brightness of computer ROIs that   |
  |                                |   have substantial overlap with mask   |
  | thresholds                     | Thresholds used for comp ROIs          |
  | thresholdinfo                  | Threshold estimation info              |
  ---------------------------------------------------------------------------
  
 
  This function's behavior can be modified by passing name/value pairs:
  --------------------------------------------------------------------------|
  | Parameter (default)                            | Description            |
  | -----------------------------------------------|------------------------|
  | overlap_threshold_mask (0)                     |  How much should the   |
  |                                                |   computer ROIs overlap|
  |                                                |   the mask region in   |
  |                                                |   order to be counted? |
  |                                                |  (Fraction, strictly   |
  |                                                |    greater than)       |
  | overlap_threshold_substantially_in_mask (0.5)  | How much should the    |
  |                                                |   computer ROIs overlap|
  |                                                |   the mask region to be|
  |                                                |   examined for false   |
  |                                                |   positives?           |
  ---------------------------------------------------------------------------
 
  Example:
     stats = at_groundtruthcorrespondence(atd,computer_rois,maskregion_rois,groundtruth_rois);
     figure;
     subplot(2,1,1);
     plot(stats.vol_gt,stats.N_overlaps_gt_onto_comp(stats.volorder_gt,4),'o'); % threshold: 4 = 30%
     xlabel('Volume of ground truth ROIs');
     ylabel('Number of computer-identified ROIs that match the ground-truth ROIs');
     title(['How many ground truth ROIs have matches in the computer-identified ROIs? (1s are true positives.)']);
     subplot(2,1,2);
     plot(stats.vol_comp_substantial,stats.N_overlaps_comp_substantial_onto_gt(stats.volorder_comp_substantial,2),'o'); % threshold: 2= 10%
     xlabel('Volume of computer-identified ROIs that overlap the mask substantially');
     ylabel('Number of ground-truth ROIs that match the computer-identified ROIs');
     title(['How many computer-identified ROIs are valid? (0s are false positives.)']);
     disp(['Estimated true positive rate: ' num2str(stats.true_positives(4)/stats.gt_positives) ]);
     disp(['Upper bound estimate of false positive rate: ' num2str(stats.false_positives(2)/stats.comp_positives) ]);

```