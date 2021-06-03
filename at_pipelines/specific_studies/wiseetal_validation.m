
d_here = d(1);


at_foreachdirdo(d_here,'vh_imageroi2roiroi(atd);')
at_foreachdirdo(d_here,'vh_pipepiece1(atd, ''PSD_DEC'', ''PSD_DECsv1'',''plotthresholdestimate'',1,''t_levels'',[80 30]);')
at_foreachdirdo(d_here,'vh_pipepiece1(atd, ''VG_DEC'', ''VG_DECsv1'',''plotthresholdestimate'',1,''t_levels'',[80 30]);')

at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''PSD_ROI_'', ''PSD_DECsv1_roiresvf'');')
at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''VG_ROI_'', ''VG_DECsv1_roiresvf'');')
at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''spine_ROI_'', ''PSD_DECsv1_roiresvf'',''useRes'',0);')
at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''spine_ROI_'', ''VG_DECsv1_roiresvf'',''useRes'',0);')

at_foreachdirdo(d_here([1:10 12]),'vh_groundtruthcompare(atd,''PSD_DECsv1_roiresvf'',''spine_ROI_DLW_ROI'',''PSD_ROI_'');');
at_foreachdirdo(d_here([11 13:16]),'vh_groundtruthcompare(atd,''PSD_DECsv1_roiresvf'',''spine_ROI_SG_ROI'',''PSD_ROI_'');');
at_foreachdirdo(d_here([17:18]),'vh_groundtruthcompare(atd,''PSD_DECsv1_roiresvf'',''spine_ROI_KC_ROI'',''PSD_ROI_'');');
at_foreachdirdo(d_here([1:10 12]),'vh_groundtruthcompare(atd,''VG_DECsv1_roiresvf'',''spine_ROI_DLW_ROI'',''VG_ROI_'');');
at_foreachdirdo(d_here([11 13:16]),'vh_groundtruthcompare(atd,''VG_DECsv1_roiresvf'',''spine_ROI_SG_ROI'',''VG_ROI_'');');
at_foreachdirdo(d_here([17 18]),'vh_groundtruthcompare(atd,''VG_DECsv1_roiresvf'',''spine_ROI_KC_ROI'',''VG_ROI_'');');


% image2roi - 1:6, 13:23,  errors in 7:12
% PSD_DECsv1 - 1:6, 13:23 in progress 

% algorithm 101

at_foreachdirdo(d_here,'vh_filter2tbrightness(atd,''PSD_DECsv1_roires'',''PSD_DECsv1_roiresbf'');');
at_foreachdirdo(d_here,'vh_filter2tbrightness(atd,''VG_DECsv1_roires'',''VG_DECsv1_roiresbf'');');

at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''PSD_ROI_'', ''PSD_DECsv1_roiresbf'');')
at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''VG_ROI_'', ''VG_DECsv1_roiresbf'');')
at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''spine_ROI_'', ''PSD_DECsv1_roiresbf'',''useRes'',0);')
at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''spine_ROI_'', ''VG_DECsv1_roiresbf'',''useRes'',0);')

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
at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''spine_ROI_'', ''PSD_DECsv2_roiresbf'',''useRes'',0);')
at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''VG_ROI_'', ''VG_DECsv2_roiresbf'');')
at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''spine_ROI_'', ''VG_DECsv2_roiresbf'',''useRes'',0);')

at_foreachdirdo(d_here([1:10 12]),'vh_groundtruthcompare(atd,''PSD_DECsv2_roiresbf'',''spine_ROI_DLW_ROI'',''PSD_ROI_'');');
at_foreachdirdo(d_here([11 13:16]),'vh_groundtruthcompare(atd,''PSD_DECsv2_roiresbf'',''spine_ROI_SG_ROI'',''PSD_ROI_'');');
at_foreachdirdo(d_here([17:18]),'vh_groundtruthcompare(atd,''PSD_DECsv2_roiresbf'',''spine_ROI_KC_ROI'',''PSD_ROI_'');');
at_foreachdirdo(d_here([1:10 12]),'vh_groundtruthcompare(atd,''VG_DECsv2_roiresbf'',''spine_ROI_DLW_ROI'',''VG_ROI_'');');
at_foreachdirdo(d_here([11 13:16]),'vh_groundtruthcompare(atd,''VG_DECsv2_roiresbf'',''spine_ROI_SG_ROI'',''VG_ROI_'');');
at_foreachdirdo(d_here([17 18]),'vh_groundtruthcompare(atd,''VG_DECsv2_roiresbf'',''spine_ROI_KC_ROI'',''VG_ROI_'');');


% algorithm 103 
at_foreachdirdo(d_here,'vh_pipepiece1(atd, ''PSD_DEC'', ''PSD_DECsv3'',''plotthresholdestimate'',1,''t_levels'',[95 30]);')
at_foreachdirdo(d_here,'vh_pipepiece1(atd, ''VG_DEC'', ''VG_DECsv3'',''plotthresholdestimate'',1,''t_levels'',[95 30]);')


at_foreachdirdo(d_here,'vh_filter2tbrightness(atd,''PSD_DECsv3_roires'',''PSD_DECsv3_roiresbf'');');
at_foreachdirdo(d_here,'vh_filter2tbrightness(atd,''VG_DECsv3_roires'',''VG_DECsv3_roiresbf'');');


at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''PSD_ROI_'', ''PSD_DECsv3_roiresbf'');')
at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''spine_ROI_'', ''PSD_DECsv3_roiresbf'',''useRes'',0);')
at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''VG_ROI_'', ''VG_DECsv3_roiresbf'');')
at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''spine_ROI_'', ''VG_DECsv3_roiresbf'',''useRes'',0);')

at_foreachdirdo(d_here([1:10 12]),'vh_groundtruthcompare(atd,''PSD_DECsv3_roiresbf'',''spine_ROI_DLW_ROI'',''PSD_ROI_'');');
at_foreachdirdo(d_here([11 13:16]),'vh_groundtruthcompare(atd,''PSD_DECsv3_roiresbf'',''spine_ROI_SG_ROI'',''PSD_ROI_'');');
at_foreachdirdo(d_here([17:18]),'vh_groundtruthcompare(atd,''PSD_DECsv3_roiresbf'',''spine_ROI_KC_ROI'',''PSD_ROI_'');');
at_foreachdirdo(d_here([1:10 12]),'vh_groundtruthcompare(atd,''VG_DECsv3_roiresbf'',''spine_ROI_DLW_ROI'',''VG_ROI_'');');
at_foreachdirdo(d_here([11 13:16]),'vh_groundtruthcompare(atd,''VG_DECsv3_roiresbf'',''spine_ROI_SG_ROI'',''VG_ROI_'');');
at_foreachdirdo(d_here([17 18]),'vh_groundtruthcompare(atd,''VG_DECsv3_roiresbf'',''spine_ROI_KC_ROI'',''VG_ROI_'');');

% algorithm 104 
at_foreachdirdo(d_here,'vh_pipepiece1(atd, ''PSD_DEC'', ''PSD_DECsv4'',''plotthresholdestimate'',1,''t_levels'',[97.5 30]);')
at_foreachdirdo(d_here,'vh_pipepiece1(atd, ''VG_DEC'', ''VG_DECsv4'',''plotthresholdestimate'',1,''t_levels'',[97.5 30]);')


at_foreachdirdo(d_here,'vh_filter2tbrightness(atd,''PSD_DECsv4_roires'',''PSD_DECsv4_roiresbf'');');
at_foreachdirdo(d_here,'vh_filter2tbrightness(atd,''VG_DECsv4_roires'',''VG_DECsv4_roiresbf'');');


at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''PSD_ROI_'', ''PSD_DECsv4_roiresbf'');')
at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''spine_ROI_'', ''PSD_DECsv4_roiresbf'',''useRes'',0);')
at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''VG_ROI_'', ''VG_DECsv4_roiresbf'');')
at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''spine_ROI_'', ''VG_DECsv4_roiresbf'',''useRes'',0);')

at_foreachdirdo(d_here([1:10 12]),'vh_groundtruthcompare(atd,''PSD_DECsv4_roiresbf'',''spine_ROI_DLW_ROI'',''PSD_ROI_'');');
at_foreachdirdo(d_here([11 13:16]),'vh_groundtruthcompare(atd,''PSD_DECsv4_roiresbf'',''spine_ROI_SG_ROI'',''PSD_ROI_'');');
at_foreachdirdo(d_here([17:18]),'vh_groundtruthcompare(atd,''PSD_DECsv4_roiresbf'',''spine_ROI_KC_ROI'',''PSD_ROI_'');');
at_foreachdirdo(d_here([1:10 12]),'vh_groundtruthcompare(atd,''VG_DECsv4_roiresbf'',''spine_ROI_DLW_ROI'',''VG_ROI_'');');
at_foreachdirdo(d_here([11 13:16]),'vh_groundtruthcompare(atd,''VG_DECsv4_roiresbf'',''spine_ROI_SG_ROI'',''VG_ROI_'');');
at_foreachdirdo(d_here([17 18]),'vh_groundtruthcompare(atd,''VG_DECsv4_roiresbf'',''spine_ROI_KC_ROI'',''VG_ROI_'');');


% algorithm 105 
at_foreachdirdo(d_here,'vh_pipepiece1(atd, ''PSD_DEC'', ''PSD_DECsv5'',''plotthresholdestimate'',1,''t_levels'',[99 30]);')
at_foreachdirdo(d_here,'vh_pipepiece1(atd, ''VG_DEC'', ''VG_DECsv5'',''plotthresholdestimate'',1,''t_levels'',[99 30]);')


at_foreachdirdo(d_here,'vh_filter2tbrightness(atd,''PSD_DECsv5_roires'',''PSD_DECsv5_roiresbf'');');
at_foreachdirdo(d_here,'vh_filter2tbrightness(atd,''VG_DECsv5_roires'',''VG_DECsv5_roiresbf'');');


at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''PSD_ROI_'', ''PSD_DECsv5_roiresbf'');')
at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''spine_ROI_'', ''PSD_DECsv5_roiresbf'',''useRes'',0);')
at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''VG_ROI_'', ''VG_DECsv5_roiresbf'');')
at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''spine_ROI_'', ''VG_DECsv5_roiresbf'',''useRes'',0);')

at_foreachdirdo(d_here([1:10 12]),'vh_groundtruthcompare(atd,''PSD_DECsv5_roiresbf'',''spine_ROI_DLW_ROI'',''PSD_ROI_'');');
at_foreachdirdo(d_here([11 13:16]),'vh_groundtruthcompare(atd,''PSD_DECsv5_roiresbf'',''spine_ROI_SG_ROI'',''PSD_ROI_'');');
at_foreachdirdo(d_here([17:18]),'vh_groundtruthcompare(atd,''PSD_DECsv5_roiresbf'',''spine_ROI_KC_ROI'',''PSD_ROI_'');');
at_foreachdirdo(d_here([1:10 12]),'vh_groundtruthcompare(atd,''VG_DECsv5_roiresbf'',''spine_ROI_DLW_ROI'',''VG_ROI_'');');
at_foreachdirdo(d_here([11 13:16]),'vh_groundtruthcompare(atd,''VG_DECsv5_roiresbf'',''spine_ROI_SG_ROI'',''VG_ROI_'');');
at_foreachdirdo(d_here([17 18]),'vh_groundtruthcompare(atd,''VG_DECsv5_roiresbf'',''spine_ROI_KC_ROI'',''VG_ROI_'');');

% algorithm 106 
at_foreachdirdo(d_here,'vh_pipepiece1(atd, ''PSD_DEC'', ''PSD_DECsv6'',''plotthresholdestimate'',1,''t_levels'',[97.5 80]);')
at_foreachdirdo(d_here,'vh_pipepiece1(atd, ''VG_DEC'', ''VG_DECsv6'',''plotthresholdestimate'',1,''t_levels'',[97.5 80]);')


at_foreachdirdo(d_here,'vh_filter2tbrightness(atd,''PSD_DECsv6_roires'',''PSD_DECsv6_roiresbf'');');
at_foreachdirdo(d_here,'vh_filter2tbrightness(atd,''VG_DECsv6_roires'',''VG_DECsv6_roiresbf'');');


at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''PSD_ROI_'', ''PSD_DECsv6_roiresbf'');')
at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''spine_ROI_'', ''PSD_DECsv6_roiresbf'',''useRes'',0);')
at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''VG_ROI_'', ''VG_DECsv6_roiresbf'');')
at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''spine_ROI_'', ''VG_DECsv6_roiresbf'',''useRes'',0);')

at_foreachdirdo(d_here([1:10 12]),'vh_groundtruthcompare(atd,''PSD_DECsv6_roiresbf'',''spine_ROI_DLW_ROI'',''PSD_ROI_'');');
at_foreachdirdo(d_here([11 13:16]),'vh_groundtruthcompare(atd,''PSD_DECsv6_roiresbf'',''spine_ROI_SG_ROI'',''PSD_ROI_'');');
at_foreachdirdo(d_here([17:18]),'vh_groundtruthcompare(atd,''PSD_DECsv6_roiresbf'',''spine_ROI_KC_ROI'',''PSD_ROI_'');');
at_foreachdirdo(d_here([1:10 12]),'vh_groundtruthcompare(atd,''VG_DECsv6_roiresbf'',''spine_ROI_DLW_ROI'',''VG_ROI_'');');
at_foreachdirdo(d_here([11 13:16]),'vh_groundtruthcompare(atd,''VG_DECsv6_roiresbf'',''spine_ROI_SG_ROI'',''VG_ROI_'');');
at_foreachdirdo(d_here([17 18]),'vh_groundtruthcompare(atd,''VG_DECsv6_roiresbf'',''spine_ROI_KC_ROI'',''VG_ROI_'');');


% algorithm 107 
at_foreachdirdo(d_here,'vh_pipepiece1(atd, ''PSD_DEC'', ''PSD_DECsv7'',''plotthresholdestimate'',1,''t_levels'',[99 80]);')
at_foreachdirdo(d_here,'vh_pipepiece1(atd, ''VG_DEC'', ''VG_DECsv7'',''plotthresholdestimate'',1,''t_levels'',[99 80]);')


at_foreachdirdo(d_here,'vh_filter2tbrightness(atd,''PSD_DECsv7_roires'',''PSD_DECsv7_roiresbf'');');
at_foreachdirdo(d_here,'vh_filter2tbrightness(atd,''VG_DECsv7_roires'',''VG_DECsv7_roiresbf'');');


at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''PSD_ROI_'', ''PSD_DECsv7_roiresbf'');')
at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''spine_ROI_'', ''PSD_DECsv7_roiresbf'',''useRes'',0);')
at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''VG_ROI_'', ''VG_DECsv7_roiresbf'');')
at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''spine_ROI_'', ''VG_DECsv7_roiresbf'',''useRes'',0);')

at_foreachdirdo(d_here([1:10 12]),'vh_groundtruthcompare(atd,''PSD_DECsv7_roiresbf'',''spine_ROI_DLW_ROI'',''PSD_ROI_'');');
at_foreachdirdo(d_here([11 13:16]),'vh_groundtruthcompare(atd,''PSD_DECsv7_roiresbf'',''spine_ROI_SG_ROI'',''PSD_ROI_'');');
at_foreachdirdo(d_here([17:18]),'vh_groundtruthcompare(atd,''PSD_DECsv7_roiresbf'',''spine_ROI_KC_ROI'',''PSD_ROI_'');');
at_foreachdirdo(d_here([1:10 12]),'vh_groundtruthcompare(atd,''VG_DECsv7_roiresbf'',''spine_ROI_DLW_ROI'',''VG_ROI_'');');
at_foreachdirdo(d_here([11 13:16]),'vh_groundtruthcompare(atd,''VG_DECsv7_roiresbf'',''spine_ROI_SG_ROI'',''VG_ROI_'');');
at_foreachdirdo(d_here([17 18]),'vh_groundtruthcompare(atd,''VG_DECsv7_roiresbf'',''spine_ROI_KC_ROI'',''VG_ROI_'');');


% algorithm 108 
at_foreachdirdo(d_here,'vh_pipepiece1(atd, ''PSD_DEC'', ''PSD_DECsv8'',''plotthresholdestimate'',1,''t_levels'',[99.9 80]);')
at_foreachdirdo(d_here,'vh_pipepiece1(atd, ''VG_DEC'', ''VG_DECsv8'',''plotthresholdestimate'',1,''t_levels'',[99.9 80]);')


at_foreachdirdo(d_here,'vh_filter2tbrightness(atd,''PSD_DECsv8_roires'',''PSD_DECsv8_roiresbf'');');
at_foreachdirdo(d_here,'vh_filter2tbrightness(atd,''VG_DECsv8_roires'',''VG_DECsv8_roiresbf'');');


at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''PSD_ROI_'', ''PSD_DECsv8_roiresbf'');')
at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''spine_ROI_'', ''PSD_DECsv8_roiresbf'',''useRes'',0);')
at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''VG_ROI_'', ''VG_DECsv8_roiresbf'');')
at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''spine_ROI_'', ''VG_DECsv8_roiresbf'',''useRes'',0);')

at_foreachdirdo(d_here([1:10 12]),'vh_groundtruthcompare(atd,''PSD_DECsv8_roiresbf'',''spine_ROI_DLW_ROI'',''PSD_ROI_'');');
at_foreachdirdo(d_here([11 13:16]),'vh_groundtruthcompare(atd,''PSD_DECsv8_roiresbf'',''spine_ROI_SG_ROI'',''PSD_ROI_'');');
at_foreachdirdo(d_here([17:18]),'vh_groundtruthcompare(atd,''PSD_DECsv8_roiresbf'',''spine_ROI_KC_ROI'',''PSD_ROI_'');');
at_foreachdirdo(d_here([1:10 12]),'vh_groundtruthcompare(atd,''VG_DECsv8_roiresbf'',''spine_ROI_DLW_ROI'',''VG_ROI_'');');
at_foreachdirdo(d_here([11 13:16]),'vh_groundtruthcompare(atd,''VG_DECsv8_roiresbf'',''spine_ROI_SG_ROI'',''VG_ROI_'');');
at_foreachdirdo(d_here([17 18]),'vh_groundtruthcompare(atd,''VG_DECsv8_roiresbf'',''spine_ROI_KC_ROI'',''VG_ROI_'');');

% algorithm 109 
at_foreachdirdo(d_here,'vh_pipepiece1(atd, ''PSD_DEC'', ''PSD_DECsv9'',''plotthresholdestimate'',1,''t_levels'',[99.99 97]);')
at_foreachdirdo(d_here,'vh_pipepiece1(atd, ''VG_DEC'', ''VG_DECsv9'',''plotthresholdestimate'',1,''t_levels'',[99.99 97]);')


at_foreachdirdo(d_here,'vh_filter2tbrightness(atd,''PSD_DECsv9_roires'',''PSD_DECsv9_roiresbf'');');
at_foreachdirdo(d_here,'vh_filter2tbrightness(atd,''VG_DECsv9_roires'',''VG_DECsv9_roiresbf'');');


at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''PSD_ROI_'', ''PSD_DECsv9_roiresbf'');')
at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''spine_ROI_'', ''PSD_DECsv9_roiresbf'',''useRes'',0);')
at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''VG_ROI_'', ''VG_DECsv9_roiresbf'');')
at_foreachdirdo(d_here,'vh_roicomparepipe(atd, ''spine_ROI_'', ''VG_DECsv9_roiresbf'',''useRes'',0);')

at_foreachdirdo(d_here([1:10 12]),'vh_groundtruthcompare(atd,''PSD_DECsv9_roiresbf'',''spine_ROI_DLW_ROI'',''PSD_ROI_'');');
at_foreachdirdo(d_here([11 13:16]),'vh_groundtruthcompare(atd,''PSD_DECsv9_roiresbf'',''spine_ROI_SG_ROI'',''PSD_ROI_'');');
at_foreachdirdo(d_here([17:18]),'vh_groundtruthcompare(atd,''PSD_DECsv9_roiresbf'',''spine_ROI_KC_ROI'',''PSD_ROI_'');');
at_foreachdirdo(d_here([1:10 12]),'vh_groundtruthcompare(atd,''VG_DECsv9_roiresbf'',''spine_ROI_DLW_ROI'',''VG_ROI_'');');
at_foreachdirdo(d_here([11 13:16]),'vh_groundtruthcompare(atd,''VG_DECsv9_roiresbf'',''spine_ROI_SG_ROI'',''VG_ROI_'');');
at_foreachdirdo(d_here([17 18]),'vh_groundtruthcompare(atd,''VG_DECsv9_roiresbf'',''spine_ROI_KC_ROI'',''VG_ROI_'');');


