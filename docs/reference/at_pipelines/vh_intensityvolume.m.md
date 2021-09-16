# vh_intensityvolume

```
  VH_INTENSITYVOLUME - Steve's first colocalization pipeline piece / Nelson lab - Van Hooser lab
 
  VH_INTENSITYVOLUME(ATD, ROISETA, OUTNAME, ...)
  
  Runs a sub pipeline (Max Intensity and Volume Filter) on
  ROISETA and generates a new set of ROIs with name OUTNAME.
  Operates on AT_DIR object ATD.
 
   The output will be named [outname '_*'].
  
  Several parameters can be altered by name/value pairs (see help NAMEVALUEPAIR).
  Parameter (default)       | Description
  --------------------------------------------------------------------
  min_intensity_thresh (1)  | Which threshold of double threshold to use
  max_intensity_value (Inf) | Should we filter a maximum value?
  min_volume (4)            | Minimum volume allowed
  max_volume (Inf)          | Maximum volume allowed 
  delete_old_output (1)     | Delete any old output before we start
                            |  (uses AT_CLEAN_PIPELINE)
 
  Example:
     atd = at_dir([MYEXPERIMENTPATH]);
     vh_intensityvolume(atd, 'PSD', 'PSDsv1');

```
