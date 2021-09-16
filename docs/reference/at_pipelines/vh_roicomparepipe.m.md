# vh_roicomparepipe

```
  VH_ROICOMPAREPIPE - Convert ROIs that have been placed in image files into actual AT ROIs
 
  VH_ROICOMPAREPIPE(ATD, ...)
  
  Runs a pipeline (VH version 1) that looks for image files that define ROIs on the
  AT_DIR object ATD.
 
  It examines all image files that have the name SOMETHING_ROI_SOMETHING and
  makes ROIs that have the same name.
  
   The output will be named [outname '_*'].
  
  Several parameters can be altered by name/value pairs (see help NAMEVALUEPAIR).
  Parameter (default)       | Description
  --------------------------------------------------------------------
  overlap_threshold (0.01)  | Overlap threshold for colocalization
  xyshift ([0])        | Colocalization shifts to examine in X/Y
  zshift ([0])              | Colocalization shifts to examine in Z
  delete_old_output (1)     | Delete any old output before we start
                            |  (uses AT_CLEAN_PIPELINE)
 
  Example:
     atd = at_dir([MYEXPERIMENTPATH]);
     vh_roicomparepipe(atd,'PSD_ROI_','PSDsv1');

```
