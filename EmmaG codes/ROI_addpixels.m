function [more_indexes] = ROI_addpixels(indexes,imsize,increased_size,limits)
for n = 1:limits
bigger_roi = ROI_flare_indexes(indexes, imsize, n);
new_indexes = setdiff(bigger_roi,indexes);
if length(new_indexes)>= increased_size
    for i = 1:increased_size
        indexes = [indexes;new_indexes(randi(numel(new_indexes)))];
    end
    break
end
end
more_indexes = indexes;
end
