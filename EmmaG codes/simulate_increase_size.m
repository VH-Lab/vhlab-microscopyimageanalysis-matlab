function [overlap_objects] = simulate_increase_size(control_psd_file,control_vglut_file,ttx_psd_file)


vglutL = load([control_vglut_file '_L.mat']);
vglut_L = vglutL.L;
vglutCC = load([control_vglut_file '_ROI.mat']);
vglut_CC = vglutCC.CC;
nSims = 1; % 10

num_overlaps = [];

% Step 1, select a control slice
[surrogate_CC,surrogate_L] = Simulating_psdset_advanced(control_psd_file,ttx_psd_file);
xrange = (-2:1:2);
yrange = (-2:1:2);
zrange = (-2:1:2);

[overlap_ab, overlap_ba] = ROI_3d_all_overlaps(vglut_CC, vglut_L,surrogate_CC, surrogate_L, xrange, yrange, zrange);
overlap_thresh = overlap_ab >= 0.33;
overlap_objects = sum(overlap_thresh(:));
end
    
    % create a surrogate PSD-95 set of ROIs using the positions of the ROIs
    % from the selected control slice and the size of the ROIs from the
    % TTX-treated slice (randomly select a size for each ROI)
    
% end;