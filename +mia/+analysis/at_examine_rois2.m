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
		%L_{j} = load(L{j},'-mat'); % we don't need these, and they are huge
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
			I = find(sum(cla{1}.colocalization_data.overlap_ab>0.1,2));
			I_ = setdiff(1:rois_{1}.CC.NumObjects, I);
			IinC = find(sum(cla{2}.colocalization_data.overlap_ab>0.33,2));
			IinCandColoc = intersect(I, IinC);
			IinCandNotColoc = intersect(I_, IinC);
		else,
			I = find(sum(cla{1}.colocalization_data.overlap_ab>0.33,1));
			I_ = setdiff(1:rois_{2}.CC.NumObjects, I);
			IinC = [];
			IinCandColoc = [];
			IinCandNotColoc = [];
		end;

		subplot(3,3,j);
		plot( [roiprop_{j}.ROIparameters.params2d(I).Area], ...
			rescale(double([roiprop_{j}.ROIparameters.params3d(I).MaxIntensity]),...
				[history_{j}(1).parameters.threshold1 history_{j}(1).parameters.threshold2],...
				[0.80 0.30],'noclip')...
			,'go');
		hold on;
		plot( [roiprop_{j}.ROIparameters.params2d(I_).Area], ...
			rescale(double([roiprop_{j}.ROIparameters.params3d(I_).MaxIntensity]),...
				[history_{j}(1).parameters.threshold1 history_{j}(1).parameters.threshold2],...
				[0.80 0.30],'noclip')...
			,'bx');
		plot( [roiprop_{j}.ROIparameters.params2d(IinCandColoc).Area], ...
			rescale(double([roiprop_{j}.ROIparameters.params3d(IinCandColoc).MaxIntensity]),...
				[history_{j}(1).parameters.threshold1 history_{j}(1).parameters.threshold2],...
				[0.80 0.30],'noclip')...
			,'r+');
		hold on;
		plot( [roiprop_{j}.ROIparameters.params2d(IinCandNotColoc).Area], ...
			rescale(double([roiprop_{j}.ROIparameters.params3d(IinCandNotColoc).MaxIntensity]),...
				[history_{j}(1).parameters.threshold1 history_{j}(1).parameters.threshold2],...
				[0.80 0.30],'noclip')...
			,'rs');
		hold on;
		ylabel([roilabels{j} ' Norm Peak Intensity']);
		xlabel([roilabels{j} ' Area (pixels^2)']);
		box off;
		set(gca,'xscale','log','yscale','log');
		set(gca,'xlim',[1 10000],'ylim',[0.1 100]);
		title(['Experiment ' int2str(i) '.']);

		% Area

		[volSignalEnriched] = histc(log10([roiprop_{j}.ROIparameters.params2d(I ).Area]), bin_edges);
		[volNoiseEnriched]  = histc(log10([roiprop_{j}.ROIparameters.params2d(I_).Area]), bin_edges);
		subplot(3,3,3+j);
		plot(bin_centers, volSignalEnriched/sum(volSignalEnriched),'g-');
		hold on;
		plot(bin_centers, volNoiseEnriched/sum(volNoiseEnriched),'b-');
		box off;
		xlabel('Log of area');
		ylabel('Fraction of data');

		[intSignalEnriched] = histc(log10(rescale(double([roiprop_{j}.ROIparameters.params3d(I ).MaxIntensity]),...
			[history_{j}(1).parameters.threshold1 history_{j}(1).parameters.threshold2],...
			[0.8 0.3],'no_clip')), Ibin_edges);
		[intNoiseEnriched] = histc(log10(rescale(double([roiprop_{j}.ROIparameters.params3d(I_).MaxIntensity]),...
			[history_{j}(1).parameters.threshold1 history_{j}(1).parameters.threshold2],...
			[0.8 0.3],'no_clip')), Ibin_edges);
		subplot(3,3,6+j);
		plot(Ibin_centers, intSignalEnriched/sum(intSignalEnriched),'g-');
		hold on;
		plot(Ibin_centers, intNoiseEnriched/sum(intNoiseEnriched),'b-');
		box off;
		xlabel('Log of Norm Max Intensity');
		ylabel('Fraction of data');


	end;

end;
