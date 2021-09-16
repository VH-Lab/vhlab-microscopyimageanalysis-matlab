# vh_groundtruthcompare

```
  VH_vh_groundtruthcompare - Convert ROIs that have been placed in image files into actual AT ROIs
 
  VH_vh_groundtruthcompare(ATD, computerroi, maskregion_rois, groundtruthprefix,  ...)
  
  Performs ground truth correspondence analysis for all available ground truth datasets.
  
  Several parameters can be altered by name/value pairs (see help NAMEVALUEPAIR).
  Parameter (default)       | Description
  --------------------------------------------------------------------
 
  Example:
     atd = at_dir([MYEXPERIMENTPATH]);
     vh_groundtruthcompare(atd,'PSD_DECsv1','spine_ROI_DLW)ROI','PSD_ROI_');

```
