# at_roi_filtercolocalization

```
  AT_ROI_FILTERCOLOCALIZATION - Filter ROIs by volume
  
   OUT = AT_ROI_FILTERCOLOCALIZATION(ATD, INPUT_ITEMNAME, OUTPUT_ITEMNAME, PARAMETERS)
 
   If the function is called with no arguments, then a description of the parameters
   is returned in OUT. OUT{1}{n} is the name of the nth parameter, and OUT{2}{n} is a
   human-readable description of the parameter. 
   OUT{3} is a list of methods for user-guided selection of these parameters.
 
   The PARAMETERS for this function can just be empty, there are no parameters. All ROIs are
   resegmented using ROI_RESEGMENT_ALL.

```
