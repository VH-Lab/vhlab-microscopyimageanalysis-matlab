function center_xyz = ROI_masscenter(ROI_indexes)
% 

for i = 1:length(ROI_indexes)
    x_values = ROI_indexes{i}(1,:);
    y_values = ROI_indexes{i}(2,:);
    z_values = ROI_indexes{i}(3,:);
    center_x = fix(mean(x_values));
    center_y = fix(mean(y_values));
    center_z = fix(mean(z_values));
    ROI_centers{i} = [center_x center_y center_z];
end
center_xyz = ROI_centers;
end

    
