function roi_shape = ROI_mass(ROI_indexes)
for i = 1:length(ROI_indexes)
    x_values = ROI_indexes{i}(1,:);
    y_values = ROI_indexes{i}(2,:);
    z_values = ROI_indexes{i}(3,:);
    center_x = fix(mean(x_values));
    x_shift = [x_values-center_x x_values-center_x];
    center_y = fix(mean(y_values));
    y_shift = [y_values-center_y y_values-center_y];
    center_z = fix(mean(z_values));
    z_shift = [z_values-center_z z_values-center_z];
    ROI_shapes{i} = [x_shift;y_shift;z_shift];
end
roi_shape = ROI_shapes;
end