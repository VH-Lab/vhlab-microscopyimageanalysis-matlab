
d_here = d(1);


at_foreachdirdo(d_here,'vh_imageroi2roiroi(atd);')
at_foreachdirdo(d_here,'vh_pipepiece1(atd, ''PSD_DEC'', ''PSD_DECsv1'',''plotthresholdestimate'',1,''t_levels'',[80 30]);')
at_foreachdirdo(d_here,'vh_pipepiece1(atd, ''VG_DEC'', ''VG_DECsv1'',''plotthresholdestimate'',1,''t_levels'',[80 30]);')

at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''PSD_ROI_'', ''PSD_DECsv1_roiresvf'');')
at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''VG_ROI_'', ''VG_DECsv1_roiresvf'');')
at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''spine_ROI_'', ''PSD_DECsv1_roiresvf'',''useRes'',0);')
at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''spine_ROI_'', ''VG_DECsv1_roiresvf'',''useRes'',0);')
at_foreachdirdo(d_here,'vh_coloc1(atd,''PSD_DECsv1_roiresvf'',''VG_DECsv1_roiresvf'',''PSD_DECsv1_roiresvf_X_VG_DECsv1_roiresvf'');');
at_foreachdirdo(d_here([1:6 11 13:16]),'vh_roicomparepipe(atd, ''spine_ROI_'', ''PSD_ROI_SG_ROIres'',''useRes'',0);')
at_foreachdirdo(d_here([1:6 11 13:16]),'vh_roicomparepipe(atd, ''spine_ROI_'', ''VG_ROI_SG_ROIres'',''useRes'',0);')
at_foreachdirdo(d_here([1 3:6 17 18]),'vh_roicomparepipe(atd, ''spine_ROI_'', ''PSD_ROI_KC_ROIres'',''useRes'',0);')
at_foreachdirdo(d_here([1 3:6 17 18]),'vh_roicomparepipe(atd, ''spine_ROI_'', ''VG_ROI_KC_ROIres'',''useRes'',0);')
at_foreachdirdo(d_here([7:10 12]),'vh_roicomparepipe(atd, ''spine_ROI_'', ''PSD_ROI_DW_ROIres'',''useRes'',0);')
at_foreachdirdo(d_here([7:10 12]),'vh_roicomparepipe(atd, ''spine_ROI_'', ''VG_ROI_DW_ROIres'',''useRes'',0);')


at_foreachdirdo(d_here([1:10 12]),'vh_groundtruthcompare(atd,''PSD_DECsv1_roiresvf'',''spine_ROI_DLW_ROI'',''PSD_ROI_'');');
at_foreachdirdo(d_here([11 13:16]),'vh_groundtruthcompare(atd,''PSD_DECsv1_roiresvf'',''spine_ROI_SG_ROI'',''PSD_ROI_'');');
at_foreachdirdo(d_here([17:18]),'vh_groundtruthcompare(atd,''PSD_DECsv1_roiresvf'',''spine_ROI_KC_ROI'',''PSD_ROI_'');');
at_foreachdirdo(d_here([1:10 12]),'vh_groundtruthcompare(atd,''VG_DECsv1_roiresvf'',''spine_ROI_DLW_ROI'',''VG_ROI_'');');
at_foreachdirdo(d_here([11 13:16]),'vh_groundtruthcompare(atd,''VG_DECsv1_roiresvf'',''spine_ROI_SG_ROI'',''VG_ROI_'');');
at_foreachdirdo(d_here([17 18]),'vh_groundtruthcompare(atd,''VG_DECsv1_roiresvf'',''spine_ROI_KC_ROI'',''VG_ROI_'');');



at_foreachdirdo(d_here([11 13:16]),'vh_groundtruthcompare(atd,''PSD_DECsv1_roiresvf'',''spine_ROI_SG_ROI'',''PSD_ROI_'');');
at_foreachdirdo(d_here([17:18]),'vh_groundtruthcompare(atd,''PSD_DECsv1_roiresvf'',''spine_ROI_KC_ROI'',''PSD_ROI_'');');
at_foreachdirdo(d_here([1:10 12]),'vh_groundtruthcompare(atd,''VG_DECsv1_roiresvf'',''spine_ROI_DLW_ROI'',''VG_ROI_'');');
at_foreachdirdo(d_here([11 13:16]),'vh_groundtruthcompare(atd,''VG_DECsv1_roiresvf'',''spine_ROI_SG_ROI'',''VG_ROI_'');');
at_foreachdirdo(d_here([17 18]),'vh_groundtruthcompare(atd,''VG_DECsv1_roiresvf'',''spine_ROI_KC_ROI'',''VG_ROI_'');');


 % analyzing human data
at_foreachdirdo(d_here([1 3:6 17 18]),'vh_coloc1(atd,''PSD_ROI_KC_ROIres'',''VG_ROI_KC_ROIres'',''PSD_ROI_KC_ROIres_x_VG_ROI_KC_ROIres'');');
at_foreachdirdo(d_here([1:6 11:16]),'vh_coloc1(atd,''PSD_ROI_SG_ROIres'',''VG_ROI_SG_ROIres'',''PSD_ROI_SG_ROIres_x_VG_ROI_SG_ROIres'');');
at_foreachdirdo(d_here([7:10 12]),'vh_coloc1(atd,''PSD_ROI_DW_ROIres'',''VG_ROI_DW_ROIres'',''PSD_ROI_DW_ROIres_x_VG_ROI_DW_ROIres'');');

% image2roi - 1:6, 13:23,  errors in 7:12
% PSD_DECsv1 - 1:6, 13:23 in progress 

% algorithm 101

at_foreachdirdo(d_here,'vh_filter2tbrightness(atd,''PSD_DECsv1_roires'',''PSD_DECsv1_roiresbf'');');
at_foreachdirdo(d_here,'vh_filter2tbrightness(atd,''VG_DECsv1_roires'',''VG_DECsv1_roiresbf'');');

at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''PSD_ROI_'', ''PSD_DECsv1_roiresbf'');')
at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''VG_ROI_'', ''VG_DECsv1_roiresbf'');')
at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''spine_ROI_'', ''PSD_DECsv1_roiresbf'',''useRes'',0);')
at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''spine_ROI_'', ''VG_DECsv1_roiresbf'',''useRes'',0);')
at_foreachdirdo(d_here,'vh_coloc1(atd,''PSD_DECsv1_roiresbf'',''VG_DECsv1_roiresbf'',''PSD_DECsv1_roiresbf_X_VG_DECsv1_roiresbf'');');

at_foreachdirdo(d_here([1:10 12]),'vh_groundtruthcompare(atd,''PSD_DECsv1_roiresbf'',''spine_ROI_DLW_ROI'',''PSD_ROI_'');');
at_foreachdirdo(d_here([11 13:16]),'vh_groundtruthcompare(atd,''PSD_DECsv1_roiresbf'',''spine_ROI_SG_ROI'',''PSD_ROI_'');');
at_foreachdirdo(d_here([17:18]),'vh_groundtruthcompare(atd,''PSD_DECsv1_roiresbf'',''spine_ROI_KC_ROI'',''PSD_ROI_'');');
at_foreachdirdo(d_here([1:10 12]),'vh_groundtruthcompare(atd,''VG_DECsv1_roiresbf'',''spine_ROI_DLW_ROI'',''VG_ROI_'');');
at_foreachdirdo(d_here([11 13:16]),'vh_groundtruthcompare(atd,''VG_DECsv1_roiresbf'',''spine_ROI_SG_ROI'',''VG_ROI_'');');
at_foreachdirdo(d_here([17 18]),'vh_groundtruthcompare(atd,''VG_DECsv1_roiresbf'',''spine_ROI_KC_ROI'',''VG_ROI_'');');


% algorithm 102

at_foreachdirdo(d_here,'vh_pipepiece1(atd, ''PSD_DEC'', ''PSD_DECsv2'',''plotthresholdestimate'',1,''t_levels'',[90 30]);')
at_foreachdirdo(d_here,'vh_pipepiece1(atd, ''VG_DEC'', ''VG_DECsv2'',''plotthresholdestimate'',1,''t_levels'',[90 30]);')


at_foreachdirdo(d_here,'vh_filter2tbrightness(atd,''PSD_DECsv2_roires'',''PSD_DECsv2_roiresbf'');');
at_foreachdirdo(d_here,'vh_filter2tbrightness(atd,''VG_DECsv2_roires'',''VG_DECsv2_roiresbf'');');


at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''PSD_ROI_'', ''PSD_DECsv2_roiresbf'');')
at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''VG_ROI_'', ''VG_DECsv2_roiresbf'');')
at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''spine_ROI_'', ''PSD_DECsv2_roiresbf'',''useRes'',0);')
at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''spine_ROI_'', ''VG_DECsv2_roiresbf'',''useRes'',0);')
at_foreachdirdo(d_here,'vh_coloc1(atd,''PSD_DECsv2_roiresbf'',''VG_DECsv2_roiresbf'',''PSD_DECsv2_roiresbf_X_VG_DECsv2_roiresbf'');');

at_foreachdirdo(d_here([1:10 12]),'vh_groundtruthcompare(atd,''PSD_DECsv2_roiresbf'',''spine_ROI_DLW_ROI'',''PSD_ROI_'');');
at_foreachdirdo(d_here([11 13:16]),'vh_groundtruthcompare(atd,''PSD_DECsv2_roiresbf'',''spine_ROI_SG_ROI'',''PSD_ROI_'');');
at_foreachdirdo(d_here([17:18]),'vh_groundtruthcompare(atd,''PSD_DECsv2_roiresbf'',''spine_ROI_KC_ROI'',''PSD_ROI_'');');
at_foreachdirdo(d_here([1:10 12]),'vh_groundtruthcompare(atd,''VG_DECsv2_roiresbf'',''spine_ROI_DLW_ROI'',''VG_ROI_'');');
at_foreachdirdo(d_here([11 13:16]),'vh_groundtruthcompare(atd,''VG_DECsv2_roiresbf'',''spine_ROI_SG_ROI'',''VG_ROI_'');');
at_foreachdirdo(d_here([17 18]),'vh_groundtruthcompare(atd,''VG_DECsv2_roiresbf'',''spine_ROI_KC_ROI'',''VG_ROI_'');');

at_foreachdirdo(d_here([1 3:6]),'vh_groundtruthcompareC(atd,''spine_ROI_DLW_ROI'', ''PSD_DECsv2_roiresbf'',''PSD_ROI_KC_ROIres'', ''VG_DECsv2_roiresbf'',''VG_ROI_KC_ROIres'');');
at_foreachdirdo(d_here([17 18]),'vh_groundtruthcompareC(atd,''spine_ROI_KC_ROI'', ''PSD_DECsv2_roiresbf'',''PSD_ROI_KC_ROIres'', ''VG_DECsv2_roiresbf'',''VG_ROI_KC_ROIres'');');
at_foreachdirdo(d_here([1:6]),'vh_groundtruthcompareC(atd,''spine_ROI_DLW_ROI'', ''PSD_DECsv2_roiresbf'',''PSD_ROI_SG_ROIres'', ''VG_DECsv2_roiresbf'',''VG_ROI_SG_ROIres'');');
at_foreachdirdo(d_here([11 13:16]),'vh_groundtruthcompareC(atd,''spine_ROI_SG_ROI'', ''PSD_DECsv2_roiresbf'',''PSD_ROI_SG_ROIres'', ''VG_DECsv2_roiresbf'',''VG_ROI_SG_ROIres'');');
at_foreachdirdo(d_here([7:10 12 ]),'vh_groundtruthcompareC(atd,''spine_ROI_DLW_ROI'', ''PSD_DECsv2_roiresbf'',''PSD_ROI_DW_ROIres'', ''VG_DECsv2_roiresbf'',''VG_ROI_DW_ROIres'');');


% algorithm 103 
at_foreachdirdo(d_here,'vh_pipepiece1(atd, ''PSD_DEC'', ''PSD_DECsv3'',''plotthresholdestimate'',1,''t_levels'',[95 30]);')
at_foreachdirdo(d_here,'vh_pipepiece1(atd, ''VG_DEC'', ''VG_DECsv3'',''plotthresholdestimate'',1,''t_levels'',[95 30]);')


at_foreachdirdo(d_here,'vh_filter2tbrightness(atd,''PSD_DECsv3_roires'',''PSD_DECsv3_roiresbf'');');
at_foreachdirdo(d_here,'vh_filter2tbrightness(atd,''VG_DECsv3_roires'',''VG_DECsv3_roiresbf'');');


at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''PSD_ROI_'', ''PSD_DECsv3_roiresbf'');')
at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''VG_ROI_'', ''VG_DECsv3_roiresbf'');')
at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''spine_ROI_'', ''PSD_DECsv3_roiresbf'',''useRes'',0);')
at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''spine_ROI_'', ''VG_DECsv3_roiresbf'',''useRes'',0);')
at_foreachdirdo(d_here,'vh_coloc1(atd,''PSD_DECsv3_roiresbf'',''VG_DECsv3_roiresbf'',''PSD_DECsv3_roiresbf_X_VG_DECsv3_roiresbf'');');

at_foreachdirdo(d_here([1:10 12]),'vh_groundtruthcompare(atd,''PSD_DECsv3_roiresbf'',''spine_ROI_DLW_ROI'',''PSD_ROI_'');');
at_foreachdirdo(d_here([11 13:16]),'vh_groundtruthcompare(atd,''PSD_DECsv3_roiresbf'',''spine_ROI_SG_ROI'',''PSD_ROI_'');');
at_foreachdirdo(d_here([17:18]),'vh_groundtruthcompare(atd,''PSD_DECsv3_roiresbf'',''spine_ROI_KC_ROI'',''PSD_ROI_'');');
at_foreachdirdo(d_here([1:10 12]),'vh_groundtruthcompare(atd,''VG_DECsv3_roiresbf'',''spine_ROI_DLW_ROI'',''VG_ROI_'');');
at_foreachdirdo(d_here([11 13:16]),'vh_groundtruthcompare(atd,''VG_DECsv3_roiresbf'',''spine_ROI_SG_ROI'',''VG_ROI_'');');
at_foreachdirdo(d_here([17 18]),'vh_groundtruthcompare(atd,''VG_DECsv3_roiresbf'',''spine_ROI_KC_ROI'',''VG_ROI_'');');

at_foreachdirdo(d_here([1 3:6]),'vh_groundtruthcompareC(atd,''spine_ROI_DLW_ROI'', ''PSD_DECsv3_roiresbf'',''PSD_ROI_KC_ROIres'', ''VG_DECsv3_roiresbf'',''VG_ROI_KC_ROIres'');');
at_foreachdirdo(d_here([17 18]),'vh_groundtruthcompareC(atd,''spine_ROI_KC_ROI'', ''PSD_DECsv3_roiresbf'',''PSD_ROI_KC_ROIres'', ''VG_DECsv3_roiresbf'',''VG_ROI_KC_ROIres'');');
at_foreachdirdo(d_here([1:6]),'vh_groundtruthcompareC(atd,''spine_ROI_DLW_ROI'', ''PSD_DECsv3_roiresbf'',''PSD_ROI_SG_ROIres'', ''VG_DECsv3_roiresbf'',''VG_ROI_SG_ROIres'');');
at_foreachdirdo(d_here([11 13:16]),'vh_groundtruthcompareC(atd,''spine_ROI_SG_ROI'', ''PSD_DECsv3_roiresbf'',''PSD_ROI_SG_ROIres'', ''VG_DECsv3_roiresbf'',''VG_ROI_SG_ROIres'');');
at_foreachdirdo(d_here([7:10 12 ]),'vh_groundtruthcompareC(atd,''spine_ROI_DLW_ROI'', ''PSD_DECsv3_roiresbf'',''PSD_ROI_DW_ROIres'', ''VG_DECsv3_roiresbf'',''VG_ROI_DW_ROIres'');');


% algorithm 104 
at_foreachdirdo(d_here,'vh_pipepiece1(atd, ''PSD_DEC'', ''PSD_DECsv4'',''plotthresholdestimate'',1,''t_levels'',[97.5 30]);')
at_foreachdirdo(d_here,'vh_pipepiece1(atd, ''VG_DEC'', ''VG_DECsv4'',''plotthresholdestimate'',1,''t_levels'',[97.5 30]);')


at_foreachdirdo(d_here,'vh_filter2tbrightness(atd,''PSD_DECsv4_roires'',''PSD_DECsv4_roiresbf'');');
at_foreachdirdo(d_here,'vh_filter2tbrightness(atd,''VG_DECsv4_roires'',''VG_DECsv4_roiresbf'');');


at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''PSD_ROI_'', ''PSD_DECsv4_roiresbf'');')
at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''VG_ROI_'', ''VG_DECsv4_roiresbf'');')
at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''spine_ROI_'', ''PSD_DECsv4_roiresbf'',''useRes'',0);')
at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''spine_ROI_'', ''VG_DECsv4_roiresbf'',''useRes'',0);')
at_foreachdirdo(d_here,'vh_coloc1(atd,''PSD_DECsv4_roiresbf'',''VG_DECsv4_roiresbf'',''PSD_DECsv4_roiresbf_X_VG_DECsv4_roiresbf'');');

at_foreachdirdo(d_here([1:10 12]),'vh_groundtruthcompare(atd,''PSD_DECsv4_roiresbf'',''spine_ROI_DLW_ROI'',''PSD_ROI_'');');
at_foreachdirdo(d_here([11 13:16]),'vh_groundtruthcompare(atd,''PSD_DECsv4_roiresbf'',''spine_ROI_SG_ROI'',''PSD_ROI_'');');
at_foreachdirdo(d_here([17:18]),'vh_groundtruthcompare(atd,''PSD_DECsv4_roiresbf'',''spine_ROI_KC_ROI'',''PSD_ROI_'');');
at_foreachdirdo(d_here([1:10 12]),'vh_groundtruthcompare(atd,''VG_DECsv4_roiresbf'',''spine_ROI_DLW_ROI'',''VG_ROI_'');');
at_foreachdirdo(d_here([11 13:16]),'vh_groundtruthcompare(atd,''VG_DECsv4_roiresbf'',''spine_ROI_SG_ROI'',''VG_ROI_'');');
at_foreachdirdo(d_here([17 18]),'vh_groundtruthcompare(atd,''VG_DECsv4_roiresbf'',''spine_ROI_KC_ROI'',''VG_ROI_'');');

at_foreachdirdo(d_here([1 3:6]),'vh_groundtruthcompareC(atd,''spine_ROI_DLW_ROI'', ''PSD_DECsv4_roiresbf'',''PSD_ROI_KC_ROIres'', ''VG_DECsv4_roiresbf'',''VG_ROI_KC_ROIres'');');
at_foreachdirdo(d_here([17 18]),'vh_groundtruthcompareC(atd,''spine_ROI_KC_ROI'', ''PSD_DECsv4_roiresbf'',''PSD_ROI_KC_ROIres'', ''VG_DECsv4_roiresbf'',''VG_ROI_KC_ROIres'');');
at_foreachdirdo(d_here([1:6]),'vh_groundtruthcompareC(atd,''spine_ROI_DLW_ROI'', ''PSD_DECsv4_roiresbf'',''PSD_ROI_SG_ROIres'', ''VG_DECsv4_roiresbf'',''VG_ROI_SG_ROIres'');');
at_foreachdirdo(d_here([11 13:16]),'vh_groundtruthcompareC(atd,''spine_ROI_SG_ROI'', ''PSD_DECsv4_roiresbf'',''PSD_ROI_SG_ROIres'', ''VG_DECsv4_roiresbf'',''VG_ROI_SG_ROIres'');');
at_foreachdirdo(d_here([7:10 12 ]),'vh_groundtruthcompareC(atd,''spine_ROI_DLW_ROI'', ''PSD_DECsv4_roiresbf'',''PSD_ROI_DW_ROIres'', ''VG_DECsv4_roiresbf'',''VG_ROI_DW_ROIres'');');

% algorithm 105 
at_foreachdirdo(d_here,'vh_pipepiece1(atd, ''PSD_DEC'', ''PSD_DECsv5'',''plotthresholdestimate'',1,''t_levels'',[99 30]);')
at_foreachdirdo(d_here,'vh_pipepiece1(atd, ''VG_DEC'', ''VG_DECsv5'',''plotthresholdestimate'',1,''t_levels'',[99 30]);')


at_foreachdirdo(d_here,'vh_filter2tbrightness(atd,''PSD_DECsv5_roires'',''PSD_DECsv5_roiresbf'');');
at_foreachdirdo(d_here,'vh_filter2tbrightness(atd,''VG_DECsv5_roires'',''VG_DECsv5_roiresbf'');');


at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''PSD_ROI_'', ''PSD_DECsv5_roiresbf'');')
at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''VG_ROI_'', ''VG_DECsv5_roiresbf'');')
at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''spine_ROI_'', ''PSD_DECsv5_roiresbf'',''useRes'',0);')
at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''spine_ROI_'', ''VG_DECsv5_roiresbf'',''useRes'',0);')
at_foreachdirdo(d_here,'vh_coloc1(atd,''PSD_DECsv5_roiresbf'',''VG_DECsv5_roiresbf'',''PSD_DECsv5_roiresbf_X_VG_DECsv5_roiresbf'');');

at_foreachdirdo(d_here([1:10 12]),'vh_groundtruthcompare(atd,''PSD_DECsv5_roiresbf'',''spine_ROI_DLW_ROI'',''PSD_ROI_'');');
at_foreachdirdo(d_here([11 13:16]),'vh_groundtruthcompare(atd,''PSD_DECsv5_roiresbf'',''spine_ROI_SG_ROI'',''PSD_ROI_'');');
at_foreachdirdo(d_here([17:18]),'vh_groundtruthcompare(atd,''PSD_DECsv5_roiresbf'',''spine_ROI_KC_ROI'',''PSD_ROI_'');');
at_foreachdirdo(d_here([1:10 12]),'vh_groundtruthcompare(atd,''VG_DECsv5_roiresbf'',''spine_ROI_DLW_ROI'',''VG_ROI_'');');
at_foreachdirdo(d_here([11 13:16]),'vh_groundtruthcompare(atd,''VG_DECsv5_roiresbf'',''spine_ROI_SG_ROI'',''VG_ROI_'');');
at_foreachdirdo(d_here([17 18]),'vh_groundtruthcompare(atd,''VG_DECsv5_roiresbf'',''spine_ROI_KC_ROI'',''VG_ROI_'');');

at_foreachdirdo(d_here([1 3:6]),'vh_groundtruthcompareC(atd,''spine_ROI_DLW_ROI'', ''PSD_DECsv5_roiresbf'',''PSD_ROI_KC_ROIres'', ''VG_DECsv5_roiresbf'',''VG_ROI_KC_ROIres'');');
at_foreachdirdo(d_here([17 18]),'vh_groundtruthcompareC(atd,''spine_ROI_KC_ROI'', ''PSD_DECsv5_roiresbf'',''PSD_ROI_KC_ROIres'', ''VG_DECsv5_roiresbf'',''VG_ROI_KC_ROIres'');');
at_foreachdirdo(d_here([1:6]),'vh_groundtruthcompareC(atd,''spine_ROI_DLW_ROI'', ''PSD_DECsv5_roiresbf'',''PSD_ROI_SG_ROIres'', ''VG_DECsv5_roiresbf'',''VG_ROI_SG_ROIres'');');
at_foreachdirdo(d_here([11 13:16]),'vh_groundtruthcompareC(atd,''spine_ROI_SG_ROI'', ''PSD_DECsv5_roiresbf'',''PSD_ROI_SG_ROIres'', ''VG_DECsv5_roiresbf'',''VG_ROI_SG_ROIres'');');
at_foreachdirdo(d_here([7:10 12 ]),'vh_groundtruthcompareC(atd,''spine_ROI_DLW_ROI'', ''PSD_DECsv5_roiresbf'',''PSD_ROI_DW_ROIres'', ''VG_DECsv5_roiresbf'',''VG_ROI_DW_ROIres'');');

% algorithm 106 
at_foreachdirdo(d_here,'vh_pipepiece1(atd, ''PSD_DEC'', ''PSD_DECsv6'',''plotthresholdestimate'',1,''t_levels'',[97.5 80]);')
at_foreachdirdo(d_here,'vh_pipepiece1(atd, ''VG_DEC'', ''VG_DECsv6'',''plotthresholdestimate'',1,''t_levels'',[97.5 80]);')


at_foreachdirdo(d_here,'vh_filter2tbrightness(atd,''PSD_DECsv6_roires'',''PSD_DECsv6_roiresbf'');');
at_foreachdirdo(d_here,'vh_filter2tbrightness(atd,''VG_DECsv6_roires'',''VG_DECsv6_roiresbf'');');


at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''PSD_ROI_'', ''PSD_DECsv6_roiresbf'');')
at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''VG_ROI_'', ''VG_DECsv6_roiresbf'');')
at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''spine_ROI_'', ''PSD_DECsv6_roiresbf'',''useRes'',0);')
at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''spine_ROI_'', ''VG_DECsv6_roiresbf'',''useRes'',0);')
at_foreachdirdo(d_here,'vh_coloc1(atd,''PSD_DECsv6_roiresbf'',''VG_DECsv6_roiresbf'',''PSD_DECsv6_roiresbf_X_VG_DECsv6_roiresbf'');');

at_foreachdirdo(d_here([1:10 12]),'vh_groundtruthcompare(atd,''PSD_DECsv6_roiresbf'',''spine_ROI_DLW_ROI'',''PSD_ROI_'');');
at_foreachdirdo(d_here([11 13:16]),'vh_groundtruthcompare(atd,''PSD_DECsv6_roiresbf'',''spine_ROI_SG_ROI'',''PSD_ROI_'');');
at_foreachdirdo(d_here([17:18]),'vh_groundtruthcompare(atd,''PSD_DECsv6_roiresbf'',''spine_ROI_KC_ROI'',''PSD_ROI_'');');
at_foreachdirdo(d_here([1:10 12]),'vh_groundtruthcompare(atd,''VG_DECsv6_roiresbf'',''spine_ROI_DLW_ROI'',''VG_ROI_'');');
at_foreachdirdo(d_here([11 13:16]),'vh_groundtruthcompare(atd,''VG_DECsv6_roiresbf'',''spine_ROI_SG_ROI'',''VG_ROI_'');');
at_foreachdirdo(d_here([17 18]),'vh_groundtruthcompare(atd,''VG_DECsv6_roiresbf'',''spine_ROI_KC_ROI'',''VG_ROI_'');');

at_foreachdirdo(d_here([1 3:6]),'vh_groundtruthcompareC(atd,''spine_ROI_DLW_ROI'', ''PSD_DECsv6_roiresbf'',''PSD_ROI_KC_ROIres'', ''VG_DECsv6_roiresbf'',''VG_ROI_KC_ROIres'');');
at_foreachdirdo(d_here([17 18]),'vh_groundtruthcompareC(atd,''spine_ROI_KC_ROI'', ''PSD_DECsv6_roiresbf'',''PSD_ROI_KC_ROIres'', ''VG_DECsv6_roiresbf'',''VG_ROI_KC_ROIres'');');
at_foreachdirdo(d_here([1:6]),'vh_groundtruthcompareC(atd,''spine_ROI_DLW_ROI'', ''PSD_DECsv6_roiresbf'',''PSD_ROI_SG_ROIres'', ''VG_DECsv6_roiresbf'',''VG_ROI_SG_ROIres'');');
at_foreachdirdo(d_here([11 13:16]),'vh_groundtruthcompareC(atd,''spine_ROI_SG_ROI'', ''PSD_DECsv6_roiresbf'',''PSD_ROI_SG_ROIres'', ''VG_DECsv6_roiresbf'',''VG_ROI_SG_ROIres'');');
at_foreachdirdo(d_here([7:10 12 ]),'vh_groundtruthcompareC(atd,''spine_ROI_DLW_ROI'', ''PSD_DECsv6_roiresbf'',''PSD_ROI_DW_ROIres'', ''VG_DECsv6_roiresbf'',''VG_ROI_DW_ROIres'');');

% algorithm 107 
at_foreachdirdo(d_here,'vh_pipepiece1(atd, ''PSD_DEC'', ''PSD_DECsv7'',''plotthresholdestimate'',1,''t_levels'',[99 80]);')
at_foreachdirdo(d_here,'vh_pipepiece1(atd, ''VG_DEC'', ''VG_DECsv7'',''plotthresholdestimate'',1,''t_levels'',[99 80]);')


at_foreachdirdo(d_here,'vh_filter2tbrightness(atd,''PSD_DECsv7_roires'',''PSD_DECsv7_roiresbf'');');
at_foreachdirdo(d_here,'vh_filter2tbrightness(atd,''VG_DECsv7_roires'',''VG_DECsv7_roiresbf'');');


at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''PSD_ROI_'', ''PSD_DECsv7_roiresbf'');')
at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''VG_ROI_'', ''VG_DECsv7_roiresbf'');')
at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''spine_ROI_'', ''PSD_DECsv7_roiresbf'',''useRes'',0);')
at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''spine_ROI_'', ''VG_DECsv7_roiresbf'',''useRes'',0);')
at_foreachdirdo(d_here,'vh_coloc1(atd,''PSD_DECsv7_roiresbf'',''VG_DECsv7_roiresbf'',''PSD_DECsv7_roiresbf_X_VG_DECsv7_roiresbf'');');

at_foreachdirdo(d_here([1:10 12]),'vh_groundtruthcompare(atd,''PSD_DECsv7_roiresbf'',''spine_ROI_DLW_ROI'',''PSD_ROI_'');');
at_foreachdirdo(d_here([11 13:16]),'vh_groundtruthcompare(atd,''PSD_DECsv7_roiresbf'',''spine_ROI_SG_ROI'',''PSD_ROI_'');');
at_foreachdirdo(d_here([17:18]),'vh_groundtruthcompare(atd,''PSD_DECsv7_roiresbf'',''spine_ROI_KC_ROI'',''PSD_ROI_'');');
at_foreachdirdo(d_here([1:10 12]),'vh_groundtruthcompare(atd,''VG_DECsv7_roiresbf'',''spine_ROI_DLW_ROI'',''VG_ROI_'');');
at_foreachdirdo(d_here([11 13:16]),'vh_groundtruthcompare(atd,''VG_DECsv7_roiresbf'',''spine_ROI_SG_ROI'',''VG_ROI_'');');
at_foreachdirdo(d_here([17 18]),'vh_groundtruthcompare(atd,''VG_DECsv7_roiresbf'',''spine_ROI_KC_ROI'',''VG_ROI_'');');

at_foreachdirdo(d_here([1 3:6]),'vh_groundtruthcompareC(atd,''spine_ROI_DLW_ROI'', ''PSD_DECsv7_roiresbf'',''PSD_ROI_KC_ROIres'', ''VG_DECsv7_roiresbf'',''VG_ROI_KC_ROIres'');');
at_foreachdirdo(d_here([17 18]),'vh_groundtruthcompareC(atd,''spine_ROI_KC_ROI'', ''PSD_DECsv7_roiresbf'',''PSD_ROI_KC_ROIres'', ''VG_DECsv7_roiresbf'',''VG_ROI_KC_ROIres'');');
at_foreachdirdo(d_here([1:6]),'vh_groundtruthcompareC(atd,''spine_ROI_DLW_ROI'', ''PSD_DECsv7_roiresbf'',''PSD_ROI_SG_ROIres'', ''VG_DECsv7_roiresbf'',''VG_ROI_SG_ROIres'');');
at_foreachdirdo(d_here([11 13:16]),'vh_groundtruthcompareC(atd,''spine_ROI_SG_ROI'', ''PSD_DECsv7_roiresbf'',''PSD_ROI_SG_ROIres'', ''VG_DECsv7_roiresbf'',''VG_ROI_SG_ROIres'');');
at_foreachdirdo(d_here([7:10 12 ]),'vh_groundtruthcompareC(atd,''spine_ROI_DLW_ROI'', ''PSD_DECsv7_roiresbf'',''PSD_ROI_DW_ROIres'', ''VG_DECsv7_roiresbf'',''VG_ROI_DW_ROIres'');');

% algorithm 108 
at_foreachdirdo(d_here,'vh_pipepiece1(atd, ''PSD_DEC'', ''PSD_DECsv8'',''plotthresholdestimate'',1,''t_levels'',[99.9 80]);')
at_foreachdirdo(d_here,'vh_pipepiece1(atd, ''VG_DEC'', ''VG_DECsv8'',''plotthresholdestimate'',1,''t_levels'',[99.9 80]);')


at_foreachdirdo(d_here,'vh_filter2tbrightness(atd,''PSD_DECsv8_roires'',''PSD_DECsv8_roiresbf'');');
at_foreachdirdo(d_here,'vh_filter2tbrightness(atd,''VG_DECsv8_roires'',''VG_DECsv8_roiresbf'');');


at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''PSD_ROI_'', ''PSD_DECsv8_roiresbf'');')
at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''VG_ROI_'', ''VG_DECsv8_roiresbf'');')
at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''spine_ROI_'', ''PSD_DECsv8_roiresbf'',''useRes'',0);')
at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''spine_ROI_'', ''VG_DECsv8_roiresbf'',''useRes'',0);')
at_foreachdirdo(d_here,'vh_coloc1(atd,''PSD_DECsv8_roiresbf'',''VG_DECsv8_roiresbf'',''PSD_DECsv8_roiresbf_X_VG_DECsv8_roiresbf'');');

at_foreachdirdo(d_here([1:10 12]),'vh_groundtruthcompare(atd,''PSD_DECsv8_roiresbf'',''spine_ROI_DLW_ROI'',''PSD_ROI_'');');
at_foreachdirdo(d_here([11 13:16]),'vh_groundtruthcompare(atd,''PSD_DECsv8_roiresbf'',''spine_ROI_SG_ROI'',''PSD_ROI_'');');
at_foreachdirdo(d_here([17:18]),'vh_groundtruthcompare(atd,''PSD_DECsv8_roiresbf'',''spine_ROI_KC_ROI'',''PSD_ROI_'');');
at_foreachdirdo(d_here([1:10 12]),'vh_groundtruthcompare(atd,''VG_DECsv8_roiresbf'',''spine_ROI_DLW_ROI'',''VG_ROI_'');');
at_foreachdirdo(d_here([11 13:16]),'vh_groundtruthcompare(atd,''VG_DECsv8_roiresbf'',''spine_ROI_SG_ROI'',''VG_ROI_'');');
at_foreachdirdo(d_here([17 18]),'vh_groundtruthcompare(atd,''VG_DECsv8_roiresbf'',''spine_ROI_KC_ROI'',''VG_ROI_'');');

at_foreachdirdo(d_here([1 3:6]),'vh_groundtruthcompareC(atd,''spine_ROI_DLW_ROI'', ''PSD_DECsv8_roiresbf'',''PSD_ROI_KC_ROIres'', ''VG_DECsv8_roiresbf'',''VG_ROI_KC_ROIres'');');
at_foreachdirdo(d_here([17 18]),'vh_groundtruthcompareC(atd,''spine_ROI_KC_ROI'', ''PSD_DECsv8_roiresbf'',''PSD_ROI_KC_ROIres'', ''VG_DECsv8_roiresbf'',''VG_ROI_KC_ROIres'');');
at_foreachdirdo(d_here([1:6]),'vh_groundtruthcompareC(atd,''spine_ROI_DLW_ROI'', ''PSD_DECsv8_roiresbf'',''PSD_ROI_SG_ROIres'', ''VG_DECsv8_roiresbf'',''VG_ROI_SG_ROIres'');');
at_foreachdirdo(d_here([11 13:16]),'vh_groundtruthcompareC(atd,''spine_ROI_SG_ROI'', ''PSD_DECsv8_roiresbf'',''PSD_ROI_SG_ROIres'', ''VG_DECsv8_roiresbf'',''VG_ROI_SG_ROIres'');');
at_foreachdirdo(d_here([7:10 12 ]),'vh_groundtruthcompareC(atd,''spine_ROI_DLW_ROI'', ''PSD_DECsv8_roiresbf'',''PSD_ROI_DW_ROIres'', ''VG_DECsv8_roiresbf'',''VG_ROI_DW_ROIres'');');

% algorithm 109 
at_foreachdirdo(d_here,'vh_pipepiece1(atd, ''PSD_DEC'', ''PSD_DECsv9'',''plotthresholdestimate'',1,''t_levels'',[99.99 97]);')
at_foreachdirdo(d_here,'vh_pipepiece1(atd, ''VG_DEC'', ''VG_DECsv9'',''plotthresholdestimate'',1,''t_levels'',[99.99 97]);')


at_foreachdirdo(d_here,'vh_filter2tbrightness(atd,''PSD_DECsv9_roires'',''PSD_DECsv9_roiresbf'');');
at_foreachdirdo(d_here,'vh_filter2tbrightness(atd,''VG_DECsv9_roires'',''VG_DECsv9_roiresbf'');');


at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''PSD_ROI_'', ''PSD_DECsv9_roiresbf'');')
at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''VG_ROI_'', ''VG_DECsv9_roiresbf'');')
at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''spine_ROI_'', ''PSD_DECsv9_roiresbf'',''useRes'',0);')
at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''spine_ROI_'', ''VG_DECsv9_roiresbf'',''useRes'',0);')

at_foreachdirdo(d_here,'vh_coloc1(atd,''PSD_DECsv9_roiresbf'',''VG_DECsv9_roiresbf'',''PSD_DECsv9_roiresbf_X_VG_DECsv9_roiresbf'');');

at_foreachdirdo(d_here([1:10 12]),'vh_groundtruthcompare(atd,''PSD_DECsv9_roiresbf'',''spine_ROI_DLW_ROI'',''PSD_ROI_'');');
at_foreachdirdo(d_here([11 13:16]),'vh_groundtruthcompare(atd,''PSD_DECsv9_roiresbf'',''spine_ROI_SG_ROI'',''PSD_ROI_'');');
at_foreachdirdo(d_here([17:18]),'vh_groundtruthcompare(atd,''PSD_DECsv9_roiresbf'',''spine_ROI_KC_ROI'',''PSD_ROI_'');');
at_foreachdirdo(d_here([1:10 12]),'vh_groundtruthcompare(atd,''VG_DECsv9_roiresbf'',''spine_ROI_DLW_ROI'',''VG_ROI_'');');
at_foreachdirdo(d_here([11 13:16]),'vh_groundtruthcompare(atd,''VG_DECsv9_roiresbf'',''spine_ROI_SG_ROI'',''VG_ROI_'');');
at_foreachdirdo(d_here([17 18]),'vh_groundtruthcompare(atd,''VG_DECsv9_roiresbf'',''spine_ROI_KC_ROI'',''VG_ROI_'');');


at_foreachdirdo(d_here([1 3:6]),'vh_groundtruthcompareC(atd,''spine_ROI_DLW_ROI'', ''PSD_DECsv9_roiresbf'',''PSD_ROI_KC_ROIres'', ''VG_DECsv9_roiresbf'',''VG_ROI_KC_ROIres'');');
at_foreachdirdo(d_here([17 18]),'vh_groundtruthcompareC(atd,''spine_ROI_KC_ROI'', ''PSD_DECsv9_roiresbf'',''PSD_ROI_KC_ROIres'', ''VG_DECsv9_roiresbf'',''VG_ROI_KC_ROIres'');');
at_foreachdirdo(d_here([1:6]),'vh_groundtruthcompareC(atd,''spine_ROI_DLW_ROI'', ''PSD_DECsv9_roiresbf'',''PSD_ROI_SG_ROIres'', ''VG_DECsv9_roiresbf'',''VG_ROI_SG_ROIres'');');
at_foreachdirdo(d_here([11 13:16]),'vh_groundtruthcompareC(atd,''spine_ROI_SG_ROI'', ''PSD_DECsv9_roiresbf'',''PSD_ROI_SG_ROIres'', ''VG_DECsv9_roiresbf'',''VG_ROI_SG_ROIres'');');
at_foreachdirdo(d_here([7:10 12 ]),'vh_groundtruthcompareC(atd,''spine_ROI_DLW_ROI'', ''PSD_DECsv9_roiresbf'',''PSD_ROI_DW_ROIres'', ''VG_DECsv9_roiresbf'',''VG_ROI_DW_ROIres'');');


% algorithm 110 
at_foreachdirdo(d_here,'vh_pipepiece1(atd, ''PSD_DEC'', ''PSD_DECsv10'',''plotthresholdestimate'',1,''t_levels'',[99.999 98]);')
at_foreachdirdo(d_here,'vh_pipepiece1(atd, ''VG_DEC'', ''VG_DECsv10'',''plotthresholdestimate'',1,''t_levels'',[99.999 98]);')


at_foreachdirdo(d_here,'vh_filter2tbrightness(atd,''PSD_DECsv10_roires'',''PSD_DECsv10_roiresbf'');');
at_foreachdirdo(d_here,'vh_filter2tbrightness(atd,''VG_DECsv10_roires'',''VG_DECsv10_roiresbf'');');


at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''PSD_ROI_'', ''PSD_DECsv10_roiresbf'');')
at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''VG_ROI_'', ''VG_DECsv10_roiresbf'');')
at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''spine_ROI_'', ''PSD_DECsv10_roiresbf'',''useRes'',0);')
at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''spine_ROI_'', ''VG_DECsv10_roiresbf'',''useRes'',0);')

at_foreachdirdo(d_here,'vh_coloc1(atd,''PSD_DECsv10_roiresbf'',''VG_DECsv10_roiresbf'',''PSD_DECsv10_roiresbf_X_VG_DECsv10_roiresbf'');');

at_foreachdirdo(d_here([1:10 12]),'vh_groundtruthcompare(atd,''PSD_DECsv10_roiresbf'',''spine_ROI_DLW_ROI'',''PSD_ROI_'');');
at_foreachdirdo(d_here([11 13:16]),'vh_groundtruthcompare(atd,''PSD_DECsv10_roiresbf'',''spine_ROI_SG_ROI'',''PSD_ROI_'');');
at_foreachdirdo(d_here([17:18]),'vh_groundtruthcompare(atd,''PSD_DECsv10_roiresbf'',''spine_ROI_KC_ROI'',''PSD_ROI_'');');
at_foreachdirdo(d_here([1:10 12]),'vh_groundtruthcompare(atd,''VG_DECsv10_roiresbf'',''spine_ROI_DLW_ROI'',''VG_ROI_'');');
at_foreachdirdo(d_here([11 13:16]),'vh_groundtruthcompare(atd,''VG_DECsv10_roiresbf'',''spine_ROI_SG_ROI'',''VG_ROI_'');');
at_foreachdirdo(d_here([17 18]),'vh_groundtruthcompare(atd,''VG_DECsv10_roiresbf'',''spine_ROI_KC_ROI'',''VG_ROI_'');');

at_foreachdirdo(d_here([1 3:6]),'vh_groundtruthcompareC(atd,''spine_ROI_DLW_ROI'', ''PSD_DECsv10_roiresbf'',''PSD_ROI_KC_ROIres'', ''VG_DECsv10_roiresbf'',''VG_ROI_KC_ROIres'');');
at_foreachdirdo(d_here([17 18]),'vh_groundtruthcompareC(atd,''spine_ROI_KC_ROI'', ''PSD_DECsv10_roiresbf'',''PSD_ROI_KC_ROIres'', ''VG_DECsv10_roiresbf'',''VG_ROI_KC_ROIres'');');
at_foreachdirdo(d_here([1:6]),'vh_groundtruthcompareC(atd,''spine_ROI_DLW_ROI'', ''PSD_DECsv10_roiresbf'',''PSD_ROI_SG_ROIres'', ''VG_DECsv10_roiresbf'',''VG_ROI_SG_ROIres'');');
at_foreachdirdo(d_here([11 13:16]),'vh_groundtruthcompareC(atd,''spine_ROI_SG_ROI'', ''PSD_DECsv10_roiresbf'',''PSD_ROI_SG_ROIres'', ''VG_DECsv10_roiresbf'',''VG_ROI_SG_ROIres'');');
at_foreachdirdo(d_here([7:10 12 ]),'vh_groundtruthcompareC(atd,''spine_ROI_DLW_ROI'', ''PSD_DECsv10_roiresbf'',''PSD_ROI_DW_ROIres'', ''VG_DECsv10_roiresbf'',''VG_ROI_DW_ROIres'');');

% algorithm 111 
at_foreachdirdo(d_here,'vh_pipepiece1(atd, ''PSD_DEC'', ''PSD_DECsv11'',''plotthresholdestimate'',1,''t_levels'',[99.999 99.9]);')
at_foreachdirdo(d_here,'vh_pipepiece1(atd, ''VG_DEC'', ''VG_DECsv11'',''plotthresholdestimate'',1,''t_levels'',[99.999 99.9]);')


at_foreachdirdo(d_here,'vh_filter2tbrightness(atd,''PSD_DECsv11_roires'',''PSD_DECsv11_roiresbf'');');
at_foreachdirdo(d_here,'vh_filter2tbrightness(atd,''VG_DECsv11_roires'',''VG_DECsv11_roiresbf'');');


at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''PSD_ROI_'', ''PSD_DECsv11_roiresbf'');')
at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''VG_ROI_'', ''VG_DECsv11_roiresbf'');')
at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''spine_ROI_'', ''PSD_DECsv11_roiresbf'',''useRes'',0);')
at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''spine_ROI_'', ''VG_DECsv11_roiresbf'',''useRes'',0);')

at_foreachdirdo(d_here,'vh_coloc1(atd,''PSD_DECsv11_roiresbf'',''VG_DECsv11_roiresbf'',''PSD_DECsv11_roiresbf_X_VG_DECsv11_roiresbf'');');

at_foreachdirdo(d_here([1:10 12]),'vh_groundtruthcompare(atd,''PSD_DECsv11_roiresbf'',''spine_ROI_DLW_ROI'',''PSD_ROI_'');');
at_foreachdirdo(d_here([11 13:16]),'vh_groundtruthcompare(atd,''PSD_DECsv11_roiresbf'',''spine_ROI_SG_ROI'',''PSD_ROI_'');');
at_foreachdirdo(d_here([17:18]),'vh_groundtruthcompare(atd,''PSD_DECsv11_roiresbf'',''spine_ROI_KC_ROI'',''PSD_ROI_'');');
at_foreachdirdo(d_here([1:10 12]),'vh_groundtruthcompare(atd,''VG_DECsv11_roiresbf'',''spine_ROI_DLW_ROI'',''VG_ROI_'');');
at_foreachdirdo(d_here([11 13:16]),'vh_groundtruthcompare(atd,''VG_DECsv11_roiresbf'',''spine_ROI_SG_ROI'',''VG_ROI_'');');
at_foreachdirdo(d_here([17 18]),'vh_groundtruthcompare(atd,''VG_DECsv11_roiresbf'',''spine_ROI_KC_ROI'',''VG_ROI_'');');

at_foreachdirdo(d_here([1 3:6]),'vh_groundtruthcompareC(atd,''spine_ROI_DLW_ROI'', ''PSD_DECsv11_roiresbf'',''PSD_ROI_KC_ROIres'', ''VG_DECsv11_roiresbf'',''VG_ROI_KC_ROIres'');');
at_foreachdirdo(d_here([17 18]),'vh_groundtruthcompareC(atd,''spine_ROI_KC_ROI'', ''PSD_DECsv11_roiresbf'',''PSD_ROI_KC_ROIres'', ''VG_DECsv11_roiresbf'',''VG_ROI_KC_ROIres'');');
at_foreachdirdo(d_here([1:6]),'vh_groundtruthcompareC(atd,''spine_ROI_DLW_ROI'', ''PSD_DECsv11_roiresbf'',''PSD_ROI_SG_ROIres'', ''VG_DECsv11_roiresbf'',''VG_ROI_SG_ROIres'');');
at_foreachdirdo(d_here([11 13:16]),'vh_groundtruthcompareC(atd,''spine_ROI_SG_ROI'', ''PSD_DECsv11_roiresbf'',''PSD_ROI_SG_ROIres'', ''VG_DECsv11_roiresbf'',''VG_ROI_SG_ROIres'');');
at_foreachdirdo(d_here([7:10 12 ]),'vh_groundtruthcompareC(atd,''spine_ROI_DLW_ROI'', ''PSD_DECsv11_roiresbf'',''PSD_ROI_DW_ROIres'', ''VG_DECsv11_roiresbf'',''VG_ROI_DW_ROIres'');');

% algorithm 112 
at_foreachdirdo(d_here,'vh_pipepiece2(atd, ''PSD_DEC'', ''PSD_DECsv12'',''plotthresholdestimate'',1,''t_levels'',[99.999 98]);')
at_foreachdirdo(d_here,'vh_pipepiece2(atd, ''VG_DEC'', ''VG_DECsv12'',''plotthresholdestimate'',1,''t_levels'',[99.999 98]);')


at_foreachdirdo(d_here,'vh_filter2tbrightness(atd,''PSD_DECsv12_roiresvf'',''PSD_DECsv12_roiresbf'');');
at_foreachdirdo(d_here,'vh_filter2tbrightness(atd,''VG_DECsv12_roiresvf'',''VG_DECsv12_roiresbf'');');


at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''PSD_ROI_'', ''PSD_DECsv12_roiresbf'');')
at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''VG_ROI_'', ''VG_DECsv12_roiresbf'');')
at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''spine_ROI_'', ''PSD_DECsv12_roiresbf'',''useRes'',0);')
at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''spine_ROI_'', ''VG_DECsv12_roiresbf'',''useRes'',0);')

at_foreachdirdo(d_here,'vh_coloc1(atd,''PSD_DECsv12_roiresbf'',''VG_DECsv12_roiresbf'',''PSD_DECsv12_roiresbf_X_VG_DECsv12_roiresbf'');');

at_foreachdirdo(d_here([1:10 12]),'vh_groundtruthcompare(atd,''PSD_DECsv12_roiresbf'',''spine_ROI_DLW_ROI'',''PSD_ROI_'');');
at_foreachdirdo(d_here([11 13:16]),'vh_groundtruthcompare(atd,''PSD_DECsv12_roiresbf'',''spine_ROI_SG_ROI'',''PSD_ROI_'');');
at_foreachdirdo(d_here([17:18]),'vh_groundtruthcompare(atd,''PSD_DECsv12_roiresbf'',''spine_ROI_KC_ROI'',''PSD_ROI_'');');
at_foreachdirdo(d_here([1:10 12]),'vh_groundtruthcompare(atd,''VG_DECsv12_roiresbf'',''spine_ROI_DLW_ROI'',''VG_ROI_'');');
at_foreachdirdo(d_here([11 13:16]),'vh_groundtruthcompare(atd,''VG_DECsv12_roiresbf'',''spine_ROI_SG_ROI'',''VG_ROI_'');');
at_foreachdirdo(d_here([17 18]),'vh_groundtruthcompare(atd,''VG_DECsv12_roiresbf'',''spine_ROI_KC_ROI'',''VG_ROI_'');');

at_foreachdirdo(d_here([1 3:6]),'vh_groundtruthcompareC(atd,''spine_ROI_DLW_ROI'', ''PSD_DECsv12_roiresbf'',''PSD_ROI_KC_ROIres'', ''VG_DECsv12_roiresbf'',''VG_ROI_KC_ROIres'');');
at_foreachdirdo(d_here([17 18]),'vh_groundtruthcompareC(atd,''spine_ROI_KC_ROI'', ''PSD_DECsv12_roiresbf'',''PSD_ROI_KC_ROIres'', ''VG_DECsv12_roiresbf'',''VG_ROI_KC_ROIres'');');
at_foreachdirdo(d_here([1:6]),'vh_groundtruthcompareC(atd,''spine_ROI_DLW_ROI'', ''PSD_DECsv12_roiresbf'',''PSD_ROI_SG_ROIres'', ''VG_DECsv12_roiresbf'',''VG_ROI_SG_ROIres'');');
at_foreachdirdo(d_here([11 13:16]),'vh_groundtruthcompareC(atd,''spine_ROI_SG_ROI'', ''PSD_DECsv12_roiresbf'',''PSD_ROI_SG_ROIres'', ''VG_DECsv12_roiresbf'',''VG_ROI_SG_ROIres'');');
at_foreachdirdo(d_here([7:10 12 ]),'vh_groundtruthcompareC(atd,''spine_ROI_DLW_ROI'', ''PSD_DECsv12_roiresbf'',''PSD_ROI_DW_ROIres'', ''VG_DECsv12_roiresbf'',''VG_ROI_DW_ROIres'');');

