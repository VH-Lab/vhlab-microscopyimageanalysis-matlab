function roi_xyz = ROI_indexes2xyz(CC)

% give out indexes of each ROI and form an array of all the indexes

for i=1:numel(CC.PixelIdxList)
    [roi_xyz{i}(1,:),roi_xyz{i}(2,:),roi_xyz{i}(3,:)] = ind2sub(CC.ImageSize, CC.PixelIdxList{i});
end

end
