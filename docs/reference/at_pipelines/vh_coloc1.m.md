# vh_coloc1

```
  VH_COLOC1 - Steve's first colocalization pipeline piece / Nelson lab - Van Hooser lab
 
  VH_COLOC1(ATD, STARTIMAGENAME, OUTNAME, ...)
  
  Runs a sub pipeline (VH colocalization version 1) pipeline on ROIs A with name
  ROISETA and ROIs B with name ROISETB and generate a co-localization called OUTNAME.
  Operators on AT_DIR object ATD.
 
  Assumes that the image is already scaled (Step 0).
 
   The output will be named [outname '_*'].
  
  Several parameters can be altered by name/value pairs (see help NAMEVALUEPAIR).
  Parameter (default)       | Description
  --------------------------------------------------------------------
  overlap_threshold (0.01)  | Overlap threshold for colocalization
  xyshift ([-2 : 2])        | Colocalization shifts to examine in X/Y
  zshift ([0])              | Colocalization shifts to examine in Z
  delete_old_output (1)     | Delete any old output before we start
                            |  (uses AT_CLEAN_PIPELINE)
 
  Example:
     atd = at_dir([MYEXPERIMENTPATH]);
     vh_coloc1(atd, 'PSD', 'PSDsv1');

```
