function [puncta_info] = at_puncta_info(img_stack,CC)
% FIND THE INTENSITY VALUES FOR EACH ROI
sz_matrix = [size(img_stack,1) size(img_stack,2) size(img_stack,3)];
for k = 1:length(CC.PixelIdxList), %For each ROI...
one_punctum =  cell2mat(CC.PixelIdxList(k));
if size(one_punctum,1) < size(one_punctum,2)
    one_punctum = one_punctum';
end
[row column z] = ind2sub(sz_matrix,one_punctum);
one_puncta_int = [];
for i = 1:length(one_punctum), % For each pixel in the ROI...
one_puncta_int(i) = img_stack(row(i),column(i),z(i));
end
puncta_info{k,1} = k; %puncta number
puncta_info{k,2} = [row column z]; %locations, note this is [y x z]
puncta_info{k,3} = one_puncta_int'; %intensities

end
end
