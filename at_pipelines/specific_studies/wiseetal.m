

at_foreachdirdo(d([7:11]),'vh_pipepiece1(atd, ''PSDDEC'', ''PSDDECsv1'',''plotthresholdestimate'',1,''t_levels'',[80 30]);')
at_foreachdirdo(d([7:11]),'vh_pipepiece1(atd, ''VGDEC'', ''VGDECsv1'',''plotthresholdestimate'',1,''t_levels'',[80 30]);')
at_foreachdirdo(d([7:11]),'vh_pipepiece1(atd, ''BASDEC'', ''BASDECsv1'',''plotthresholdestimate'',1,''t_levels'',[80 30]);')



at_foreachdirdo(d, ['vh_coloc1(atd,''PSDDECsv1_roires'',''spines_over64'',''PSDDECsv1_ON_SPINE'',''overlap_threshold'',0.33);'])

at_foreachdirdo(d,['vh_coloc1(atd,''PSDDECsv1_roires'',''BASDECsv1_roires'',''PSDDECsv1_ON_BASDECsv1'');'])
at_foreachdirdo(d,['vh_coloc1(atd,''PSDDECsv1_roires'',''VGDECsv1_roires'',''PSDDECsv1_ON_VGDECsv1'');'])

