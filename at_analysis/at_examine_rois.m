function at_examine_rois(d, roisetA, roisetB, claAonB, varargin)
% AT_EXAMINE_ROIS - examine ROI sizes, intensity, overlaps
%
% AT_EXAMINE_ROIS(D, ROISETA, ROISETB, CLAAONB, ...)
%
% 

roisetC = '';
claAonC = '';

assign(varargin{:});

for i=1:numel(d),

	disp(['>>> Working on directory ' int2str(i) ' of ' int2str(numel(d)) '.']);

	figure;

	atd = atdir(d{i});

	% load ROIs, L, props
	rois{1} = getroifilename(atd, roisetA);
	L{1} = getlabeledroifilename(atd, roisetA);
	roiprop{1} = getroiparametersfilename(atd, roisetA);
	rois{2} = getroifilename(atd, roisetB);
	L{2} = getlabeledroifilename(atd, roisetB);
	roiprop{2} = getroiparametersfilename(atd, roisetB);
	if ~isempty(roisetC),
		rois{3} = getroifilename(atd, roisetC);
		L{3} = getlabeledroifilename(atd,roisetC);
	end;
	history_{1} = gethistory(atd, 'ROIs', roisetA);
	history_{2} = gethistory(atd, 'ROIs', roisetB);

	for j=1:numel(rois),
		rois_{j} = load(rois{j},'-mat');
		%L_{j} = load(L{j},'-mat'); % don't need this and it is huge, takes time to load
		if j<3,
			roiprop_{j} = load(roiprop{j},'-mat');
		end;
	end;

	% load colocalizations
	cfile{1} = getcolocalizationfilename(atd, claAonB);
	if ~isempty(claAonC),
		cfile{2} = getcolocalizationfilename(atd, claAonC);
	end;
	for j=1:numel(cfile),
		cla{j} = load(cfile{j},'-mat');
	end;

	% compare co-localized A vs. not-colocalized A

	roilabels = {roisetA, roisetB};
	bin_edges = [-0.05:0.05:4];
	bin_centers = bin_edges + 0.05;
	Ibin_edges = [-1:0.05:2];
	Ibin_centers = Ibin_edges + 0.05;

	for j=1:2,
		% plot normalized intensity for ROIs A and B

		if j==1,
			I = find(sum(cla{1}.colocalization_data.overlap_ab>0.33,2));
			I_ = setdiff(1:rois_{1}.CC.NumObjects, I);
			IinC = find(sum(cla{2}.colocalization_data.overlap_ab>0.33,2));
			IinCandColoc = intersect(I, IinC);
			IinCandNotColoc = intersect(I_, IinC);
		else,
			I = find(sum(cla{1}.colocalization_data.overlap_ab>0.33,1));
			I_ = setdiff(1:rois_{2}.CC.NumObjects, I);
			AinC = find(sum(cla{2}.colocalization_data.overlap_ab>0.33,2));
			IinCandColoc = [];
			IinCandNotColoc = [];
			for k=1:numel(I),
				if ~isempty(intersect(find(cla{1}.colocalization_data.overlap_ab(:,I(k))),AinC)),
					IinCandColoc(end+1) = I(k);
				end;
			end;
			for k=1:numel(I_),
				if ~isempty(intersect(find(cla{1}.colocalization_data.overlap_ab(:,I_(k))),AinC)),
					IinCandNotColoc(end+1) = I_(k);
				end;
			end;
		end;

		subplot(3,3,j);
		plot( [roiprop_{j}.ROIparameters.params3d(I).Volume], ...
			rescale(double([roiprop_{j}.ROIparameters.params3d(I).MaxIntensity]),...
				[history_{j}(1).parameters.threshold1 history_{j}(1).parameters.threshold2],...
				[0.80 0.30],'noclip')...
			,'go');
		hold on;
		plot( [roiprop_{j}.ROIparameters.params3d(I_).Volume], ...
			rescale(double([roiprop_{j}.ROIparameters.params3d(I_).MaxIntensity]),...
				[history_{j}(1).parameters.threshold1 history_{j}(1).parameters.threshold2],...
				[0.80 0.30],'noclip')...
			,'bx');
		plot( [roiprop_{j}.ROIparameters.params3d(IinCandColoc).Volume], ...
			rescale(double([roiprop_{j}.ROIparameters.params3d(IinCandColoc).MaxIntensity]),...
				[history_{j}(1).parameters.threshold1 history_{j}(1).parameters.threshold2],...
				[0.80 0.30],'noclip')...
			,'r+');
		hold on;
		plot( [roiprop_{j}.ROIparameters.params3d(IinCandNotColoc).Volume], ...
			rescale(double([roiprop_{j}.ROIparameters.params3d(IinCandNotColoc).MaxIntensity]),...
				[history_{j}(1).parameters.threshold1 history_{j}(1).parameters.threshold2],...
				[0.80 0.30],'noclip')...
			,'rs');
		hold on;
		ylabel([roilabels{j} ' Norm Peak Intensity']);
		xlabel([roilabels{j} ' Vol (pixels^3)']);
		box off;
		set(gca,'xscale','log','yscale','log');
		set(gca,'xlim',[1 10000],'ylim',[0.1 100]);
		title(['Experiment ' int2str(i) '.']);

		% Volume

		[volSignalEnriched] = histc(log10([roiprop_{j}.ROIparameters.params3d(I ).Volume]), bin_edges);
		[volNoiseEnriched]  = histc(log10([roiprop_{j}.ROIparameters.params3d(I_).Volume]), bin_edges);
		[volSignalEnrichedSpine] = histc(log10([roiprop_{j}.ROIparameters.params3d(IinCandColoc).Volume]), bin_edges);
		[volNoiseEnrichedSpine]  = histc(log10([roiprop_{j}.ROIparameters.params3d(IinCandNotColoc).Volume]), bin_edges);
		subplot(3,3,3+j);
		plot(bin_centers, volSignalEnriched/sum(volSignalEnriched),'g-','linewidth',2);
		hold on;
		plot(bin_centers, volNoiseEnriched/sum(volNoiseEnriched),'b-','linewidth',2);
		plot(bin_centers, volSignalEnrichedSpine/sum(volSignalEnrichedSpine),'r-','linewidth',1);
		plot(bin_centers, volNoiseEnrichedSpine/sum(volNoiseEnrichedSpine),'c-','linewidth',1);
		box off;
		rocout=vlt.stats.roc_stats([roiprop_{j}.ROIparameters.params3d(I).Volume],...
			[roiprop_{j}.ROIparameters.params3d(I_).Volume]);
		disp(['ROI set ' int2str(j) ': Max accuracy is ' num2str(rocout.acc_eq_max) ...
			' at volume of ' num2str(rocout.acc_eq_max_th) ' (equal mixture assumption).']);
		disp(['ROI set ' int2str(j) ': Max accuracy is ' num2str(rocout.acc_em_max) ...
			' at volume of ' num2str(rocout.acc_em_max_th) ' (empirical mixture assumption).']);
		hold on;
		plot(log10(rocout.acc_eq_max_th*[1 1]),[0 0.1],'k--');
		plot(log10(rocout.acc_em_max_th*[1 1]),[0 0.1],'m--');

		rocout2=vlt.stats.roc_stats([roiprop_{j}.ROIparameters.params3d(IinCandColoc).Volume],...
			[roiprop_{j}.ROIparameters.params3d(IinCandNotColoc).Volume]);

		disp(['SPINE ROI set ' int2str(j) ': Max accuracy is ' num2str(rocout2.acc_eq_max) ...
			' at volume of ' num2str(rocout2.acc_eq_max_th) ' (equal mixture assumption).']);
		disp(['SPINE ROI set ' int2str(j) ': Max accuracy is ' num2str(rocout2.acc_em_max) ...
			' at volume of ' num2str(rocout2.acc_em_max_th) ' (empirical mixture assumption).']);
		hold on;
		plot(log10(rocout2.acc_eq_max_th*[1 1]),[0 0.05],'k--');
		plot(log10(rocout2.acc_em_max_th*[1 1]),[0 0.05],'m--');
		xlabel('Log of volume');
		ylabel('Fraction of data');

		intSignalEnriched = histc(log10(rescale(double([roiprop_{j}.ROIparameters.params3d(I ).MaxIntensity]),...
			[history_{j}(1).parameters.threshold1 history_{j}(1).parameters.threshold2],...
			[0.8 0.3],'no_clip')), Ibin_edges);
		intNoiseEnriched = histc(log10(rescale(double([roiprop_{j}.ROIparameters.params3d(I_).MaxIntensity]),...
			[history_{j}(1).parameters.threshold1 history_{j}(1).parameters.threshold2],...
			[0.8 0.3],'no_clip')), Ibin_edges);
		intSignalEnrichedSpine=histc(log10(rescale(double([roiprop_{j}.ROIparameters.params3d(IinCandColoc).MaxIntensity]),...
			[history_{j}(1).parameters.threshold1 history_{j}(1).parameters.threshold2],...
			[0.8 0.3],'no_clip')), Ibin_edges);
		intNoiseEnrichedSpine=histc(log10(rescale(double([roiprop_{j}.ROIparameters.params3d(IinCandNotColoc).MaxIntensity]),...
			[history_{j}(1).parameters.threshold1 history_{j}(1).parameters.threshold2],...
			[0.8 0.3],'no_clip')), Ibin_edges);
		subplot(3,3,6+j);
		plot(Ibin_centers, intSignalEnriched/sum(intSignalEnriched),'g-');
		hold on;
		plot(Ibin_centers, intNoiseEnriched/sum(intNoiseEnriched),'b-');
		plot(Ibin_centers, intSignalEnrichedSpine/sum(intSignalEnrichedSpine),'r-');
		plot(Ibin_centers, intNoiseEnrichedSpine/sum(intNoiseEnrichedSpine),'c-');
		box off;
		rocout=vlt.stats.roc_stats(rescale(double([roiprop_{j}.ROIparameters.params3d(I).MaxIntensity]),...
			[history_{j}(1).parameters.threshold1 history_{j}(1).parameters.threshold2],...
			[0.8 0.3],'no_clip'),...
			rescale(double([roiprop_{j}.ROIparameters.params3d(I_).MaxIntensity]),...
			[history_{j}(1).parameters.threshold1 history_{j}(1).parameters.threshold2],...
			[0.8 0.3],'no_clip'));
		disp(['ROI set ' int2str(j) ': Max accuracy is ' num2str(rocout.acc_eq_max) ...
			' at intensity of ' num2str(rocout.acc_eq_max_th) ' (equal mixture assumption).']);
		disp(['ROI set ' int2str(j) ': Max accuracy is ' num2str(rocout.acc_em_max) ...
			' at intensity of ' num2str(rocout.acc_em_max_th) ' (empirical mixture assumption).']);
		hold on;
		plot(log10(rocout.acc_eq_max_th*[1 1]),[0 0.1],'k--');
		plot(log10(rocout.acc_em_max_th*[1 1]),[0 0.1],'m--');

		rocout2=vlt.stats.roc_stats(rescale(double([roiprop_{j}.ROIparameters.params3d(IinCandColoc).MaxIntensity]),...
			[history_{j}(1).parameters.threshold1 history_{j}(1).parameters.threshold2],...
			[0.8 0.3],'no_clip'),...
			rescale(double([roiprop_{j}.ROIparameters.params3d(IinCandNotColoc).MaxIntensity]),...
			[history_{j}(1).parameters.threshold1 history_{j}(1).parameters.threshold2],...
			[0.8 0.3],'no_clip'));
		disp(['SPINE ROI set ' int2str(j) ': Max accuracy is ' num2str(rocout2.acc_eq_max) ...
			' at intensity of ' num2str(rocout2.acc_eq_max_th) ' (equal mixture assumption).']);
		disp(['SPINE ROI set ' int2str(j) ': Max accuracy is ' num2str(rocout2.acc_em_max) ...
			' at intensity of ' num2str(rocout2.acc_em_max_th) ' (empirical mixture assumption).']);
		hold on;
		plot(log10(rocout2.acc_eq_max_th*[1 1]),[0 0.05],'k--');
		plot(log10(rocout2.acc_em_max_th*[1 1]),[0 0.05],'m--');

		xlabel('Log of Norm Max Intensity');
		ylabel('Fraction of data');


	end;

end;
