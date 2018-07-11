function [num_overlaps] = simulate_increase_size(file_folder)


control_vglut_filenames = ([file_folder 'sample #2 CTRL/ROIs/vglut_threshold_26_vf_zf']);
control_psd_file = ([file_folder 'sample #2 CTRL/ROIs/psd_threshold_26_vf_zf']);
ttxtreated_psd_file = ([file_folder 'sample #2 TTX/ROIs/psd_threshold_26_vf_zf']);

vglutL = load([control_vglut_filenames '/vglut_threshold_26_vf_zf_L.mat']);
vglut_L = vglutL.L;
vglutCC = load([control_vglut_filenames '/vglut_threshold_26_vf_zf_ROI.mat']);
vglut_CC = vglutCC.CC;
nSims = 1; % 10

num_overlaps = [];
for n=1:nSims
    % Step 1, select a control slice
    [surrogate_CC,surrogate_L] = Simulating_psdset_shapechange(control_psd_file,ttxtreated_psd_file);
    xrange = (-2:1:2);
    yrange = (-2:1:2);
    zrange = (-2:1:2);
    
    [overlap_ab, overlap_ba] = ROI_3d_all_overlaps(vglut_CC, vglut_L,surrogate_CC, surrogate_L, xrange, yrange, zrange);
    overlap_thresh = overlap_ab >= 0.33;
    overlap_objects = sum(overlap_thresh(:));
    num_overlaps = [num_overlaps overlap_objects];
end
histogram(num_overlaps)
end
    
    % create a surrogate PSD-95 set of ROIs using the positions of the ROIs
    % from the selected control slice and the size of the ROIs from the
    % TTX-treated slice (randomly select a size for each ROI)
    
% end;