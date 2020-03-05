function at_roiimagemask(original_filename, roimask_filename, new_filename, varargin)
% AT_ROIIMAGEMASK - remove everything from an image except regions inside ROIs
%
% AT_ROIIMAGEMASK(ORIGINAL_FILENAME, ROIMASK_FILENAME, NEW_FILENAME)
%
% Inputs:
%   ORIGINAL_FILENAME  - A filename of a TIF image with multiple Z planes but one image channel
%   ROIMASK_FILENAME   - A filename of an RGB TIF image with multiple Z planes, 
%                          where one channel (R, G, or B) contains the pixels to
%                          be allowed through the original image
%   NEW_FILENAME       - The file name of a new file that will be created. It will be
%                          a single image channel image with all 0s except for the locations that
%                          are indicated in the roi mask image
%
% This function also takes name/value pairs that modify its behavior:
% Parameter (default)         | Description
% --------------------------------------------------------------------------------------------
% mask_channel (1)            | Which channel of ROIMASK_FILENAME has the the mask information?
%                             |   (typically red is 1, green is 2, blue is 3)
% all_others_must_be_zero (1) | Use this option if the other channels must be 0 while the mask_channel
%                             |   is 1.
% channels ([1 2 3])          | The channels available here.
%
% Examples:
%     at_roiimagemask('myoriginalfile.tif','mymaskfile.tif','mymaskedfile.tif')
%     at_roiimagemask('myoriginalfile.tif','mymaskfile.tif','mymaskedfile.tif','mask_channel',2)
% 

mask_channel = 1;
all_others_must_be_zero = 1;
channels = [1 2 3];

assign(varargin{:});

imf = imfinfo(original_filename);

for i=1:numel(imf),
	im_frame_here = imread(original_filename,i);
	im_mask_here = imread(roimask_filename,i);

	masked_pts = im_mask_here(:,:,mask_channel) = 1;
	if all_others_must_be_zero,
		for c=1:numel(channels),
			if ~ismember(channels,mask_channel),
				masked_pts = masked_pts .& [im_mask_here(:,:,channels(c)==0];
			end;
		end;
	end;

	inds_to_zero = find(~masked_pts);

	im_frame_here(inds_to_zero) = 0;

	if i==1,
		imwrite(im_frame_here, new_filename,'tif');
	else,
		imwrite(im_frame_here, new_filename,'tif','WriteMode','append');
	end;

end;


