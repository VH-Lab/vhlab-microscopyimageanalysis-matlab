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

[Iab,Jab] = find(colocalization_data.overlap_ab);
[Iba,Jba] = find(colocalization_data.overlap_ba);

out.totalA = size(colocalization_data.overlap_ab,1);
out.totalB = size(colocalization_data.overlap_ab,2);

out.NumAPaired_ab = numel(unique(Iab));
out.NumBPaired_ab = numel(unique(Jab));
out.NumANotPaired_ab = numel(setdiff(1:size(colocalization_data.overlap_ab,1),unique(Iab)));
out.NumBNotPaired_ab = numel(setdiff(1:size(colocalization_data.overlap_ab,2),unique(Jab)));

out.NumAPaired_ba = numel(unique(Jba));
out.NumBPaired_ba = numel(unique(Iba));
out.NumANotPaired_ba = numel(setdiff(1:size(colocalization_data.overlap_ba,2),unique(Jba)));
out.NumBNotPaired_ba = numel(setdiff(1:size(colocalization_data.overlap_ba,1),unique(Iba)));

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
