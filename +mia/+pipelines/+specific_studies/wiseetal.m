
foreachdirdo(d([1]),'vh_roicomparepipe(mdir, ''PSD_ROI_'', ''PSDsv1_roiresvf'');')
mia.utilities.foreachdirdo(d([1]),'mia.pipelines.vh_roicomparepipe(mdir, ''VG_ROI_'', ''VGsv1_roiresvf'');')
mia.utilities.foreachdirdo(d([1]),'mia.pipelines.vh_roicomparepipe(mdir, ''spine_ROI_'', ''PSDsv1_roiresvf'',''useRes'',0);')
mia.utilities.foreachdirdo(d([1]),'mia.pipelines.vh_roicomparepipe(mdir, ''spine_ROI_'', ''VGsv1_roiresvf'',''useRes'',0);')

mia.utilities.foreachdirdo(d([1]),'mia.pipelines.vh_roicomparepipe(mdir, ''VG_ROI_'', ''VGsv1_roiresvf'');')

mia.utilities.foreachdirdo(d([1]),'mia.pipelines.vh_pipepiece1(mdir, ''PSD_DEC'', ''PSD_DECsv1'',''plotthresholdestimate'',1,''t_levels'',[80 30]);')
mia.utilities.foreachdirdo(d([1]),'mia.pipelines.vh_pipepiece1(mdir, ''VG_DEC'', ''VG_DECsv1'',''plotthresholdestimate'',1,''t_levels'',[80 30]);')


mia.utilities.foreachdirdo(d(1),'mia.pipelines.vh_imageroi2roiroi(mdir);')


mia.utilities.foreachdirdo(d([1]),'mia.pipelines.vh_pipepiece1(mdir, ''PSD'', ''PSDsv1'',''plotthresholdestimate'',1,''t_levels'',[80 30]);')
mia.utilities.foreachdirdo(d([1]),'mia.pipelines.vh_pipepiece1(mdir, ''VG'', ''VGsv1'',''plotthresholdestimate'',1,''t_levels'',[80 30]);')

mia.utilities.foreachdirdo(d([7:11]),'mia.pipelines.vh_pipepiece1(mdir, ''PSDDEC'', ''PSDDECsv1'',''plotthresholdestimate'',1,''t_levels'',[80 30]);')
mia.utilities.foreachdirdo(d([7:11]),'mia.pipelines.vh_pipepiece1(mdir, ''VGDEC'', ''VGDECsv1'',''plotthresholdestimate'',1,''t_levels'',[80 30]);')
mia.utilities.foreachdirdo(d([7:11]),'mia.pipelines.vh_pipepiece1(mdir, ''BASDEC'', ''BASDECsv1'',''plotthresholdestimate'',1,''t_levels'',[80 30]);')


mia.utilities.foreachdirdo(d(6:15), ['mia.pipelines.vh_coloc1(mdir,''PSDDECsv2_vf'',''spines_over64'',''PSDDECsv2_ON_SPINE'',''overlap_threshold'',0.33);'])
mia.utilities.foreachdirdo(d(6:15),['mia.pipelines.vh_coloc1(mdir,''PSDDECsv2_vf'',''VGDECsv2_vf'',''PSDDECsv2_ON_VGDECsv2'');'])
mia.utilities.foreachdirdo(d(6:9), ['mia.pipelines.vh_coloc1(mdir,''PSDDECsv1_roires'',''spines_over64'',''PSDDECsv1_ON_SPINE'',''overlap_threshold'',0.33);'])

mia.utilities.foreachdirdo(d(6:9),['mia.pipelines.vh_coloc1(mdir,''PSDDECsv1_roires'',''BASDECsv1_roires'',''PSDDECsv1_ON_BASDECsv1'');'])
mia.utilities.foreachdirdo(d(10:11),['mia.pipelines.vh_coloc1(mdir,''PSDDECsv1_roires'',''VGDECsv1_roires'',''PSDDECsv1_ON_VGDECsv1'');'])

mia.utilities.foreachdirdo(d(1:15),['mia.pipelines.vh_intensityvolume(mdir,''PSDDECsv1_roires'',''PSDDECsv2'');']);


6,7,8,9 ready to go for colocalizations




6 needs PSDDEC


Has spines:

6:15

Needs spine colocalization:

6, 10, 11

Needs ROI colocalization:

6, 10, 11




 
