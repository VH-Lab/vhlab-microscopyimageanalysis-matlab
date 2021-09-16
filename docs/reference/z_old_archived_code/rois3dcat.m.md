# rois3dcat

```
  ROIS3DCAT - Concatenate 3D rois into a single roi
 
    [ROIS3DMERGED, L] = ROIS3DCAT(ROIS3D,L)
 
    Merges all of the ROIS3D into a single ROI. Useful
    if you want to examine material from a large object
    that might be divided into small pieces.
 
    Inputs: ROIS3D is a structure returned by SPOTDETECTOR3 that describes
    3D ROIS.  L is the labeled ROI matrix that is the same size as the
    image.
  
    See also: SPOTDETECTOR3

```
