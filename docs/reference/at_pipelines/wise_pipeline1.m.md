# wise_pipeline1

```
  WISE_PIPELINE1 - Derek Wise pipeline 1 / Nelson lab - Van Hooser lab
 
  WISE_PIPELINE1(ATD, STARTIMAGENAME, OUTNAME, ...)
  
  Runs the Wise (version 1) pipeline on an image with STARTIMAGENAME in the
  AT_DIR object ATD.
  For Step 1, scaling is applied (not implemented yet).
  For Step 2, a threshold is applied.
  For Step 3, make the ROIs.
  For Step 4, apply a volume filter (use 0, Inf to do nothing)
  For Step 5, apply the watershed resegmentation 
   The output will be named [startImageName '_' outname '_wp1_roivfres'].
 
  
  Several parameters can be altered by name/value pairs (see help NAMEVALUEPAIR).
  Parameter (default)       | Description
  --------------------------------------------------------------------
  threshold (1250)          | Threshold for pixel detection
  connectivity (26)         | Connectivity for ROIs
  volume_filter_low (0)     | Low setting for volume filter
  volume_filter_high (Inf)  | High setting for volume filter
  
 
  Example:
     atd = at_dir([MYEXPERIMENTPATH]);
     wise_pipelin1(atd, 'PSD95chan', 'PSDwise1275', 'threshold', 1275);

```
