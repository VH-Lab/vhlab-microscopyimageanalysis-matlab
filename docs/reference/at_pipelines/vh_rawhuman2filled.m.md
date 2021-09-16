# vh_rawhuman2filled

```
  VH_RAWHUMAN2FILLED - 
 
  VH_RAWHUMAN2FILLED(ATD, STARTIMAGENAME, MASKIMAGENAME, OUTNAME, ...)
  
  Runs a sub pipeline (VH version 1) pipeline on an image with STARTIMAGENAME in the
  AT_DIR object ATD.
  Assumes that the image is already scaled (Step 0).
  For Step 1:
     the image is examined by AT_ESTIMATETHRESHOLDS.
     A new image called [outname '_th2mask'] is created with at_image_doublethreshold
  Step 2: ROIs are made [outname '_roi']
  Step 3, Watershed is applied
  Step 4: Volume filter (use 0, Inf to do nothing)
 
   The output will be named [outname '_*'].
  
  Several parameters can be altered by name/value pairs (see help NAMEVALUEPAIR).
  Parameter (default)       | Description
  --------------------------------------------------------------------
  plotthresholdestimate (0) | Should we plot the threshold estimate?
  connectivity (26)         | Connectivity for ROIs
  volume_filter_low (0)     | Low setting for volume filter
  volume_filter_high (Inf)  | High setting for volume filter
  t_levels ([80 30])        | Threshold levels for autothresholder
  delete_old_output (1)     | Delete any old output before we start
                            |  (uses AT_CLEAN_PIPELINE)
 
  Example:
     atd = at_dir([MYEXPERIMENTPATH]);
     vh_pipepiece1(atd, 'PSD', 'PSDsv1');

```
