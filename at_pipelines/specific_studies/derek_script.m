% derek script

d = at_findalldirs('/Volumes/van-hooser-lab/Users/Derek/Synaptic imaging/Hand-called')

s = wiseetal_summary(d);

out = wiseetal_plotgtanalysis3(s)

disp(['PSD True positives'])

[out.psd_experindex'  out.psd_truepositives]

disp(['PSD false positives'])

[out.psd_experindex'  out.psd_falsepositives]

disp(['Check out experiment 2 to see failure to detect:'])

s(2).dirname

disp(['VG True positives'])

[out.vg_experindex'  out.vg_truepositives]

disp(['VG false positives'])

[out.vg_experindex'  out.vg_falsepositives]
