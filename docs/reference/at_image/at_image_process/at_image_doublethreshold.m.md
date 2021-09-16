# at_image_doublethreshold

```
  AT_IMAGE_DOUBLETHRESHOLD - Threshold an image and store results
   
   OUT = AT_IMAGE_DOUBLETHRESHOLD(ATD, INPUT_ITEMNAME, OUTPUT_ITEMNAME, PARAMETERS)
 
   If the function is called with no arguments, then a description of the
   parameters is returned in OUT. OUT{1}{n} is the name of the nth parameter, and
   OUT{2}{n} is a human-readable description of the parameter.
   OUT{3} is a list of methods for user-guided selection of these parameters.
 
   AT_IMAGE_DOUBLETHRESHOLD has several parameters:
   | Parameter (default)                | Description                           |
   |------------------------------------|---------------------------------------|
   | threshold1 (95)                    | Value of threshold1                   |
   | threshold2 (75)                    | Value of threshold2                   |
   | threshold_units ('percentile')     | Unit of threshold (can be 'raw' or    |
   |                                    |    'percentile'                       |
   | connectivity (26)                  | Connectivity for ROI finding          |

```
