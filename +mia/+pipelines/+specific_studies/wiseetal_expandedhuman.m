

 % version 1
  % only pays attention to 80
mia.utilities.foreachdirdo(d_here([1 3 4 5 6 17 18]),'mia.pipelines.vh_rawhuman2filled(mdir, ''PSD_DEC'', ''PSD_ROI_KC'',''PSD_humanKCv1'',''plotthresholdestimate'',1,''t_levels'',[80 30]);')


mia.utilities.foreachdirdo(d_here([1 3 4 5 6 17 18]),'mia.pipelines.vh_rawhuman2filled(mdir, ''PSD_DEC'', ''PSD_ROI_KC'',''PSD_humanKCv2'',''plotthresholdestimate'',1,''t_levels'',[99 98]);')

mia.utilities.foreachdirdo(d_here([1 ]),'mia.pipelines.vh_rawhuman2filled(mdir, ''PSD_DEC'', ''PSD_ROI_KC'',''PSD_humanKCv2'',''plotthresholdestimate'',1,''t_levels'',[99 98]);')

mia.utilities.foreachdirdo(d_here([1 ]),'mia.pipelines.vh_rawhuman2filled(mdir, ''PSD_DEC'', ''PSD_ROI_KC'',''PSD_humanKCv3'',''plotthresholdestimate'',1,''t_levels'',[99.99 99.9]);')

 
