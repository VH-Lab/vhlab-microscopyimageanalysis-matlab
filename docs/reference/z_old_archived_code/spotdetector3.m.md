# spotdetector3

```
  SPOTDETECTOR - identifies spots in a binary image
 
    [ROIS3D, L, ROIS2D] = SPOTDETECTOR3(BI, CONNECTIVITY, ROINAME, ...
                FIRSTINDEX, LABELS)
 
   Inputs: BI - binary image in which to detect spots (can be 3d)
           CONNECTIVITY - 4 or 8; should pixels only be considered
                connected if they are immediately adjacent in x and y (4)
                or should diagonals be considered adjacent (8)?
           ROINAME - Name for the ROI series...maybe the same as a filename?
           FIRSTINDEX - Index number to start with for labeling (maybe 0 or 1?)
           LABELS - Any labels you might want to include (string or cell list)
 
   Ouputs: ROIS3D a structure array with the following fields:
           ROIS3D(i).name       The name of the roi (same as ROINAME)
           ROIS3D(i).index      The index number
           ROIS3D(i).xi         The xi coordinates of the contour
           ROIS3D(i).yi         The yi coordinates of the contour
           ROIS3D(i).pixelinds  Pixel index values (in image BW) of the ROI
           ROIS3D(i).labels     Any labels for this ROI
           ROIS3D(i).stats      All stats from matlab's regionprops func
           L - the labeled 3D BW image; the numbers correspond to the ROIs (0
           means no ROI was found at that location)
           ROIS2D - a structure array with the 2d rois that were observed in the
             individual images in the stack BI

```
