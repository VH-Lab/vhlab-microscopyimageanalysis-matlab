function [rois_per_zframe] = roisperzframe(mdir, roiname)
% ROISPERZFRAME - calculate the number of ROIs that intersect each Z frame of the stack
%
% ROIS_PER_ZFRAME = mia.utilities.roisperzframe(MDIR, ROINAME)
%
% Given an array tomography directory object (see "help mdir") and an ROI dataset name in
% ROINAME, this function calculates the number of 3D ROIs that intersect each Z plane in 2D.
%
% Example:
%     mdir = mia.miadir('/Users/vanhoosr/Downloads/2015-06-03');
%     roiname = 'PSD_newscale_th_roi_vf_res'; % example roi name
%     rois_per_zframe = mia.utilities.roisperzframe(mdir, roiname);
% 
% See also: ATDIR 


roifilename = mdir.getroifilename(roiname);
roilabeledfilename = mdir.getlabeledroifilename(roiname);

L = load(roilabeledfilename,'-mat');
L = L.L;

rois_per_zframe = [];

for z=1:size(L,3), % over each z frame
	unique_rois_here = setdiff(unique(L(:,:,z)),0);
	rois_per_zframe(z) = numel(unique_rois_here);
end;
