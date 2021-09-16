# wiseetal_runnumber

```
  WISEETAL_RUNNUMBER - run a pipeline algorithm for Wise et al
 
  WISEETAL_RUNNUMBER(D, N, ...)
 
  D is a cell array of directory names of experiments
  N is the algorithm number to use. For example, 109
  
  The function takes name/value pairs that modify its behavior:
  ------------------------------------------------------------|
  | Parameter (default)     | Description                     |
  |-------------------------|---------------------------------|
  |doit (0)                 | Should we run the pipelines (1) |
  |                         |  or just print the commands we  |
  |                         |  would run (0)?                 |
  |doROIfinding (0)         | Should we discover ROIs (1)?    |
  |do_groundtruthanalysis(0)| Should we run ground truth      |
  |                         |  validation analysis?           |
  |spacer ('_')             | Are the images named 'PSD_DEC'  |
  |                         |  or PSDDEC? spacer is the       |
  |                         |  character in between. Use ''   |
  |                         |  for none.                      |
  |channels ({'PSD','VG'})  | Channels to run                 |
  |-------------------------|---------------------------------|
 
  Example:
     d = {'/Volumes/van-hooser-lab/Users/Derek/Synaptic Imaging/Cell fills/Full dataset/11-12-20 DLW/CTRL 1/analysis'}
     % or d = at_findalldirs('/Volumes/van-hooser-lab/Users/Derek/Synaptic Imaging/Cell fills/Full dataset')
     % use this to check it
     wiseetal_runnumber(d,109,'doit',0,'doROIfinding',1,'channels',{'PSD','VG','BAS'},'spacer','')
     % use this to run it!
     wiseetal_runnumber(d,109,'doit',0,'doROIfinding',1,'channels',{'PSD','VG','BAS'},'spacer','')

```
