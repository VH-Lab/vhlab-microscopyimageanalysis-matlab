# wiseetal_gt_truepositive_matches

```
  WISEETAL_GT_TRUEPOSITIVE_MATCHES - calculate true positive matches
 
  [INDEXES, GOOD_GT] = WISEETAL_GT_TRUEPOSITIVE_MATCHES(GT_STRUCT)
 
  Given a ground-truth structure (such as that output by AT_GROUNDTRUTHCORRESPONDENCE)
  this function calculates the index of each computer-generated ROI that has the 
  most overlap with each ground-truth ROIs. Ground-truth ROIs are filtered for those
  that are at least as bright as the highest first threshold.
 
  This function also takes name/value pairs that modify its behavior (see `help namevaluepair`):
  ------------------------------------------------------------------------------------|
  | Parameter (default)            | Description                                      |
  |--------------------------------|--------------------------------------------------|
  | overlap_fraction_true_positive | The fraction that a ground-truth ROI mark must   |
  |   (0.3)                        | overlap a computer-generated ROI to be a match   |
  |--------------------------------|--------------------------------------------------|

```
