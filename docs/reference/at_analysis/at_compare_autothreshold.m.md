# at_compare_autothreshold

```
  AT_COMPARE_AUTOTHRESHOLD - compare autothresholding performance for multiple experiments
  
  AT_COMPARE_AUTOTHRESHOLD(D, IMAGENAME)
 
  D is a cell array of directory names to examine, and IMAGENAME is the image
  to process with the autothreshold function. No results are saved except
  to the plot
 
  This function takes additional arguments as name/value pairs:
  Parameter (default)       | Description
  ------------------------------------------------------------------
  N (3)                     | Number of rows of plots in each figure
  M (2)                     | Number of columns of plots in each figure
  labelmethod ('IMNAME#')   | How to label the graphs. Methods include:
                            |  'IMNAME#': label with IMAGENAME and the exp #
  t_levels ([80 30])         | Threshold signal levels

```
