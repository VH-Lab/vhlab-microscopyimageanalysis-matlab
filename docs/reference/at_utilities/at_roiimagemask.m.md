# at_roiimagemask

```
  AT_ROIIMAGEMASK - remove everything from an image except regions inside ROIs
 
  AT_ROIIMAGEMASK(ORIGINAL_FILENAME, ROIMASK_FILENAME, NEW_FILENAME)
 
  Inputs:
    ORIGINAL_FILENAME  - A filename of a TIF image with multiple Z planes but one image channel
    ROIMASK_FILENAME   - A filename of an RGB TIF image with multiple Z planes, 
                           where one channel (R, G, or B) contains the pixels to
                           be allowed through the original image
    NEW_FILENAME       - The file name of a new file that will be created. It will be
                           a single image channel image with all 0s except for the locations that
                           are indicated in the roi mask image
 
  This function also takes name/value pairs that modify its behavior:
  Parameter (default)         | Description
  --------------------------------------------------------------------------------------------
  mask_channel (1)            | Which channel of ROIMASK_FILENAME has the the mask information?
                              |   (typically red is 1, green is 2, blue is 3)
  all_others_must_be_zero (1) | Use this option if the other channels must be 0 while the mask_channel
                              |   is 1.
  channels ([1 2 3])          | The channels available here.
 
  Examples:
      at_roiimagemask('myoriginalfile.tif','mymaskfile.tif','mymaskedfile.tif')
      at_roiimagemask('myoriginalfile.tif','mymaskfile.tif','mymaskedfile.tif','mask_channel',2)

```
