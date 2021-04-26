
d_here = d(1);


at_foreachdirdo(d_here,'vh_imageroi2roiroi(atd);')
at_foreachdirdo(d_here,'vh_pipepiece1(atd, ''PSD_DEC'', ''PSD_DECsv1'',''plotthresholdestimate'',1,''t_levels'',[80 30]);')
at_foreachdirdo(d_here,'vh_pipepiece1(atd, ''VG_DEC'', ''VG_DECsv1'',''plotthresholdestimate'',1,''t_levels'',[80 30]);')

at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''PSD_ROI_'', ''PSD_DECsv1_roiresvf'');')
at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''VG_ROI_'', ''VG_DECsv1_roiresvf'');')
at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''spine_ROI_'', ''PSD_DECsv1_roiresvf'',''useRes'',0);')
at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''spine_ROI_'', ''VG_DECsv1_roiresvf'',''useRes'',0);')

at_foreachdirdo(d_here,'vh_groundtruthcompare(atd,''PSD_DECsv1_roiresvf'',''spine_ROI_DLW_ROI'',''PSD_ROI_'');');
at_foreachdirdo(d_here,'vh_groundtruthcompare(atd,''VG_DECsv1_roiresvf'',''spine_ROI_DLW_ROI'',''VG_ROI_'');');


 
% image2roi - 1:6, 13:23,  errors in 7:12
% PSD_DECsv1 - 1:6, 13:23 in progress 

at_foreachdirdo(d_here,'vh_filter2tbrightness(atd,''PSD_DECsv1_roires'',''PSD_DECsv1_roiresbf'');');
at_foreachdirdo(d_here,'vh_filter2tbrightness(atd,''VG_DECsv1_roires'',''VG_DECsv1_roiresbf'');');
