%% AUTOMATE COLOC CREATION
function trawldataforthreshed(fname,ch1,ch2)
% Runs a pipeline for COLOCALIZATION creation  on two sets of ROIs
% (designated as ch1 and ch2 as strings, such as 'PSD' which exactly match
% the beginning of the ROI name), generated with mia.utilities.automate.automateROIcreation images
% in a folder. It'll search the whole folder for the right files, and it's
% intended to be used over a long period (like overnight). Requires ROIs
% that have sent through the pipeline OR named with the suffix "_auto_pf".

% example for troubleshoot
% fname = 'D:\Analysis Data\Synaptic Imaging\Analysis 7, 5D TTX\2 24 20 VV\P17 5D TTX\Stack 1';

loopcoldepth(fname,10,ch1,ch2); % this is a separate function so that it can easily call itself - is this necessary?
disp(['Analysis is complete, your will is done.'])
end

%% LOOP OVER DEPTH, RUN PIPELINE WHEN IT HITS ANALYIS FOLDERS
function loopcoldepth(fname,depth,ch1,ch2)
% depth just means how deep it'll go searching for analysis folders - and
% going too high is fine (it won't add appreciable time).
dirlist = dirlist_trimdots(dir(fname),0);
for i=1:numel(dirlist),
    if strncmp(lower(dirlist{i}),'analysis',8) % then this folder is an experiment, so run it
        atd = atdir([fname '\analysis']);
        % find each channel with a CHANNEL_th file in it
        ROIsets = dirlist_trimdots(dir([fname '\analysis\ROIs']),0); % this is just a check in this version
        disp(['Beginning: ' fname])
        colocw2channel(atd,ch1,ch2);
    else
        if depth>0,
            loopcoldepth(fullfile(fname,dirlist{i}), depth-1,ch1,ch2);
        end
    end
end
end

%% RUN THE PIPELINE
function colocw2channel(atd,ch1,ch2)
% Reciprocally colocalizes 2 ROI sets with each other, and also generates
% the colocalized subset of ROIs for each channel.
% Requires input as an analysis file, and a pair channel name. You have to
% have run specifically the automated ROI creation code beforehand, or use
% the suffix: (ch)_auto_pf for each channel.

% Step 1: make the first colocalization
disp(['Making first colocalization! (Ch1 -> Ch2)'])
clear p;
p.shiftsX = [-2 -1 0 1 2];
p.shiftsY = [-2 -1 0 1 2];
p.shiftsZ = 0;
p.threshold = 0.01;
p.roi_set_2 = [ch2 '_auto_sf'];
coloc12input = [ch1 '_auto_sf'];
coloc12output = [ch1 'autocolocw' ch2];
mia.colocalization.at_colocalization_makers.at_colocalization_shiftxyz(atd,coloc12input,coloc12output,p);

% Step 2: make the second colocalization
disp(['Making second colocalization! (Ch2 -> Ch1)'])
clear p;
p.shiftsX = [-2 -1 0 1 2];
p.shiftsY = [-2 -1 0 1 2];
p.shiftsZ = 0;
p.threshold = 0.01;
p.roi_set_2 = [ch1 '_auto_sf'];
coloc21input = [ch2 '_auto_sf'];
coloc21output = [ch2 'autocolocw' ch1];
mia.colocalization.at_colocalization_makers.at_colocalization_shiftxyz(atd,coloc21input,coloc21output,p);

% Step 3: find puncta in Ch1 that are colocalized with Ch2
disp(['Making first colocalized filter!'])
clear p;
p.colocalization_name = coloc12output;
p.include_overlaps = 1;
filter12input = [ch1 '_auto_sf'];
filter12output = [ch1 '_colocw' ch2];
mia.roi.roi_editors.at_roi_filtercolocalization(atd,filter12input,filter12output,p);

% Step 4: find puncta in Ch2 that are colocalized with Ch1
disp(['Making second colocalized filter!'])
clear p;
p.colocalization_name = coloc21output;
p.include_overlaps = 1;
filter21input = [ch2 '_auto_sf'];
filter21output = [ch2 '_colocw' ch1];
mia.roi.roi_editors.at_roi_filtercolocalization(atd,filter21input,filter21output,p);

end
