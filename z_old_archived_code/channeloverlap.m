function [overlap12, overlap21] = channeloverlap(file1, file2, n, xrange, yrange, zrange)

roifile1 = importdata(file1);
roifile2 = importdata(file2);

rois3d1 = roifile1.imrois;
rois3d2 = roifile2.imrois;

size(rois3d1)
size(rois3d2)

L1 = roifile1.L;
L2 = roifile2.L;

[overlap12, overlap21] = all_overlaps(rois3d1, rois3d2, L1, L2, n, xrange, yrange, zrange);