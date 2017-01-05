function errorlog = checkrois_L(rois3d, L)
% Checks rois3d against L to determine whether it is correctly labeled. 

errorlog = {};
  

for i=1:length(rois3d),
    a = all(L(rois3d(i).pixelinds)==i); % is L correctly labeled with the ROI that should be here?
    inds = find(L==i);
    b = isempty(setdiff(inds,rois3d(i).pixelinds)); % are there any other points labeled with this ROI number?

    if ~a, 
        errorlog{end+1} = ['ROI ' int2str(i) ' fails; L(rois3d(i).pixelinds)) not properly labeled.'];
    end;
    if ~b,
        errorlog{end+1} = ['ROI ' int2str(i) ' fails; L(rois3d(i).pixelinds)) not properly labeled.'];
    end;
end;