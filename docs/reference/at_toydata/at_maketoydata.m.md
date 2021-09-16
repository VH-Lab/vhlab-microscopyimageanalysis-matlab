# at_maketoydata

```
  AT_MAKETOYDATA - make toy data for testing array tomography analysis
 
   AT_MAKETOYDATA(...)
   
   Makes a directory called 'at_toydata_example' in the present directory with an
   image with randomly generated dots. The "dots" are 3-dimensional Gaussian spots.
 
   The default behavior can be modified by passing name/value pairs:
   Parameter (default value)     | Description
   ------------------------------------------------------------------
   parentdir (pwd)               | The directory in which to create the 'at_toydata_example' directory
   dirname ('at_toydata_example')| The directory name
   imsize ([200 300 2])          | The size of the images to create for each channel
                                 |   in [X Y Z]
   dotsize ([2 3 2])             | The size of each dot ([x y z]); these are parameters of
                                 |   the 3-d covariance matrix
   numdots (10)                  | The number of dots to create
   dotsame (0.5)                 | The fraction of dots that are the same across channels
   dotshift ([2 -2 0])           | The shift of the dots across different channels
   dotpeak (255)                 | The peak value of the dot intensity

```
