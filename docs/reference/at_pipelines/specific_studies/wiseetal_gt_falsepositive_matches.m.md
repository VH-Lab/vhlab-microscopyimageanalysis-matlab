# wiseetal_gt_falsepositive_matches

```
  WISEETAL_GT_FALSEPOSITIVE_MATCHES - calculate false positive matches
 
  [INDEXES, GOOD_GT] = WISEETAL_GT_FALSEPOSITIVE_MATCHES(GT_STRUCT)
 
  Given a ground-truth structure (such as that output by AT_GROUNDTRUTHCORRESPONDENCE)
  this function calculates the index of each computer-generated ROI that has the
  most overlap with each ground-truth ROIs. Ground-truth ROIs are filtered for those
  that are at least as bright as the highest first threshold.
 
  This function also takes name/value pairs that modify its behavior (see `help namevaluepair`):
  --------------------------------------------------_----------------------------------|
  | Parameter (default)             | Description                                      |
  |---------------------------------|--------------------------------------------------|
  | overlap_fraction_false_positive | The fraction that a computer-generated ROI must  |
  |   (0.01)                        | overlap a human-generated ROI mark to be a match |
  |---------------------------------|--------------------------------------------------|

```
