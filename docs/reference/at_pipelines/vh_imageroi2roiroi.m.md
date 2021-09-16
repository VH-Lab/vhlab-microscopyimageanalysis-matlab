# vh_imageroi2roiroi

```
  VH_IMAGEROI2ROIROI - Convert ROIs that have been placed in image files into actual AT ROIs
 
  VH_IMAGEROI2ROIROI(ATD, ...)
  
  Runs a pipeline (VH version 1) that looks for image files that define ROIs on the
  AT_DIR object ATD.
 
  It examines all image files that have the name SOMETHING_ROI_SOMETHING and
  makes ROIs that have the same name.
  
   The output will be named [outname '_*'].
  
  Several parameters can be altered by name/value pairs (see help NAMEVALUEPAIR).
  Parameter (default)       | Description
  --------------------------------------------------------------------
  connectivity (26)         | Connectivity for ROIs
  do_resegemnt (1)          | Resegment the ROIs that come through
 
  Example:
     atd = at_dir([MYEXPERIMENTPATH]);
     vh_imageroi2roiroi(atd);

```
