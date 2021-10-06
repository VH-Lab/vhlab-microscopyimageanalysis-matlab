function [out,msg] = at_colocalization_summary(the_atdir, colocalization)
% AT_COLOCALIZATION_SUMMARY - provide a summary of co-localizations
%
%
% [OUT, MSG] = AT_COLOCALIZATION_SUMMARY(THE_ATDIR, COLOCALIZATION)
%
% Returns a summary structure and string message describing the results
% of the triple colocalization analysis named COLOCALIZATION for the array tomography
% record THE_ATDIR.
%
% Example:
%     the_atdir = atdir('/Users/vanhoosr/Downloads/2015-06-03');
%     colname = 'SPINE_PSD_VGLUT_anyoverlap_2shift'; % example roi name
%     [out,msg] = at_colocalization_summary(the_atdir, colname);
%
% See also: ATDIR
%

cfname = getcolocalizationfilename(the_atdir, colocalization);

c = load(cfname,'-mat');

colocalization_data = c.colocalization_data;
clear c;

has3 = isfield(colocalization_data,'overlap_bc');

if isfield(colocalization_data.parameters,'threshold'),
	overlap_ab = colocalization_data.overlap_ab>colocalization_data.parameters.threshold;
	overlap_ba = colocalization_data.overlap_ba>colocalization_data.parameters.threshold;
	if has3,
		overlap_ac = colocalization_data.overlap_ac>colocalization_data.parameters.threshold;
		overlap_ca = colocalization_data.overlap_ca>colocalization_data.parameters.threshold;
		overlap_bc = colocalization_data.overlap_bc>colocalization_data.parameters.threshold;
		overlap_cb = colocalization_data.overlap_cb>colocalization_data.parameters.threshold;
	end;
elseif isfield(colocalization_data.parameters,'distance_threshold'),
	overlap_ab = colocalization_data.overlap_ab<=colocalization_data.parameters.distance_threshold;
	overlap_ba = colocalization_data.overlap_ba<=colocalization_data.parameters.distance_threshold;
	if has3,
		overlap_ac = colocalization_data.overlap_ac<=colocalization_data.parameters.distance_threshold;
		overlap_ca = colocalization_data.overlap_ca<=colocalization_data.parameters.distance_threshold;
		overlap_bc = colocalization_data.overlap_bc<=colocalization_data.parameters.distance_threshold;
		overlap_cb = colocalization_data.overlap_cb<=colocalization_data.parameters.distance_threshold;
	end;
end;

[Iab,Jab] = find(overlap_ab);
[Iba,Jba] = find(overlap_ba);

out.totalA = size(overlap_ab,1);
out.totalB = size(overlap_ab,2);

if has3,
	warning('new use of triple code; if any bugs, tell developers');
	out.totalC = size(colocalization_data.overlap_bc,2);

	

end;

out.NumAPaired_ab = numel(unique(Iab));
out.NumBPaired_ab = numel(unique(Jab));
out.NumANotPaired_ab = numel(setdiff(1:size(colocalization_data.overlap_ab,1),unique(Iab)));
out.NumBNotPaired_ab = numel(setdiff(1:size(colocalization_data.overlap_ab,2),unique(Jab)));

out.NumAPaired_ba = numel(unique(Jba));
out.NumBPaired_ba = numel(unique(Iba));
out.NumANotPaired_ba = numel(setdiff(1:size(colocalization_data.overlap_ba,2),unique(Jba)));
out.NumBNotPaired_ba = numel(setdiff(1:size(colocalization_data.overlap_ba,1),unique(Iba)));

if has3,
	[Iac,Jac] = find(overlap_ac);
	[Ica,Jca] = find(overlap_ca);

	[Ibc,Jbc] = find(overlap_bc);
	[Icb,Jcb] = find(overlap_cb);

	[Iabc,Jabc] = find(colocalization_data.overlap_thresh);

	out.NumAPaired_ac = numel(unique(Iac));
	out.NumCPaired_ac = numel(unique(Jac));
	out.NumANotPaired_ac = numel(setdiff(1:size(colocalization_data.overlap_ac,1),unique(Iac)));
	out.NumCNotPaired_ac = numel(setdiff(1:size(colocalization_data.overlap_ac,2),unique(Jac)));

	out.NumBPaired_bc = numel(unique(Ibc));
	out.NumCPaired_bc = numel(unique(Jbc));
	out.NumBNotPaired_bc = numel(setdiff(1:size(colocalization_data.overlap_bc,1),unique(Ibc)));
	out.NumCNotPaired_bc = numel(setdiff(1:size(colocalization_data.overlap_bc,2),unique(Jbc)));

	out.NumAPaired_abc = numel(unique(Iabc));
	out.NumANotPaired_abc = numel(setdiff(1:out.totalC,unique(Iabc)));
end;


msg = [ ...
	'AoB:Number of As paired with at least one B: ' int2str(out.NumAPaired_ab) '; '...
	'AoB:Number of Bs paired with at least one A: ' int2str(out.NumBPaired_ab) '; '... 
	'AoB:Number of As not paired with at least one B: ' int2str(out.NumANotPaired_ab) '; '...
	'AoB:Number of Bs not paired with at least one A: ' int2str(out.NumBNotPaired_ab) '; '... 
	'BoA:Number of As paired with at least one B: ' int2str(out.NumAPaired_ba) '; '...
	'BoA:Number of Bs paired with at least one A: ' int2str(out.NumBPaired_ba) '; '... 
	'BoA:Number of As not paired with at least one B: ' int2str(out.NumANotPaired_ba) '; '...
	'BoA:Number of Bs not paired with at least one A: ' int2str(out.NumBNotPaired_ba) '; '... 
	];

if has3,
	
end;
