function s = wiseetal_loadgtanalysis2(dirname)
% WISEETAL_LOADGTANALYSIS - load ground truth analysis
%
% S = WISEETAL_LOADGTANALYSIS2(DIRNAME)
% 
% DIRNAME is the directory name of an experiment
%

s.PSD = [];
s.VG = [];

gtpath = [dirname filesep 'groundtruth_analysis'];

d = vlt.file.dirstrip(dir(gtpath));

for i=1:numel(d),
	% PSD first
	if startsWith(d(i).name,'PSD_DEC_auto'),
		stats = load([gtpath filesep d(i).name]);
        f = strfind(d(i).name,'PSD_ROI_');
        str = d(i).name(f+(8:9));
        eval(['s.PSD.PSD_DEC_auto_' str '=stats.stats;'])
	end;
	if startsWith(d(i).name,'VG_DEC_auto'),
        f = strfind(d(i).name,'VG_ROI_');
        str = d(i).name(f+(7:8));
		stats = load([gtpath filesep d(i).name]);
        eval(['s.VG.VG_DEC_auto_' str '=stats.stats;'])
	end;
end;

