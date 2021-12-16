function [image_name,imagefilename] = underlying_image(mdir,roi_name)
% UNDERLYING_IMAGE - what is the underlying image of an ROI set?
%
% [IMAGE_NAME,IMAGEFILENAME] = MIA.ROI.FUNCTIONS.UNDERLYING_IMAGE(MDIR,ROI_NAME)
%
% Return the raw image item that underlies the ROIs with name ROI_NAME.
%

h = mdir.gethistory('ROIs',roi_name);
if isempty(h),
    error(['No history found.']);
end;
image_name = h(1).parent;
imagefilename = mdir.getimagefilename(h(1).parent);


