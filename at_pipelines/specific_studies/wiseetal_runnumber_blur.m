function wisetal_runnumber_blur(d,  varargin)
% WISEETAL_RUNNUMBER - run a pipeline algorithm for Wise et al
%
% WISEETAL_RUNNUMBER_BLUR(D,  ...)
%
% D is a cell array of directory names of experiments
% 
% The function takes name/value pairs that modify its behavior:
% ------------------------------------------------------------|
% | Parameter (default)     | Description                     |
% |-------------------------|---------------------------------|
% |doit (0)                 | Should we run the pipelines (1) |
% |                         |  or just print the commands we  |
% |                         |  would run (0)?                 |
% |spacer ('_')             | Are the images named 'PSD_DEC'  |
% |                         |  or PSDDEC? spacer is the       |
% |                         |  character in between. Use ''   |
% |                         |  for none.                      |
% |channels ({'PSD'})       | Channels to run                 |
% |blur_gauss (1)           | Should we use gauss or circle?  |
% |blur_rad (10)            | Blur radius                     |
% |blur_filt (50)           | Blur filter width               |
% |postblur_th (3)          | Post-blur threshold             |
% |-------------------------|---------------------------------|
%
% Example:
%    d = {'/Volumes/van-hooser-lab/Users/Derek/Synaptic Imaging/Cell fills/Full dataset/11-12-20 DLW/CTRL 1/analysis'}
%    % or d = at_findalldirs('/Volumes/van-hooser-lab/Users/Derek/Synaptic Imaging/Cell fills/Full dataset')
%    % use this to check it
%    wiseetal_runnumber_blur(d,'doit',0,'channels',{'PSD','VG','BAS'},'spacer','_')
%    % use this to run it!
%    wiseetal_runnumber_blur(d,'doit',1,'channels',{'PSD','VG','BAS'},'spacer','_')
%



channels = {'PSD','VG'};
doit = 0;
spacer = '_';
blur_gauss = 1;
blur_rad = 10;
blur_filt = 50;
postblur_th = 3;

vlt.data.assign(varargin);

for c=1:numel(channels),
	evalstr = ['sg_blur1(atd, ''' channels{c} spacer 'DECsv7_th2'', ''useGaussian'',1,''radius'',10,''filtersize'',100,''postblurthreshold'',3);']
	if doit,
		at_foreachdirdo(d,evalstr); end;
	end
end
