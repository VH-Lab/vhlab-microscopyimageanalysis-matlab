function wiseetal_plotTFFP(out, chan, algo)


exper_index = eval(['out.' chan '_experindex'' ; ']);

truepos = eval(['out.' chan '_truepositives; ']);
falsepos = eval(['out.' chan '_falsepositives ; ']);

big_table_truepos = [exper_index truepos];
big_table_falsepos = [exper_index falsepos];

I = find(big_table_truepos(:,2)==algo);

u = 1:5;

X = {};
Y = {};

for i=1:numel(u),
	J = find(big_table_truepos(I,3)==u(i));
	X{i} = big_table_falsepos(I(J),5);
	Y{i} = big_table_truepos(I(J),5);
end;

labels = {'DW','DW','SG','KC','XX'};
symbs = ['ddox.'];
colors = ['kkgmc'];

for i=1:numel(u),
	plot(X{i},Y{i},[symbs(i) colors(i)],'DisplayName',labels{i});
	hold on;
end;

xlabel('False positive estimate');
ylabel('True positive estimate');
title(['Algorithm ' int2str(algo)]);

legend
box off;

axis([0 1 0 1]);
