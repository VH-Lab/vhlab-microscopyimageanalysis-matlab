

at_foreachdirdo(d([7:11]),'vh_pipepiece1(atd, ''PSDDEC'', ''PSDDECsv1'',''plotthresholdestimate'',1,''t_levels'',[80 30]);')
at_foreachdirdo(d([7:11]),'vh_pipepiece1(atd, ''VGDEC'', ''VGDECsv1'',''plotthresholdestimate'',1,''t_levels'',[80 30]);')
at_foreachdirdo(d([7:11]),'vh_pipepiece1(atd, ''BASDEC'', ''BASDECsv1'',''plotthresholdestimate'',1,''t_levels'',[80 30]);')


at_foreachdirdo(d(6:15), ['vh_coloc1(atd,''PSDDECsv2_vf'',''spines_over64'',''PSDDECsv2_ON_SPINE'',''overlap_threshold'',0.33);'])
at_foreachdirdo(d(6:15),['vh_coloc1(atd,''PSDDECsv2_vf'',''VGDECsv1_vf'',''PSDDECsv1_ON_VGDECsv1'');'])
at_foreachdirdo(d(6:9), ['vh_coloc1(atd,''PSDDECsv1_roires'',''spines_over64'',''PSDDECsv1_ON_SPINE'',''overlap_threshold'',0.33);'])

at_foreachdirdo(d(6:9),['vh_coloc1(atd,''PSDDECsv1_roires'',''BASDECsv1_roires'',''PSDDECsv1_ON_BASDECsv1'');'])
at_foreachdirdo(d(10:11),['vh_coloc1(atd,''PSDDECsv1_roires'',''VGDECsv1_roires'',''PSDDECsv1_ON_VGDECsv1'');'])

at_foreachdirdo(d(1:15),['vh_intensityvolume(atd,''PSDDECsv1_roires'',''PSDDECsv2'');']);


6,7,8,9 ready to go for colocalizations




6 needs PSDDEC


Has spines:

6:15

Needs spine colocalization:

6, 10, 11

Needs ROI colocalization:

6, 10, 11




