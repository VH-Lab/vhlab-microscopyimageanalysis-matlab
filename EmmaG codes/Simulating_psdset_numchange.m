function [surrogate_CC,surrogate_L] = Simulating_psdset_numchange(control_psd_file,ttxtreated_psd_file)

% for testing ttx treated size's contribution to the # of CLA's increase
% this code uses the center of each ROI in the control psd, and give the
% shape of a random ROI from the TTX treated psd.

% controlL = load([Control_psd_file '_L.mat']);
% control_L = controlL.L;
controlCC = load([control_psd_file '/psd_threshold_26_vf_zf_ROI.mat']);
control_CC = controlCC.CC;


% ttxL = load([TTXtreated_psd_file '_L.mat']);
% ttx_L = ttxL.L;
ttxCC = load([ttxtreated_psd_file '/psd_threshold_26_vf_zf_ROI.mat']);
ttx_CC = ttxCC.CC;

increase_num = ttx_CC.NumObjects - control_CC.NumObjects;

control_xyz = ROI_indexes2xyz(control_CC);
% 
% ttx_xyz = ROI_indexes2xyz(ttx_CC);

control_masscenters = ROI_masscenter(control_xyz);
control_mass = ROI_mass(control_xyz);

surrogate_CC = control_CC;

xsize = control_CC.ImageSize(1);
ysize = control_CC.ImageSize(2);
zsize = control_CC.ImageSize(3);
    
for i =1:increase_num % for each new ROI
    cell_num = control_CC.NumObjects+i;
    control_masscenters{cell_num} = [randi(xsize),randi(ysize),randi(zsize)];
    nrand = randi(control_CC.NumObjects);
    new_roishape = control_mass{nrand};
    new_xvalues = new_roishape(1,:)+control_masscenters{cell_num}(1);
    new_yvalues = new_roishape(2,:)+control_masscenters{cell_num}(2);
    new_zvalues = new_roishape(3,:)+control_masscenters{cell_num}(3);
    good_values = (new_xvalues>0&new_xvalues<=control_CC.ImageSize(1)) & (new_yvalues>0&new_yvalues<=control_CC.ImageSize(2)) & (new_zvalues>0&new_zvalues<=control_CC.ImageSize(3));
    new_xvalues = new_xvalues(good_values);
    new_yvalues = new_yvalues(good_values);
    new_zvalues = new_zvalues(good_values);
    surrogate_CC.PixelIdxList{cell_num} = sub2ind(control_CC.ImageSize, new_xvalues, new_yvalues, new_zvalues)';

end
surrogate_CC.NumObjects = ttx_CC.NumObjects;
surrogate_L = labelmatrix(surrogate_CC);



