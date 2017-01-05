function [roiscolocalization] = find_colocalization(rois3doverlap, thresh)

% Inputs: rois3doverlap is the fraction of a flared ROI that overlaps
%         another ROI
%         thresh is the threshold value for overlaps
% Output: roiscolocalization is 1 when overlap greater than or equal to
%         thresh and is 0 otherwise


roiscolocalization = zeros(length(rois3doverlap), 1);

for i = 1:length(rois3doverlap),
    if ~isempty(rois3doverlap{i}),
        roiscolocalization(i) =  (max(rois3doverlap{i}(:)) >= thresh);
    end;
end;