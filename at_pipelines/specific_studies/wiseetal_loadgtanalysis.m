function s = wiseetal_loadgtanalysis(dirname)
% WISEETAL_LOADGTANALYSIS - load ground truth analysis
%
% S = WISEETAL_LOADGTANALYSIS(DIRNAME)
% 
% DIRNAME is the directory name of an experiment
%

s.PSD = [];
s.VG = [];

gtpath = [dirname filesep 'groundtruth_analysis'];

d = vlt.file.dirstrip(dir(gtpath));

for i=1:numel(d),
	% PSD first
	if startsWith(d(i).name,'PSD_DECsv'),
		n = sscanf(d(i).name,'PSD_DECsv%d_');
		stats = load([gtpath filesep d(i).name]);
		if ~isfield(s.PSD,['PSDv' int2str(n)]),
			eval(['s.PSD.PSDv' int2str(n) '=stats.stats;']);
		else,
			eval(['s.PSD.PSDv' int2str(n) '(end+1)=stats.stats;']);
		end;
	end;
	if startsWith(d(i).name,'VG_DECsv'),
		n = sscanf(d(i).name,'VG_DECsv%d_');
		stats = load([gtpath filesep d(i).name]);
		if ~isfield(s.VG,['VGv' int2str(n)]),
			eval(['s.VG.VGv' int2str(n) '=stats.stats;']);
		else,
			eval(['s.VG.VGv' int2str(n) '(end+1)=stats.stats;']);
		end;
	end;
end;

