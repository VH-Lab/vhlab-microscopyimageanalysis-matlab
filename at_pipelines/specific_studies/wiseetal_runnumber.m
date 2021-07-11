function wisetal_runnumber(d, N, varargin)
% WISEETAL_RUNNUMBER - run a pipeline algorithm for Wise et al
%
% WISEETAL_RUNNUMBER(D, N, ...)
%
% D is a cell array of directory names of experiments
% N is the algorithm number to use. For example, 109
% 
% The function takes name/value pairs that modify its behavior:
% ------------------------------------------------------------|
% | Parameter (default)     | Description                     |
% |-------------------------|---------------------------------|
% |doit (0)                 | Should we run the pipelines (1) |
% |                         |  or just print the commands we  |
% |                         |  would run (0)?                 |
% |doROIfinding (0)         | Should we discover ROIs (1)?    |
% |do_groundtruthanalysis(0)| Should we run ground truth      |
% |                         |  validation analysis?           |
% |spacer ('_')             | Are the images named 'PSD_DEC'  |
% |                         |  or PSDDEC? spacer is the       |
% |                         |  character in between. Use ''   |
% |                         |  for none.                      |
% |channels ({'PSD','VG'})  | Channels to run                 |
% |-------------------------|---------------------------------|
%
% Example:
%    d = {'/Volumes/van-hooser-lab/Users/Derek/Synaptic Imaging/Cell fills/Full dataset/11-12-20 DLW/CTRL 1/analysis'}
%    % or d = at_findalldirs('/Volumes/van-hooser-lab/Users/Derek/Synaptic Imaging/Cell fills/Full dataset')
%    % use this to check it
%    wiseetal_runnumber(d,109,'doit',0,'doROIfinding',1,'channels',{'PSD','VG','BAS'},'spacer','')
%    % use this to run it!
%    wiseetal_runnumber(d,109,'doit',0,'doROIfinding',1,'channels',{'PSD','VG','BAS'},'spacer','')
%



channels = {'PSD','VG'};
doROIfinding = 0;
doit = 0;
do_groundtruthanalysis = 0;
spacer = '_';

label = {};
label{101} = 'sv1';
label{102} = 'sv2';
label{103} = 'sv3';
label{104} = 'sv4';
label{105} = 'sv5';
label{106} = 'sv6';
label{107} = 'sv7';
label{108} = 'sv8';
label{109} = 'sv9';
label{110} = 'sv10';
label{111} = 'sv11';
label{112} = 'sv12';

tlevels = {};
tlevels{101} = [80 30];
tlevels{102} = [90 30];
tlevels{103} = [95 30];
tlevels{104} = [97.5  30];
tlevels{105} = [99 30];
tlevels{106} = [97.5 80];
tlevels{107} = [99 80];
tlevels{108} = [99.9 80];
tlevels{109} = [99.99 97];
tlevels{110} = [99.999 98];
tlevels{111} = [99.999 99.9];
tlevels{112} = [99.999 98];

vlt.data.assign(varargin);

n = find(~cellfun(@isempty,label));
n = intersect(n,N);

for c=1:numel(channels),
	for ni=1:numel(n),
		if doROIfinding,
			if n~=112,
				evalstr = ['vh_pipepiece1(atd, ''' channels{c} spacer 'DEC'', ''' channels{c} '_DEC' label{n(ni)} ...
					''',''plotthresholdestimate'',1,''t_levels'',' mat2str(tlevels{n(ni)}) ');'],
			else,
				evalstr = ['vh_pipepiece2(atd, ''' channels{c} spacer 'DEC'', ''' channels{c} '_DEC' label{n(ni)} ...
					''',''plotthresholdestimate'',1,''t_levels'',' mat2str(tlevels{n(ni)}) ');'],
			end;
			if doit, at_foreachdirdo(d,evalstr); end;
		end

		% filter by the 1st threshold brightness
		if n==112, str = 'vf'; else, str = ''; end;
		evalstr = ['vh_filter2tbrightness(atd,''' channels{c} '_DEC' label{n(ni)} '_roires' str ''',''' channels{c} '_DEC' label{n(ni)} '_roiresbf'');'],
		if doit, at_foreachdirdo(d,evalstr); end;

		if do_groundtruthanalysis,
			evalstr = ['vh_roicomparepipe(atd, ''' channels{c} '_ROI_'', ''' channels{c} '_DEC' label{n(ni)} '_roiresbf'');'],
			if doit, at_foreachdirdo(d,evalstr); end;
			evalstr = ['vh_roicomparepipe(atd, ''spine_ROI_'', ''' channels{c} '_DEC' label{n(ni)} '_roiresbf'',''useRes'',0);'],
			if doit, at_foreachdirdo(d,evalstr); end;

			evalstr = ['vh_groundtruthcompare(atd,''' channels{c} '_DEC' label{n(ni)} '_roiresbf'',''spine_ROI_DLW_ROI'',''' channels{c} '_ROI_'');']
			if doit, at_foreachdirdo(d([1:10 12]),evalstr); end;
			evalstr = ['vh_groundtruthcompare(atd,''' channels{c} '_DEC' label{n(ni)} '_roiresbf'',''spine_ROI_SG_ROI'',''' channels{c} '_ROI_'');']
			if doit, at_foreachdirdo(d([11 13:16]),evalstr); end;
			evalstr = ['vh_groundtruthcompare(atd,''' channels{c} '_DEC' label{n(ni)} '_roiresbf'',''spine_ROI_KC_ROI'',''' channels{c} '_ROI_'');']
			if doit, at_foreachdirdo(d([17:18]),evalstr); end;
		end;
	end;
end



