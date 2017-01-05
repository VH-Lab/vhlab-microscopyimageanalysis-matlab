function [rois3dmerged, L] = rois3dcat(rois3d,L)
% ROIS3DCAT - Concatenate 3D rois into a single roi
%
%   [ROIS3DMERGED, L] = ROIS3DCAT(ROIS3D,L)
%
%   Merges all of the ROIS3D into a single ROI. Useful
%   if you want to examine material from a large object
%   that might be divided into small pieces.
%
%   Inputs: ROIS3D is a structure returned by SPOTDETECTOR3 that describes
%   3D ROIS.  L is the labeled ROI matrix that is the same size as the
%   image.
% 
%   See also: SPOTDETECTOR3

rois3dmerged = rois3d(1);

for i=2:length(rois3d),
    rois3dmerged.pixelinds = cat(1,rois3dmerged.pixelinds,rois3d(i).pixelinds);
    rois3dmerged.xi = cat(1,rois3dmerged.xi,rois3d(i).xi);
    rois3dmerged.yi = cat(1,rois3dmerged.yi,rois3d(i).yi);
    L(rois3d(i).pixelinds) = 1; % reassign labels in L to 1
end;

