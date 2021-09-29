
d_here = d(1);


mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_imageroi2roiroi(atd);')
mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_pipepiece1(atd, ''PSD_DEC'', ''PSD_DECsv1'',''plotthresholdestimate'',1,''t_levels'',[80 30]);')
mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_pipepiece1(atd, ''VG_DEC'', ''VG_DECsv1'',''plotthresholdestimate'',1,''t_levels'',[80 30]);')

mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_roicomparepipe(atd, ''PSD_ROI_'', ''PSD_DECsv1_roiresvf'');')
mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_roicomparepipe(atd, ''VG_ROI_'', ''VG_DECsv1_roiresvf'');')
mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_roicomparepipe(atd, ''spine_ROI_'', ''PSD_DECsv1_roiresvf'',''useRes'',0);')
mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_roicomparepipe(atd, ''spine_ROI_'', ''VG_DECsv1_roiresvf'',''useRes'',0);')

mia.utilities.at_foreachdirdo(d_here([1:10 12]),'mia.pipelines.vh_groundtruthcompare(atd,''PSD_DECsv1_roiresvf'',''spine_ROI_DLW_ROI'',''PSD_ROI_'');');
mia.utilities.at_foreachdirdo(d_here([11 13:16]),'mia.pipelines.vh_groundtruthcompare(atd,''PSD_DECsv1_roiresvf'',''spine_ROI_SG_ROI'',''PSD_ROI_'');');
mia.utilities.at_foreachdirdo(d_here([17:18]),'mia.pipelines.vh_groundtruthcompare(atd,''PSD_DECsv1_roiresvf'',''spine_ROI_KC_ROI'',''PSD_ROI_'');');
mia.utilities.at_foreachdirdo(d_here([1:10 12]),'mia.pipelines.vh_groundtruthcompare(atd,''VG_DECsv1_roiresvf'',''spine_ROI_DLW_ROI'',''VG_ROI_'');');
mia.utilities.at_foreachdirdo(d_here([11 13:16]),'mia.pipelines.vh_groundtruthcompare(atd,''VG_DECsv1_roiresvf'',''spine_ROI_SG_ROI'',''VG_ROI_'');');
mia.utilities.at_foreachdirdo(d_here([17 18]),'mia.pipelines.vh_groundtruthcompare(atd,''VG_DECsv1_roiresvf'',''spine_ROI_KC_ROI'',''VG_ROI_'');');


% image2roi - 1:6, 13:23,  errors in 7:12
% PSD_DECsv1 - 1:6, 13:23 in progress 

% algorithm 101

mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_filter2tbrightness(atd,''PSD_DECsv1_roires'',''PSD_DECsv1_roiresbf'');');
mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_filter2tbrightness(atd,''VG_DECsv1_roires'',''VG_DECsv1_roiresbf'');');

mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_roicomparepipe(atd, ''PSD_ROI_'', ''PSD_DECsv1_roiresbf'');')
mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_roicomparepipe(atd, ''VG_ROI_'', ''VG_DECsv1_roiresbf'');')
mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_roicomparepipe(atd, ''spine_ROI_'', ''PSD_DECsv1_roiresbf'',''useRes'',0);')
mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_roicomparepipe(atd, ''spine_ROI_'', ''VG_DECsv1_roiresbf'',''useRes'',0);')

mia.utilities.at_foreachdirdo(d_here([1:10 12]),'mia.pipelines.vh_groundtruthcompare(atd,''PSD_DECsv1_roiresbf'',''spine_ROI_DLW_ROI'',''PSD_ROI_'');');
mia.utilities.at_foreachdirdo(d_here([11 13:16]),'mia.pipelines.vh_groundtruthcompare(atd,''PSD_DECsv1_roiresbf'',''spine_ROI_SG_ROI'',''PSD_ROI_'');');
mia.utilities.at_foreachdirdo(d_here([17:18]),'mia.pipelines.vh_groundtruthcompare(atd,''PSD_DECsv1_roiresbf'',''spine_ROI_KC_ROI'',''PSD_ROI_'');');
mia.utilities.at_foreachdirdo(d_here([1:10 12]),'mia.pipelines.vh_groundtruthcompare(atd,''VG_DECsv1_roiresbf'',''spine_ROI_DLW_ROI'',''VG_ROI_'');');
mia.utilities.at_foreachdirdo(d_here([11 13:16]),'mia.pipelines.vh_groundtruthcompare(atd,''VG_DECsv1_roiresbf'',''spine_ROI_SG_ROI'',''VG_ROI_'');');
mia.utilities.at_foreachdirdo(d_here([17 18]),'mia.pipelines.vh_groundtruthcompare(atd,''VG_DECsv1_roiresbf'',''spine_ROI_KC_ROI'',''VG_ROI_'');');



% algorithm 102

mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_pipepiece1(atd, ''PSD_DEC'', ''PSD_DECsv2'',''plotthresholdestimate'',1,''t_levels'',[90 30]);')
mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_pipepiece1(atd, ''VG_DEC'', ''VG_DECsv2'',''plotthresholdestimate'',1,''t_levels'',[90 30]);')


mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_filter2tbrightness(atd,''PSD_DECsv2_roires'',''PSD_DECsv2_roiresbf'');');
mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_filter2tbrightness(atd,''VG_DECsv2_roires'',''VG_DECsv2_roiresbf'');');


mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_roicomparepipe(atd, ''PSD_ROI_'', ''PSD_DECsv2_roiresbf'');')
mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_roicomparepipe(atd, ''spine_ROI_'', ''PSD_DECsv2_roiresbf'',''useRes'',0);')
mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_roicomparepipe(atd, ''VG_ROI_'', ''VG_DECsv2_roiresbf'');')
mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_roicomparepipe(atd, ''spine_ROI_'', ''VG_DECsv2_roiresbf'',''useRes'',0);')

mia.utilities.at_foreachdirdo(d_here([1:10 12]),'mia.pipelines.vh_groundtruthcompare(atd,''PSD_DECsv2_roiresbf'',''spine_ROI_DLW_ROI'',''PSD_ROI_'');');
mia.utilities.at_foreachdirdo(d_here([11 13:16]),'mia.pipelines.vh_groundtruthcompare(atd,''PSD_DECsv2_roiresbf'',''spine_ROI_SG_ROI'',''PSD_ROI_'');');
mia.utilities.at_foreachdirdo(d_here([17:18]),'mia.pipelines.vh_groundtruthcompare(atd,''PSD_DECsv2_roiresbf'',''spine_ROI_KC_ROI'',''PSD_ROI_'');');
mia.utilities.at_foreachdirdo(d_here([1:10 12]),'mia.pipelines.vh_groundtruthcompare(atd,''VG_DECsv2_roiresbf'',''spine_ROI_DLW_ROI'',''VG_ROI_'');');
mia.utilities.at_foreachdirdo(d_here([11 13:16]),'mia.pipelines.vh_groundtruthcompare(atd,''VG_DECsv2_roiresbf'',''spine_ROI_SG_ROI'',''VG_ROI_'');');
mia.utilities.at_foreachdirdo(d_here([17 18]),'mia.pipelines.vh_groundtruthcompare(atd,''VG_DECsv2_roiresbf'',''spine_ROI_KC_ROI'',''VG_ROI_'');');


% algorithm 103 
mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_pipepiece1(atd, ''PSD_DEC'', ''PSD_DECsv3'',''plotthresholdestimate'',1,''t_levels'',[95 30]);')
mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_pipepiece1(atd, ''VG_DEC'', ''VG_DECsv3'',''plotthresholdestimate'',1,''t_levels'',[95 30]);')


mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_filter2tbrightness(atd,''PSD_DECsv3_roires'',''PSD_DECsv3_roiresbf'');');
mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_filter2tbrightness(atd,''VG_DECsv3_roires'',''VG_DECsv3_roiresbf'');');


mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_roicomparepipe(atd, ''PSD_ROI_'', ''PSD_DECsv3_roiresbf'');')
mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_roicomparepipe(atd, ''spine_ROI_'', ''PSD_DECsv3_roiresbf'',''useRes'',0);')
mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_roicomparepipe(atd, ''VG_ROI_'', ''VG_DECsv3_roiresbf'');')
mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_roicomparepipe(atd, ''spine_ROI_'', ''VG_DECsv3_roiresbf'',''useRes'',0);')

mia.utilities.at_foreachdirdo(d_here([1:10 12]),'mia.pipelines.vh_groundtruthcompare(atd,''PSD_DECsv3_roiresbf'',''spine_ROI_DLW_ROI'',''PSD_ROI_'');');
mia.utilities.at_foreachdirdo(d_here([11 13:16]),'mia.pipelines.vh_groundtruthcompare(atd,''PSD_DECsv3_roiresbf'',''spine_ROI_SG_ROI'',''PSD_ROI_'');');
mia.utilities.at_foreachdirdo(d_here([17:18]),'mia.pipelines.vh_groundtruthcompare(atd,''PSD_DECsv3_roiresbf'',''spine_ROI_KC_ROI'',''PSD_ROI_'');');
mia.utilities.at_foreachdirdo(d_here([1:10 12]),'mia.pipelines.vh_groundtruthcompare(atd,''VG_DECsv3_roiresbf'',''spine_ROI_DLW_ROI'',''VG_ROI_'');');
mia.utilities.at_foreachdirdo(d_here([11 13:16]),'mia.pipelines.vh_groundtruthcompare(atd,''VG_DECsv3_roiresbf'',''spine_ROI_SG_ROI'',''VG_ROI_'');');
mia.utilities.at_foreachdirdo(d_here([17 18]),'mia.pipelines.vh_groundtruthcompare(atd,''VG_DECsv3_roiresbf'',''spine_ROI_KC_ROI'',''VG_ROI_'');');

% algorithm 104 
mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_pipepiece1(atd, ''PSD_DEC'', ''PSD_DECsv4'',''plotthresholdestimate'',1,''t_levels'',[97.5 30]);')
mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_pipepiece1(atd, ''VG_DEC'', ''VG_DECsv4'',''plotthresholdestimate'',1,''t_levels'',[97.5 30]);')


mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_filter2tbrightness(atd,''PSD_DECsv4_roires'',''PSD_DECsv4_roiresbf'');');
mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_filter2tbrightness(atd,''VG_DECsv4_roires'',''VG_DECsv4_roiresbf'');');


mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_roicomparepipe(atd, ''PSD_ROI_'', ''PSD_DECsv4_roiresbf'');')
mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_roicomparepipe(atd, ''spine_ROI_'', ''PSD_DECsv4_roiresbf'',''useRes'',0);')
mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_roicomparepipe(atd, ''VG_ROI_'', ''VG_DECsv4_roiresbf'');')
mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_roicomparepipe(atd, ''spine_ROI_'', ''VG_DECsv4_roiresbf'',''useRes'',0);')

mia.utilities.at_foreachdirdo(d_here([1:10 12]),'mia.pipelines.vh_groundtruthcompare(atd,''PSD_DECsv4_roiresbf'',''spine_ROI_DLW_ROI'',''PSD_ROI_'');');
mia.utilities.at_foreachdirdo(d_here([11 13:16]),'mia.pipelines.vh_groundtruthcompare(atd,''PSD_DECsv4_roiresbf'',''spine_ROI_SG_ROI'',''PSD_ROI_'');');
mia.utilities.at_foreachdirdo(d_here([17:18]),'mia.pipelines.vh_groundtruthcompare(atd,''PSD_DECsv4_roiresbf'',''spine_ROI_KC_ROI'',''PSD_ROI_'');');
mia.utilities.at_foreachdirdo(d_here([1:10 12]),'mia.pipelines.vh_groundtruthcompare(atd,''VG_DECsv4_roiresbf'',''spine_ROI_DLW_ROI'',''VG_ROI_'');');
mia.utilities.at_foreachdirdo(d_here([11 13:16]),'mia.pipelines.vh_groundtruthcompare(atd,''VG_DECsv4_roiresbf'',''spine_ROI_SG_ROI'',''VG_ROI_'');');
mia.utilities.at_foreachdirdo(d_here([17 18]),'mia.pipelines.vh_groundtruthcompare(atd,''VG_DECsv4_roiresbf'',''spine_ROI_KC_ROI'',''VG_ROI_'');');


% algorithm 105 
mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_pipepiece1(atd, ''PSD_DEC'', ''PSD_DECsv5'',''plotthresholdestimate'',1,''t_levels'',[99 30]);')
mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_pipepiece1(atd, ''VG_DEC'', ''VG_DECsv5'',''plotthresholdestimate'',1,''t_levels'',[99 30]);')


mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_filter2tbrightness(atd,''PSD_DECsv5_roires'',''PSD_DECsv5_roiresbf'');');
mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_filter2tbrightness(atd,''VG_DECsv5_roires'',''VG_DECsv5_roiresbf'');');


mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_roicomparepipe(atd, ''PSD_ROI_'', ''PSD_DECsv5_roiresbf'');')
mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_roicomparepipe(atd, ''spine_ROI_'', ''PSD_DECsv5_roiresbf'',''useRes'',0);')
mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_roicomparepipe(atd, ''VG_ROI_'', ''VG_DECsv5_roiresbf'');')
mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_roicomparepipe(atd, ''spine_ROI_'', ''VG_DECsv5_roiresbf'',''useRes'',0);')

mia.utilities.at_foreachdirdo(d_here([1:10 12]),'mia.pipelines.vh_groundtruthcompare(atd,''PSD_DECsv5_roiresbf'',''spine_ROI_DLW_ROI'',''PSD_ROI_'');');
mia.utilities.at_foreachdirdo(d_here([11 13:16]),'mia.pipelines.vh_groundtruthcompare(atd,''PSD_DECsv5_roiresbf'',''spine_ROI_SG_ROI'',''PSD_ROI_'');');
mia.utilities.at_foreachdirdo(d_here([17:18]),'mia.pipelines.vh_groundtruthcompare(atd,''PSD_DECsv5_roiresbf'',''spine_ROI_KC_ROI'',''PSD_ROI_'');');
mia.utilities.at_foreachdirdo(d_here([1:10 12]),'mia.pipelines.vh_groundtruthcompare(atd,''VG_DECsv5_roiresbf'',''spine_ROI_DLW_ROI'',''VG_ROI_'');');
mia.utilities.at_foreachdirdo(d_here([11 13:16]),'mia.pipelines.vh_groundtruthcompare(atd,''VG_DECsv5_roiresbf'',''spine_ROI_SG_ROI'',''VG_ROI_'');');
mia.utilities.at_foreachdirdo(d_here([17 18]),'mia.pipelines.vh_groundtruthcompare(atd,''VG_DECsv5_roiresbf'',''spine_ROI_KC_ROI'',''VG_ROI_'');');

% algorithm 106 
mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_pipepiece1(atd, ''PSD_DEC'', ''PSD_DECsv6'',''plotthresholdestimate'',1,''t_levels'',[97.5 80]);')
mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_pipepiece1(atd, ''VG_DEC'', ''VG_DECsv6'',''plotthresholdestimate'',1,''t_levels'',[97.5 80]);')


mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_filter2tbrightness(atd,''PSD_DECsv6_roires'',''PSD_DECsv6_roiresbf'');');
mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_filter2tbrightness(atd,''VG_DECsv6_roires'',''VG_DECsv6_roiresbf'');');


mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_roicomparepipe(atd, ''PSD_ROI_'', ''PSD_DECsv6_roiresbf'');')
mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_roicomparepipe(atd, ''spine_ROI_'', ''PSD_DECsv6_roiresbf'',''useRes'',0);')
mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_roicomparepipe(atd, ''VG_ROI_'', ''VG_DECsv6_roiresbf'');')
mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_roicomparepipe(atd, ''spine_ROI_'', ''VG_DECsv6_roiresbf'',''useRes'',0);')

mia.utilities.at_foreachdirdo(d_here([1:10 12]),'mia.pipelines.vh_groundtruthcompare(atd,''PSD_DECsv6_roiresbf'',''spine_ROI_DLW_ROI'',''PSD_ROI_'');');
mia.utilities.at_foreachdirdo(d_here([11 13:16]),'mia.pipelines.vh_groundtruthcompare(atd,''PSD_DECsv6_roiresbf'',''spine_ROI_SG_ROI'',''PSD_ROI_'');');
mia.utilities.at_foreachdirdo(d_here([17:18]),'mia.pipelines.vh_groundtruthcompare(atd,''PSD_DECsv6_roiresbf'',''spine_ROI_KC_ROI'',''PSD_ROI_'');');
mia.utilities.at_foreachdirdo(d_here([1:10 12]),'mia.pipelines.vh_groundtruthcompare(atd,''VG_DECsv6_roiresbf'',''spine_ROI_DLW_ROI'',''VG_ROI_'');');
mia.utilities.at_foreachdirdo(d_here([11 13:16]),'mia.pipelines.vh_groundtruthcompare(atd,''VG_DECsv6_roiresbf'',''spine_ROI_SG_ROI'',''VG_ROI_'');');
mia.utilities.at_foreachdirdo(d_here([17 18]),'mia.pipelines.vh_groundtruthcompare(atd,''VG_DECsv6_roiresbf'',''spine_ROI_KC_ROI'',''VG_ROI_'');');


% algorithm 107 
mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_pipepiece1(atd, ''PSD_DEC'', ''PSD_DECsv7'',''plotthresholdestimate'',1,''t_levels'',[99 80]);')
mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_pipepiece1(atd, ''VG_DEC'', ''VG_DECsv7'',''plotthresholdestimate'',1,''t_levels'',[99 80]);')


mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_filter2tbrightness(atd,''PSD_DECsv7_roires'',''PSD_DECsv7_roiresbf'');');
mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_filter2tbrightness(atd,''VG_DECsv7_roires'',''VG_DECsv7_roiresbf'');');


mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_roicomparepipe(atd, ''PSD_ROI_'', ''PSD_DECsv7_roiresbf'');')
mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_roicomparepipe(atd, ''spine_ROI_'', ''PSD_DECsv7_roiresbf'',''useRes'',0);')
mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_roicomparepipe(atd, ''VG_ROI_'', ''VG_DECsv7_roiresbf'');')
mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_roicomparepipe(atd, ''spine_ROI_'', ''VG_DECsv7_roiresbf'',''useRes'',0);')

mia.utilities.at_foreachdirdo(d_here([1:10 12]),'mia.pipelines.vh_groundtruthcompare(atd,''PSD_DECsv7_roiresbf'',''spine_ROI_DLW_ROI'',''PSD_ROI_'');');
mia.utilities.at_foreachdirdo(d_here([11 13:16]),'mia.pipelines.vh_groundtruthcompare(atd,''PSD_DECsv7_roiresbf'',''spine_ROI_SG_ROI'',''PSD_ROI_'');');
mia.utilities.at_foreachdirdo(d_here([17:18]),'mia.pipelines.vh_groundtruthcompare(atd,''PSD_DECsv7_roiresbf'',''spine_ROI_KC_ROI'',''PSD_ROI_'');');
mia.utilities.at_foreachdirdo(d_here([1:10 12]),'mia.pipelines.vh_groundtruthcompare(atd,''VG_DECsv7_roiresbf'',''spine_ROI_DLW_ROI'',''VG_ROI_'');');
mia.utilities.at_foreachdirdo(d_here([11 13:16]),'mia.pipelines.vh_groundtruthcompare(atd,''VG_DECsv7_roiresbf'',''spine_ROI_SG_ROI'',''VG_ROI_'');');
mia.utilities.at_foreachdirdo(d_here([17 18]),'mia.pipelines.vh_groundtruthcompare(atd,''VG_DECsv7_roiresbf'',''spine_ROI_KC_ROI'',''VG_ROI_'');');


% algorithm 108 
mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_pipepiece1(atd, ''PSD_DEC'', ''PSD_DECsv8'',''plotthresholdestimate'',1,''t_levels'',[99.9 80]);')
mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_pipepiece1(atd, ''VG_DEC'', ''VG_DECsv8'',''plotthresholdestimate'',1,''t_levels'',[99.9 80]);')


mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_filter2tbrightness(atd,''PSD_DECsv8_roires'',''PSD_DECsv8_roiresbf'');');
mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_filter2tbrightness(atd,''VG_DECsv8_roires'',''VG_DECsv8_roiresbf'');');


mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_roicomparepipe(atd, ''PSD_ROI_'', ''PSD_DECsv8_roiresbf'');')
mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_roicomparepipe(atd, ''spine_ROI_'', ''PSD_DECsv8_roiresbf'',''useRes'',0);')
mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_roicomparepipe(atd, ''VG_ROI_'', ''VG_DECsv8_roiresbf'');')
mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_roicomparepipe(atd, ''spine_ROI_'', ''VG_DECsv8_roiresbf'',''useRes'',0);')

mia.utilities.at_foreachdirdo(d_here([1:10 12]),'mia.pipelines.vh_groundtruthcompare(atd,''PSD_DECsv8_roiresbf'',''spine_ROI_DLW_ROI'',''PSD_ROI_'');');
mia.utilities.at_foreachdirdo(d_here([11 13:16]),'mia.pipelines.vh_groundtruthcompare(atd,''PSD_DECsv8_roiresbf'',''spine_ROI_SG_ROI'',''PSD_ROI_'');');
mia.utilities.at_foreachdirdo(d_here([17:18]),'mia.pipelines.vh_groundtruthcompare(atd,''PSD_DECsv8_roiresbf'',''spine_ROI_KC_ROI'',''PSD_ROI_'');');
mia.utilities.at_foreachdirdo(d_here([1:10 12]),'mia.pipelines.vh_groundtruthcompare(atd,''VG_DECsv8_roiresbf'',''spine_ROI_DLW_ROI'',''VG_ROI_'');');
mia.utilities.at_foreachdirdo(d_here([11 13:16]),'mia.pipelines.vh_groundtruthcompare(atd,''VG_DECsv8_roiresbf'',''spine_ROI_SG_ROI'',''VG_ROI_'');');
mia.utilities.at_foreachdirdo(d_here([17 18]),'mia.pipelines.vh_groundtruthcompare(atd,''VG_DECsv8_roiresbf'',''spine_ROI_KC_ROI'',''VG_ROI_'');');

% algorithm 109 
mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_pipepiece1(atd, ''PSD_DEC'', ''PSD_DECsv9'',''plotthresholdestimate'',1,''t_levels'',[99.99 97]);')
mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_pipepiece1(atd, ''VG_DEC'', ''VG_DECsv9'',''plotthresholdestimate'',1,''t_levels'',[99.99 97]);')


mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_filter2tbrightness(atd,''PSD_DECsv9_roires'',''PSD_DECsv9_roiresbf'');');
mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_filter2tbrightness(atd,''VG_DECsv9_roires'',''VG_DECsv9_roiresbf'');');


mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_roicomparepipe(atd, ''PSD_ROI_'', ''PSD_DECsv9_roiresbf'');')
mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_roicomparepipe(atd, ''spine_ROI_'', ''PSD_DECsv9_roiresbf'',''useRes'',0);')
mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_roicomparepipe(atd, ''VG_ROI_'', ''VG_DECsv9_roiresbf'');')
mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_roicomparepipe(atd, ''spine_ROI_'', ''VG_DECsv9_roiresbf'',''useRes'',0);')

mia.utilities.at_foreachdirdo(d_here([1:10 12]),'mia.pipelines.vh_groundtruthcompare(atd,''PSD_DECsv9_roiresbf'',''spine_ROI_DLW_ROI'',''PSD_ROI_'');');
mia.utilities.at_foreachdirdo(d_here([11 13:16]),'mia.pipelines.vh_groundtruthcompare(atd,''PSD_DECsv9_roiresbf'',''spine_ROI_SG_ROI'',''PSD_ROI_'');');
mia.utilities.at_foreachdirdo(d_here([17:18]),'mia.pipelines.vh_groundtruthcompare(atd,''PSD_DECsv9_roiresbf'',''spine_ROI_KC_ROI'',''PSD_ROI_'');');
mia.utilities.at_foreachdirdo(d_here([1:10 12]),'mia.pipelines.vh_groundtruthcompare(atd,''VG_DECsv9_roiresbf'',''spine_ROI_DLW_ROI'',''VG_ROI_'');');
mia.utilities.at_foreachdirdo(d_here([11 13:16]),'mia.pipelines.vh_groundtruthcompare(atd,''VG_DECsv9_roiresbf'',''spine_ROI_SG_ROI'',''VG_ROI_'');');
mia.utilities.at_foreachdirdo(d_here([17 18]),'mia.pipelines.vh_groundtruthcompare(atd,''VG_DECsv9_roiresbf'',''spine_ROI_KC_ROI'',''VG_ROI_'');');

% algorithm 110 
mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_pipepiece1(atd, ''PSD_DEC'', ''PSD_DECsv10'',''plotthresholdestimate'',1,''t_levels'',[99.999 98]);')
mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_pipepiece1(atd, ''VG_DEC'', ''VG_DECsv10'',''plotthresholdestimate'',1,''t_levels'',[99.999 98]);')


mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_filter2tbrightness(atd,''PSD_DECsv10_roires'',''PSD_DECsv10_roiresbf'');');
mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_filter2tbrightness(atd,''VG_DECsv10_roires'',''VG_DECsv10_roiresbf'');');


mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_roicomparepipe(atd, ''PSD_ROI_'', ''PSD_DECsv10_roiresbf'');')
mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_roicomparepipe(atd, ''spine_ROI_'', ''PSD_DECsv10_roiresbf'',''useRes'',0);')
mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_roicomparepipe(atd, ''VG_ROI_'', ''VG_DECsv10_roiresbf'');')
mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_roicomparepipe(atd, ''spine_ROI_'', ''VG_DECsv10_roiresbf'',''useRes'',0);')

mia.utilities.at_foreachdirdo(d_here([1:10 12]),'mia.pipelines.vh_groundtruthcompare(atd,''PSD_DECsv10_roiresbf'',''spine_ROI_DLW_ROI'',''PSD_ROI_'');');
mia.utilities.at_foreachdirdo(d_here([11 13:16]),'mia.pipelines.vh_groundtruthcompare(atd,''PSD_DECsv10_roiresbf'',''spine_ROI_SG_ROI'',''PSD_ROI_'');');
mia.utilities.at_foreachdirdo(d_here([17:18]),'mia.pipelines.vh_groundtruthcompare(atd,''PSD_DECsv10_roiresbf'',''spine_ROI_KC_ROI'',''PSD_ROI_'');');
mia.utilities.at_foreachdirdo(d_here([1:10 12]),'mia.pipelines.vh_groundtruthcompare(atd,''VG_DECsv10_roiresbf'',''spine_ROI_DLW_ROI'',''VG_ROI_'');');
mia.utilities.at_foreachdirdo(d_here([11 13:16]),'mia.pipelines.vh_groundtruthcompare(atd,''VG_DECsv10_roiresbf'',''spine_ROI_SG_ROI'',''VG_ROI_'');');
mia.utilities.at_foreachdirdo(d_here([17 18]),'mia.pipelines.vh_groundtruthcompare(atd,''VG_DECsv10_roiresbf'',''spine_ROI_KC_ROI'',''VG_ROI_'');');


% algorithm 111 
mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_pipepiece1(atd, ''PSD_DEC'', ''PSD_DECsv11'',''plotthresholdestimate'',1,''t_levels'',[99.999 99.9]);')
mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_pipepiece1(atd, ''VG_DEC'', ''VG_DECsv11'',''plotthresholdestimate'',1,''t_levels'',[99.999 99.9]);')


mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_filter2tbrightness(atd,''PSD_DECsv11_roires'',''PSD_DECsv11_roiresbf'');');
mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_filter2tbrightness(atd,''VG_DECsv11_roires'',''VG_DECsv11_roiresbf'');');


mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_roicomparepipe(atd, ''PSD_ROI_'', ''PSD_DECsv11_roiresbf'');')
mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_roicomparepipe(atd, ''spine_ROI_'', ''PSD_DECsv11_roiresbf'',''useRes'',0);')
mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_roicomparepipe(atd, ''VG_ROI_'', ''VG_DECsv11_roiresbf'');')
mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_roicomparepipe(atd, ''spine_ROI_'', ''VG_DECsv11_roiresbf'',''useRes'',0);')

mia.utilities.at_foreachdirdo(d_here([1:10 12]),'mia.pipelines.vh_groundtruthcompare(atd,''PSD_DECsv11_roiresbf'',''spine_ROI_DLW_ROI'',''PSD_ROI_'');');
mia.utilities.at_foreachdirdo(d_here([11 13:16]),'mia.pipelines.vh_groundtruthcompare(atd,''PSD_DECsv11_roiresbf'',''spine_ROI_SG_ROI'',''PSD_ROI_'');');
mia.utilities.at_foreachdirdo(d_here([17:18]),'mia.pipelines.vh_groundtruthcompare(atd,''PSD_DECsv11_roiresbf'',''spine_ROI_KC_ROI'',''PSD_ROI_'');');
mia.utilities.at_foreachdirdo(d_here([1:10 12]),'mia.pipelines.vh_groundtruthcompare(atd,''VG_DECsv11_roiresbf'',''spine_ROI_DLW_ROI'',''VG_ROI_'');');
mia.utilities.at_foreachdirdo(d_here([11 13:16]),'mia.pipelines.vh_groundtruthcompare(atd,''VG_DECsv11_roiresbf'',''spine_ROI_SG_ROI'',''VG_ROI_'');');
mia.utilities.at_foreachdirdo(d_here([17 18]),'mia.pipelines.vh_groundtruthcompare(atd,''VG_DECsv11_roiresbf'',''spine_ROI_KC_ROI'',''VG_ROI_'');');

% algorithm 112 
mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_pipepiece2(atd, ''PSD_DEC'', ''PSD_DECsv12'',''plotthresholdestimate'',1,''t_levels'',[99.999 98]);')
mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_pipepiece2(atd, ''VG_DEC'', ''VG_DECsv12'',''plotthresholdestimate'',1,''t_levels'',[99.999 98]);')


mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_filter2tbrightness(atd,''PSD_DECsv12_roiresvf'',''PSD_DECsv12_roiresbf'');');
mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_filter2tbrightness(atd,''VG_DECsv12_roiresvf'',''VG_DECsv12_roiresbf'');');


mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_roicomparepipe(atd, ''PSD_ROI_'', ''PSD_DECsv12_roiresbf'');')
mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_roicomparepipe(atd, ''spine_ROI_'', ''PSD_DECsv12_roiresbf'',''useRes'',0);')
mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_roicomparepipe(atd, ''VG_ROI_'', ''VG_DECsv12_roiresbf'');')
mia.utilities.at_foreachdirdo(d_here,'mia.pipelines.vh_roicomparepipe(atd, ''spine_ROI_'', ''VG_DECsv12_roiresbf'',''useRes'',0);')

mia.utilities.at_foreachdirdo(d_here([1:10 12]),'mia.pipelines.vh_groundtruthcompare(atd,''PSD_DECsv12_roiresbf'',''spine_ROI_DLW_ROI'',''PSD_ROI_'');');
mia.utilities.at_foreachdirdo(d_here([11 13:16]),'mia.pipelines.vh_groundtruthcompare(atd,''PSD_DECsv12_roiresbf'',''spine_ROI_SG_ROI'',''PSD_ROI_'');');
mia.utilities.at_foreachdirdo(d_here([17:18]),'mia.pipelines.vh_groundtruthcompare(atd,''PSD_DECsv12_roiresbf'',''spine_ROI_KC_ROI'',''PSD_ROI_'');');
mia.utilities.at_foreachdirdo(d_here([1:10 12]),'mia.pipelines.vh_groundtruthcompare(atd,''VG_DECsv12_roiresbf'',''spine_ROI_DLW_ROI'',''VG_ROI_'');');
mia.utilities.at_foreachdirdo(d_here([11 13:16]),'mia.pipelines.vh_groundtruthcompare(atd,''VG_DECsv12_roiresbf'',''spine_ROI_SG_ROI'',''VG_ROI_'');');
mia.utilities.at_foreachdirdo(d_here([17 18]),'mia.pipelines.vh_groundtruthcompare(atd,''VG_DECsv12_roiresbf'',''spine_ROI_KC_ROI'',''VG_ROI_'');');



 
