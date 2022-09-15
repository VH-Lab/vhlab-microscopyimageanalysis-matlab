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
		s.PSD_DEC_auto = stats.stats;
	end;
	if startsWith(d(i).name,'VG_DEC_auto'),
		stats = load([gtpath filesep d(i).name]);
		s.VG_DEC_auto = stats.stats;
	end;
end;

