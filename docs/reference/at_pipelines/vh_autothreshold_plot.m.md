# vh_autothreshold_plot

```
  VH_AUTOTHRESHOLD_PLOT - Steve's first pipeline piece / Nelson lab - Van Hooser lab
 
  VH_AUTOTHRESHOLD_PLOT(ATD, STARTIMAGENAME, ...)
 
  Plots the results of autothresholding in the current axes.
   
  Several parameters can be altered by name/value pairs (see help NAMEVALUEPAIR).
  Parameter (default)       | Description
  --------------------------------------------------------------------
  connectivity (26)         | Connectivity for ROIs
  t_levels ([80 30])        | Threshold levels for at_estimatethreshold
 
  Example:
     atd = at_dir([MYEXPERIMENTPATH]);
     vh_auththreshold_plot(atd, 'PSD');

```
