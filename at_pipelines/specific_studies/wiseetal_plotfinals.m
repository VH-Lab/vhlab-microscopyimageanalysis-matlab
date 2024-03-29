function wiseetal_plotfinals(s)

 % want to plot all the conditions

 % first, irrev_excitatory


algos = [0 107 109 111];
exp_type = {'irrev_exc','irrev_inh','structure','structure'};
roi_type1 = {'BAS','GEPH','BAS','VG'};

subplot_r = 3;
subplot_c = 3;

for e=1:numel(exp_type),
	exp_ind{e} = find( (strcmp(exp_type{e},{s.exper_type})) ...
		& (strcmp(roi_type1{e},{s.roi1})));
end;

groups = {'control','ttx5','ttx10'};

group_ind{1} = find(strcmp('CONTROL',{s.drug}));
group_ind{2} = find(strcmp('TTX',{s.drug}) & ([s.time]==5));
group_ind{3} = find(strcmp('TTX',{s.drug}) & ([s.time]==10));

grp_colors = [0 0 0 ; 1 0 0 ; 0 0 1];
grp_colors_points = [0.3 0.3 0.3 ; 0.5 0 0 ; 0 0 0.5];

 % want to make a figure of synaptic number

for e=1:numel(exp_type),
	figure;
	subplot_count = 1;
	for a=1:numel(algos),
		subplot(subplot_r,subplot_c,subplot_count);
		clear gd mn
		for g=1:numel(group_ind),
			algos_here = find([s.algorithm]==algos(a));
			gd_index{g} = intersect(intersect(group_ind{g},algos_here),exp_ind{e});
			gd{g} = [s(gd_index{g}).number];
			for z=1:numel(gd_index{g}),
				blur_data = s(gd_index{g}(z)).blur_data;
				if isempty(blur_data),
					blur_data.total_in = NaN;
				end;
				gd{g}(z) = gd{g}(z); % / (blur_data.total_in * ((72e-9 * 72e-9 * 200e-9)));
			end;
			mn(g) = nanmean(gd{g})
			if numel(gd{g})>0,
				h=bar(1+1*g,mn(g));
				set(h,'facecolor',grp_colors(g,:));
				hold on;
				plot(1+1*g+0.5*(rand(size(gd{g}))-0.5),gd{g},'o','color',grp_colors_points(g,:));
				se = nanstderr(gd{g}(:));
				plot(1+1*g*[1 1],mn(g)+se*[-1 1],'k-','linewidth',2);
			end;
		end;
		title([exp_type{e} '-' roi_type1{e} ' N ' int2str(algos(a))],'interp','none');
		box off;
		subplot_count = subplot_count + 1;
	end;
end;

 % want to make a figure of synaptic volume

for e=1:numel(exp_type),
	figure;
	subplot_count = 1;
	for a=1:numel(algos),
		subplot(subplot_r,subplot_c,subplot_count);
		clear gd mn
		for g=1:numel(group_ind),
			algos_here = find([s.algorithm]==algos(a));
			gd_index{g} = intersect(intersect(group_ind{g},algos_here),exp_ind{e});
			if strcmpi(roi_type1{e},'GEPH') | strcmpi(roi_type1{e},'PSD'),
				gd{g} = [s(gd_index{g}).volumeroi1];
			else,
				gd{g} = [s(gd_index{g}).volumeroi2];
			end;
			gd{g} = gd{g} * (72e-3 * 72e-3 * 200e-3);
			mn(g) = nanmean(gd{g})
			if numel(gd{g})>0,
				h=bar(1+1*g,mn(g));
				set(h,'facecolor',grp_colors(g,:));
				hold on;
				plot(1+1*g+0.5*(rand(size(gd{g}))-0.5),gd{g},'o','color',grp_colors_points(g,:));
				se = stderr(gd{g}(:));
				plot(1+1*g*[1 1],mn(g)+se*[-1 1],'k-','linewidth',2);
			end;
		end;
		title([exp_type{e} '-' roi_type1{e} ' V ' int2str(algos(a))],'interp','none');
		box off;
		subplot_count = subplot_count + 1;
	end;
end;



return;

I{1} = find( strcmp('irrev_exc',{s.exper_type})&([s.algorithm]==109)&strcmp('CONTROL',{s.drug}));
I{2} = find( strcmp('irrev_exc',{s.exper_type})&([s.algorithm]==109)&strcmp('TTX',{s.drug}) & ([s.time]==5));
I{3} = find( strcmp('irrev_exc',{s.exper_type})&([s.algorithm]==109)&strcmp('TTX',{s.drug}) & ([s.time]==10));


