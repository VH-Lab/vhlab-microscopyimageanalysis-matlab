function im = readimage(mdir, imagename)
% READIMAGE - read an MIA image in its entirety
%
% IM = mia.utilities.readimage(MDIR, IMAGENAME)
%
% Reads the image from the MIA.MIADIR MDIR that has IMAGENAME.
% An error is generated if there is no such image.
%

im_in_file = mdir.getimagefilename(imagename);
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
