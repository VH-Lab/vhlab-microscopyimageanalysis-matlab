# at_roisperzframe

```
  AT_ROISPERZFRAME - calculate the number of ROIs that intersect each Z frame of the stack
 
  ROIS_PER_ZFRAME = AT_ROISPERZFRAME(THE_ATDIR, ROINAME)
 
  Given an array tomography directory object (see "help atdir") and an ROI dataset name in
  ROINAME, this function calculates the number of 3D ROIs that intersect each Z plane in 2D.
 
  Example:
      the_atdir = atdir('/Users/vanhoosr/Downloads/2015-06-03');
      roiname = 'PSD_newscale_th_roi_vf_res'; % example roi name
      rois_per_zframe = at_roisperzframe(the_atdir, roiname);
  
  See also: ATDIR

```
