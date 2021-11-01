function [image_name,imagefilename] = underlying_image(atd,roi_name)
% UNDERLYING_IMAGE - what is the underlying image of an ROI set?
%
% [IMAGE_NAME,IMAGEFILENAME] = MIA.ROI.FUNCTIONS.UNDERLYING_IMAGE(ATD,ROI_NAME)
%
% Return the raw image item that underlies the ROIs with name ROI_NAME.
%

h = mia.miadir.gethistory(atd,'ROIs',roi_name);
if isempty(h),
    error(['No history found.']);
end;
image_name = h(1).parent;
imagefilename = mia.miadir.getimagefilename(atd,h(1).parent);


