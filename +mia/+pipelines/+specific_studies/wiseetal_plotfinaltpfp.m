function [mn_tp,mn_fp,ste_tp,ste_fp] = wiseetal_plotfinaltpfp(out)

include = 1:21;

mn_tp = [];
ste_tp = [];

figure;

brightness = linspace(0,1,size(out.TP,1)+1);

for v=1:size(out.TP,1),

	for n = 1:size(out.TP,2),
		mn_tp(v,n) = mean(out.TP(v,n,include));
		ste_tp(v,n) = stderr(out.TP(v,n,include));
		mn_fp(v,n) = mean(out.FP(v,n,include));
		ste_fp(v,n) = stderr(out.FP(v,n,include));
	end;

	h=errorbar(mn_fp(v,:),mn_tp(v,:),ste_fp(v,:),ste_fp(v,:),ste_tp(v,:),ste_tp(v,:));
	set(h,'color',brightness(v)*[1 1 1]);
	hold on;

end;

axis([0 1.2 0 1.2]);

xlabel('Prob of empirical false positive');
ylabel('Prob of true positive');
box off;

