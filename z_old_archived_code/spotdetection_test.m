

 im = imread('DAPI TIFF.tif');
 im3d = cat(3, im, im, im, im, im);
  % here examine histogram
 
im3d_thresh = im3d > 100;
 
[roi_im3d, rois,L]=spotdetector2(im3d_thresh,4, 'im3d', 1, {'im3d'});
 
 % check the roi boundaries for the first slice
figure;
colormap(gray);
imagesc(im3d(:,:,1));
[h_lines,h_text]=plot_rois(rois{1},9,[1 0 1]);

my_mask = im3d * 0;
for i=1:length(roi_im3d),
    my_mask(roi_im3d(i).pixelinds) = 1;
end;
figure;
imagesc(my_mask(:,:,1));
[h_lines,h_text]=plot_rois(rois{1},9,[1 0 1]);


figure;
imagesc(im3d_thresh(:,:,1)*255);
[h_lines,h_text]=plot_rois(rois{1},9,[1 0 1]);
