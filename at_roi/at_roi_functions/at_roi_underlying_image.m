function [image_name,imagefilename] = at_roi_underlying_image(atd,roi_name)
% AT_ROI_UNDERLYING_IMAGE - what is the underlying image of an ROI set?
%
% [IMAGE_NAME,IMAGEFILENAME] = AT_ROI_UNDERLYING_IMAGE(ATD,ROI_NAME)
%
% Return the raw image item that underlies the ROIs with name ROI_NAME.
%

h = gethistory(atd,'ROIs',roi_name);
image_name = h(1).parent;
imagefilename = getimagefilename(atd,h(1).parent);


