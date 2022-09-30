% derek script

d = at_findalldirs('/Volumes/van-hooser-lab/Users/Derek/Synaptic imaging/Hand-called/Blinded re-thresh')

s = wiseetal_summary(d);

out3 = wiseetal_plotgtanalysis3(s);
out2 = wiseetal_plotgtanalysis(s);

algos_2 = [106 107 109 110 111];

for i=1:numel(algos_2)

	subplot(3,2,i);
	wiseetal_plotTPFP(out2,'psd',algos_2(i));

end;

subplot(3,2,6)

wiseetal_plotTPFP(out3,'psd',0);


