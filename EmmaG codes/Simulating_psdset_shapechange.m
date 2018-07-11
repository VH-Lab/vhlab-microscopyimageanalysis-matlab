function [surrogate_CC,surrogate_L] = Simulating_psdset_shapechange(control_psd_file,ttxtreated_psd_file)

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

control_xyz = ROI_indexes2xyz(control_CC);

ttx_xyz = ROI_indexes2xyz(ttx_CC);

control_masscenters = ROI_masscenter(control_xyz);
ttx_mass = ROI_mass(ttx_xyz);

surrogate_CC = control_CC;
    
for i =1:length(control_xyz) % for each ROI
    % need to make an ROI that has the size of a randomly selected ttx ROI
    nrand = randi(ttx_CC.NumObjects);
    new_roishape = ttx_mass{nrand};
    new_xvalues = new_roishape(1,:)+control_masscenters{i}(1);
    new_yvalues = new_roishape(2,:)+control_masscenters{i}(2);
    new_zvalues = new_roishape(3,:)+control_masscenters{i}(3);
    good_values = (new_xvalues>0&new_xvalues<=control_CC.ImageSize(1)) & (new_yvalues>0&new_yvalues<=control_CC.ImageSize(2)) & (new_zvalues>0&new_zvalues<=control_CC.ImageSize(3));
    new_xvalues = new_xvalues(good_values);
    new_yvalues = new_yvalues(good_values);
    new_zvalues = new_zvalues(good_values);
    surrogate_CC.PixelIdxList{i} = sub2ind(control_CC.ImageSize, new_xvalues, new_yvalues, new_zvalues)';

end
surrogate_L = labelmatrix(surrogate_CC);


