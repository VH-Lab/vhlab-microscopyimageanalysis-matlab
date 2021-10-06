%% AUTOMATE ROI CREATION
function trawldataforthreshed(fname,varargin)
% Runs a pipeline for ROI creation and alteration on every set of threshed
% images in a folder. It'll search the whole folder for the right files,
% and it's intended to be used over a long period (like overnight).
% Requires images that have been thresholded, and named with the suffix
% "_th", ideally after PSD, VG and BAS (and if you want to add more
% options, probably figure out what size in pixels they should be and add
% those to the final function).

% example for troubleshoot
% fname = 'D:\Analysis Data\Synaptic Imaging\Analysis 7, 5D TTX\2 24 20 VV\P17 5D TTX\Stack 1';
exclude_channel = 'blank';
assign(varargin{:});

loopdepth(fname,20,exclude_channel);
disp(['Analysis is complete, your will is done.'])
end

%% LOOP OVER DEPTH, RUN PIPELINE WHEN IT HITS ANALYIS FOLDERS
function loopdepth(fname,depth,exclude_channel)
% depth just means how deep it'll go searching for analysis folders - and
% going too high is fine (it won't add appreciable time).
dirlist = dirlist_trimdots(dir(fname),0);
for i=1:numel(dirlist),
    if strncmp(lower(dirlist{i}),'analysis',8) % then this folder is an experiment, so run it
        atd = atdir([fname '\analysis']);
        % find each channel with a CHANNEL_th file in it
        imgs = dirlist_trimdots(dir([fname '\analysis\images']),0);
        for k = 1:numel(imgs),
            this_image = cell2mat(imgs(k));
            scansize = min([size(exclude_channel,2) size(this_image,2)]);
            if numel(this_image) > 3 & strncmp(lower(this_image(end-2:end)),'_th',3) & ~strncmp(lower(this_image(1:scansize)),lower(exclude_channel),scansize)
                threshed_img_name = imgs(k);
                disp(['Now gathering data from ' fname '...']);
                makefinalroi(atd,threshed_img_name);
            end
        end
    else
        if depth>0,
            loopdepth(fullfile(fname,dirlist{i}), depth-1,exclude_channel);
        end
    end
end
end

%% RUN THE PIPELINE
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
at_roi_connect(atd, which_img, S1_rois_output_name, p);

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
at_roi_resegment(atd, S1_rois_output_name, S2_res_output_name, p);

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
at_roi_volumefilter(atd, S2_res_output_name, S3_vf_output_name, p);

% Step 5: prominency filter
disp(['Squat filter!'])
clear p;
p.prc_cut = 5;
p.dist_cardinal = 15;
p.imagename = '';
S4_sf_output_name = [name_root '_auto_sf'];
at_roi_squatfilter(atd, S3_vf_output_name, S4_sf_output_name, p);

end