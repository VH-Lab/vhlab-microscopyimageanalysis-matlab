%% Automate Output Volume for "Double Volume Measures" analysis
function automatevolumes(fname)
% example for troubleshoot
% fname = 'D:\Analysis Data\Synaptic Imaging\Analysis 7, 5D TTX\2 24 20 VV\P17 5D TTX\Stack 1';

loopdepth(fname,20); % this is a separate function so that it can easily call itself - is this necessary?
disp(['Analysis is complete, your will is done.'])
end

%% LOOP OVER DEPTH, RUN PIPELINE WHEN IT HITS ANALYIS FOLDERS
function loopdepth(fname,depth)
% depth just means how deep it'll go searching for analysis folders - and
% going too high is fine (it won't add appreciable time).
dirlist = dirlist_trimdots(dir(fname),0);
for i=1:numel(dirlist),
    if strncmp(lower(dirlist{i}),'analysis',8) % then this folder is an experiment, so run it
        atd = atdir([fname '\analysis']);
        disp(['Output for ' fname '\analysis BAS:']);
        reportvolumes(atd,'BAS_colocwPSD');
        disp(['Output for ' fname '\analysis PSD:']);
        reportvolumes(atd,'PSD_colocwBAS');
    else
        if depth>0,
            loopdepth(fullfile(fname,dirlist{i}), depth-1);
        end
    end
end
end

