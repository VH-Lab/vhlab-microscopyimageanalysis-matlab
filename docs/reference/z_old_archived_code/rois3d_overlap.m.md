# rois3d_overlap

```
  ROIS3D_OVERLAP - Computes overlap between 3D ROIS in 3D space for different shifts
  
  [OVERLAPA, OVERLAPB] = RPO3D_OVERLAP(ROIS3D1, ROIS3D2, XRANGE, YRANGE,...
      ZRANGE, IMSIZE)
 
    Inputs:ROIS3D1, ROIS3D2 are ROI structures that are returned from
           SPOTDETECTOR3. It has the following fields:
           .name       The name of the roi (same as ROINAME)
           .index      The index number
           .xi         The xi coordinates of the contour
           .yi         The yi coordinates of the contour
           .pixelinds  Pixel index values (in image BW) of the ROI
           .labels     Any labels for this ROI
           .stats      All stats from matlab's regionprops func   
           XRANGE, YRANGE, ZRANGE: we will calculate the overlap over
           shifts of the ROIs in X, Y, and Z. e.g., XRANGE = [ -5 : 1 : 5]
           YRANGE = [ -5 : 1 : 5], ZRANGE = [ -5 : 1 5] computes the
           overlap for all shifts in X, Y, and Z of 5 pixels (in all
           directions).
           IMSIZE - The image size in pixels [NX NY NZ]
    Outputs:
           OVERLAPA(x,y,z) is the fraction of roi3d1 that overlaps roi3d2 when roi3d1 is shifted by x, y, z pixels
           OVERLAPB(x,y,z) is the fraction of roi3d2 that overlaps roi3d1 when roi3d1 is shifted by x, y, z pixels
 
    See also: SPOTDETECTOR3, ALL_OVERLAPS

```
