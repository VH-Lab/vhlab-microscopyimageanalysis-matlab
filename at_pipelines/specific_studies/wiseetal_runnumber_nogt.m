function wisetal_runnumber_nogt(d, N, varargin)
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
% |doCoLoc (0)              | Should we do colocalizaton (1)? |
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
%    wiseetal_runnumber_nogt(d,109,'doit',0,'doROIfinding',1,'channels',{'PSD','VG','BAS'},'spacer','','doCoLoc',1)
%



channels = {'PSD','VG'};
doROIfinding = 0;
doit = 0;
doCoLoc= 0;
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

			% filter by the 1st threshold brightness
			if n==112, str = 'vf'; else, str = ''; end;
			evalstr = ['vh_filter2tbrightness(atd,''' channels{c} '_DEC' label{n(ni)} '_roires' str ''',''' channels{c} '_DEC' label{n(ni)} '_roiresbf'');'],
			if doit, at_foreachdirdo(d,evalstr); end;

			 % Volume filter
			disp(['volume filters']);
			clear p;
			p.volume_minimum = 20;
			p.volume_maximum = Inf;
			Step4_output_roi_name = [ channels{c} '_DEC' label{n(ni)} '_roiresbfvf' ]
			Step4_input_roi_name = [ channels{c} '_DEC' label{n(ni)} '_roiresbf' ]
			for i=1:numel(d),
				atd = atdir(d{i});
				if doit,
					h = gethistory(atd,'ROIs',Step4_input_roi_name);
					if ~isempty(h),
						at_roi_volumefilter(atd, Step4_input_roi_name, Step4_output_roi_name, p);
					end;
				end;
			end;
			disp(['volume filter finished']);

			close all;
		end

	end;
end

for c=1:numel(channels),
	for ni=1:numel(n),
		if doCoLoc,
			for j=1:numel(channels),
				if j>c,
					roiA = [channels{c} '_DEC' label{n(ni)} '_roiresbfvf']
					roiB = [channels{j} '_DEC' label{n(ni)} '_roiresbfvf']
					out = [roiA '_x_' roiB ];
					evalstr = ['vh_coloc1(atd, ''' roiA ''',''' roiB ''',''' out ''');']
					if doit, at_foreachdirdo(d,evalstr); end;
				end;
			end;
		end;
	end;
end;


