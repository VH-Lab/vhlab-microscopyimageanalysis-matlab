function [rois_w_errors] = identifyroi_L_errors(rois3d,L)
% debugging function to identify ROIs with errors

rois_w_errors = [];

for i=1:length(rois3d),
    z = find(L(:)==rois3d(i).index);
    match = 0;
    if length(z)==length(rois3d(i).pixelinds),
        if all(sort(z)==sort(rois3d(i).pixelinds)),
            match = 1;
        end;
    end;
    if match==0,
        rois_w_errors(end+1) = i;
    end;
end;
