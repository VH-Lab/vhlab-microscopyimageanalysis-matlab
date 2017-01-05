function [rois_overlap] = all_overlaps(rois1d, rois3d, L1d, L3d, n, xrange, yrange, zrange)

%   Inputs:ROIS3D1, ROIS3D2 are ROI structures that are returned from
%           SPOTDETECTOR3. It has the following fields:
%          .name       The name of the roi (same as ROINAME)
%          .index      The index number
%          .xi         The xi coordinates of the contour
%          .yi         The yi coordinates of the contour
%          .pixelinds  Pixel index values (in image BW) of the ROI
%          .labels     Any labels for this ROI
%          .stats      All stats from matlab's regionprops func   
%          L - the labeled 3D BW image; the numbers correspond to the ROIs (0
%          means no ROI was found at that location)
%          n           No. of pixels by which ROI3D1 will be flared out
%          XRANGE, YRANGE, ZRANGE: we will calculate the overlap over
%          shifts of the ROIs in X, Y, and Z. e.g., XRANGE = [ -5 : 1 : 5]
%          YRANGE = [ -5 : 1 : 5], ZRANGE = [ -5 : 1 5] computes the
%          overlap for all shifts in X, Y, and Z of 5 pixels (in all
%          directions).
%    
%     Outputs:
%         ROIS3DOVERLAP12 is the fraction of flared ROIS3D1 that overlaps ROIS3D2 when flared ROIS3D1 is shifted by x, y, z pixels
%         ROIS3DOVERLAP21 is the fraction of ROIS3D2 that overlaps flared ROIS3D1 when flared ROIS3D2 is shifted by x, y, z pixels
%
% So, if you have saved L1 and L2, which are full-sized images that have at 
% each point the index number of the ROI, then you can quickly evaluate
% 
% ROIS3d2_that_could_overlap_with_i = unique(L2(rois3d1(i).indexes));
%           
% And then you can compute the overlap with all of those overlaps between 
% rois3d1(i) and rois3d2(j) (where j is in ROIS3d2_that_could_overlap_with_i, 
% All other overlaps would be set to 0.
% 
% We'll need to modify this approach, because you'll want to "flare out" 
% the pixels of rois3d1(i).indexes by a few units 
% (over the spatial range over which you are calculating the overlap).  
% Even if 2 objects don't touch each other, they might overlap in the range 
% of shifts that are applied.


imsize = size(L1d);

ind_flared = flare_indexes(rois1d.pixelinds, imsize, n); 
rois3d__overlap = unique(L3d(ind_flared));
rois3d__overlap = setdiff(rois3d__overlap, 0);
rois3d__overlap=rois3d__overlap;
    
progressbar
    
for j = 1:length(rois3d__overlap);
    k=rois3d__overlap(j);
    rois_overlap.index(j)=k;
    rois_overlap.percents(j,:)=rois3d_overlap(rois1d, rois3d(k), xrange, yrange, zrange, imsize);
    progressbar(j/(length(rois3d__overlap)))
end

rois_overlap.sum1d=sum(sum(sum(L1d)));
rois_overlap.n=size(rois_overlap.index,1);
rois_overlap.n_sum1d=rois_overlap.n/rois_overlap.sum1d;

end


