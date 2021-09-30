function makefinalroi(atd,threshed_img_name)
% Goes through the steps for my ROI analysis as of early October 2020.
% Requires input as a file name with the suffix _th (case sensitive).
which_img = cell2mat(threshed_img_name);
name_root = which_img(1:end-3);

disp(['Working on ' which_img])

% Step 1: make rois
disp(['Making original ROIs!'])
clear p;
p.connectivity = 6;
S1_rois_output_name = [name_root '_auto_roi'];
mia.roi.roi_makers.at_roi_connect(atd, which_img, S1_rois_output_name, p);

% Step 2: resegment ROIs
disp(['Watershed resegmentation!'])
clear p;
p.resegment_algorithm = 'watershed';
p.connectivity = 0;
p.values_outside_roi = 0;
p.use_bwdist = 0;
p.imagename = ''; % should use "default in history"
p.assignborders = 1;
S2_res_output_name = [name_root '_auto_res'];
mia.roi.roi_editors.at_roi_resegment(atd, S1_rois_output_name, S2_res_output_name, p);

% Step 3: volume filter
disp(['Volume filter!'])
clear p;
if strncmp(threshed_img_name,'PSD',3)
    p.volume_minimum = 8;
    p.volume_maximum = 512;
elseif strncmp(threshed_img_name,'VG',2)
    p.volume_minimum = 20;
    p.volume_maximum = 1000;
elseif strncmp(threshed_img_name,'BAS',3)
    p.volume_minimum = 8;
    p.volume_maximum = 512;
elseif strncmp(threshed_img_name,'GEPH',2)
    p.volume_minimum = 8;
    p.volume_maximum = 512;    
elseif strncmp(threshed_img_name,'VGAT',2)
    p.volume_minimum = 20;
    p.volume_maximum = Inf;    
else
    p.volume_minimum = 8;
    p.volume_maximum = 512;
    disp(['Please either edit this code or your threshed image names, code has contingencies for PSD, VG and BAS'])
    disp(['... but for now, defaulting to 8-512 pixel volume'])
end
S3_vf_output_name = [name_root '_auto_vf'];
mia.roi.roi_editors.at_roi_volumefilter(atd, S2_res_output_name, S3_vf_output_name, p);

% Step 5: prominency filter
disp(['Squat filter!'])
clear p;
p.prc_cut = 5;
p.dist_cardinal = 15;
p.imagename = '';
S4_sf_output_name = [name_root '_auto_sf'];
mia.roi.roi_editors.at_roi_squatfilter(atd, S3_vf_output_name, S4_sf_output_name, p);

end
