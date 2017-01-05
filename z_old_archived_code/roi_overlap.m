function [overlaps] = roi_overlap(rois, BI)
%ROI_OVERLAP - examines overlap between ROIs and binary image
%
%   [OVERLAPS] = ROI_OVERLAP(ROIS, BI)
%
%  Inputs:  ROIS - An ROI structure list as returned from SPOTDETECTOR
%             BI - A binary image to examine
%
%  Outputs: ROI_OVERLAP - The fraction of overlapping pixels
%    
overlaps = [];
for i=1:length(rois),
    numberpositivepixelsinBI = length(find(BI(rois(i).pixelinds)));
    overlaps(i) = numberpositivepixelsinBI/length(rois(i).pixelinds);
end;