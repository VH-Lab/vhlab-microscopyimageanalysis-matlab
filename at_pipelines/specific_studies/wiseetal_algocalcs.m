function [number_colocs, volumecolloc1, volumecolloc2] = wiseetal_algocalcs(atd,algo, roiname1, roiname2)

CLAs = getitems(atd,'CLAs');

if algo > 100,
	cla_ab = [ roiname1 '_x_' roiname2 ];
	cla_ba = [ roiname2 '_x_' roiname1 ];
else,
	cla_ab = [roiname1 'autocolocw' roiname2];
	cla_ba = [roiname2 'autocolocw' roiname1];
end;

I1 = find(strcmp(cla_ab, {CLAs.name}));
I2 = find(strcmp(cla_ba, {CLAs.name}));

trans = 0;

if ~isempty(I1),
	index = I1;
	cla_name = cla_ab;
elseif ~isempty(I2),
	trans = 1;
	index = I2;
	cla_name = cla_ba;
else,
	error(['No colocalization ' cla_ab ' or reverse found.']);
end;

f = getcolocalizationfilename(atd,cla_name);

cla = load(f,'-mat');

if ~trans,
	J = sum(cla.colocalization_data.overlap_ab>0,2);
	K = sum(cla.colocalization_data.overlap_ba'>0,1);
else,
	J = sum(cla.colocalization_data.overlap_ba'>0,2);
	K = sum(cla.colocalization_data.overlap_ab>0,1);
end;

Jf = find(J);
Kf = find(K);

roi1_f = getroiparametersfilename(atd,...
	cla.colocalization_data.parameters.roi_set_1);
roi2_f = getroiparametersfilename(atd,...
	cla.colocalization_data.parameters.roi_set_2);

roi1_d = load(roi1_f);
roi2_d = load(roi2_f);

vol1 = [roi1_d.ROIparameters.params3d.Volume];
vol2 = [roi2_d.ROIparameters.params3d.Volume];

volumecolloc1 = mean(vol1(Jf));
volumecolloc2 = mean(vol2(Kf));

number_colocs = min(numel(Jf,Kf)); 
