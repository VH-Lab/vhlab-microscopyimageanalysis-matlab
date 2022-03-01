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
        mdir = mia.miadir([fname '\analysis']);
        % find each channel with a CHANNEL_th file in it
        imgs = dirlist_trimdots(dir([fname '\analysis\images']),0);
        for k = 1:numel(imgs),
            this_image = cell2mat(imgs(k));
            scansize = min([size(exclude_channel,2) size(this_image,2)]);
            if numel(this_image) > 3 & strncmp(lower(this_image(end-2:end)),'_th',3) & ~strncmp(lower(this_image(1:scansize)),lower(exclude_channel),scansize)
                threshed_img_name = imgs(k);
                disp(['Now gathering data from ' fname '...']);
                mia.utilities.automate.makefinalroi(mdir,threshed_img_name);
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
function makefinalroi(mdir,threshed_img_name)
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
mia_creator_roi_connect_obj = mia.creator.roi.connect(mdir, which_img, S1_rois_output_name);
mia_creator_roi_connect_obj.make(p);

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
mia_creator_roi_resegment_obj = mia.creator.roi.resegment(mdir, S1_rois_output_name, S2_res_output_name);
mia_creator_roi_resegment_obj.make(p);

% Step 3: second threshold on ROIs
disp(['Second threshold!'])
p.secthresh = 0.50;
p.dist_cardinal = 50;
p.CV_binsize = 5;
p.imagename = '';
S3_sth_output_name = [name_root '_auto_sth'];
mia_creator_roi_secondthresh_obj = mia.creator.roi.secondthresh(mdir, S2_res_output_name, S3_sth_output_name)
mia_creator_roi_secondthresh_obj.make(p);

% Step 4: volume filter
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
S4_vf_output_name = [name_root '_auto_vf'];
mia_creator_roi_volumefilter_obj = mia.creator.roi.volumefilter(mdir, S3_sth_output_name, S4_vf_output_name);
mia_creator_roi_volumefilter_obj.make(p);

% Step 5: prominency filter
disp(['Prominency filter!'])
clear p;
p.prom_thresh = 0;
p.dist_cardinal = 50;
p.CV_binsize = 5;
p.imagename = '';
S5_pf_output_name = [name_root '_auto_pf'];
mia_creator_roi_prominencyfilter = mia.creator.roi.prominencyfilter(mdir, S4_vf_output_name, S5_pf_output_name);
mia_creator_roi_prominencyfilter.make(p);

end
