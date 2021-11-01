function im = readimage(atd, imagename)
% READIMAGE - read an AT image in its entirety
%
% IM = mia.utilities.readimage(ATD, IMAGENAME)
%
% Reads the image from the ATDIR ATD that has IMAGENAME.
% An error is generated if there is no such image.
%

im_in_file = mia.miadir.getimagefilename(atd,imagename);
if isempty(im_in_file),
	error(['No image ' imagename ' found.']);
end;

input_finfo = imfinfo(im_in_file);
im = [];
for i=1:numel(input_finfo),
        im_here = imread(im_in_file,'index',i,'info',input_finfo);
        im = cat(3,im,im_here);
end;

 
