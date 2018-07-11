function [control_indexes,ttx_indexes,control_masscenters,ttx_mass,new_L,new_CC] = Simulating_psdset(Control_psd,TTXtreated_psd)

% for testing ttx treated size's contribution to the # of CLA's increase
% this code uses the center of each ROI in the control psd, and give the
% shape of a random ROI from the TTX treated psd.

cd(Control_psd)
controlL = load('psd_threshold_26_vf_zf_L.mat');
control_L = controlL.L;
controlCC = load('psd_threshold_26_vf_zf_ROI.mat');
control_CC = controlCC.CC;

cd(TTXtreated_psd)
ttxL = load('psd_threshold_26_vf_zf_L');
ttx_L = ttxL.L;
ttxCC = load('psd_threshold_26_vf_zf_ROI');
ttx_CC = ttxCC.CC;

control_indexes = ROI_indexes(control_CC,control_L);
ttx_indexes = ROI_indexes(ttx_CC,ttx_L);

control_masscenters = ROI_masscenter(control_indexes);
ttx_mass = ROI_mass(ttx_indexes);

% for trials = 1:1000
    
for i =1:length(control_masscenters)
    nrand = randi(ttx_CC.NumObjects);
    new_roishape = ttx_mass{nrand};
    new_xvalues = new_roishape(1,:)+control_masscenters{i}(1);
    new_yvalues = new_roishape(2,:)+control_masscenters{i}(2);
    new_zvalues = new_roishape(3,:)+control_masscenters{i}(3);
    new_roi = [new_xvalues;new_yvalues;new_zvalues];
    new_indexes{i} = new_roi;
end
new_L = zeros(size(control_L));
for i = length(new_indexes)
    for j = length(new_indexes{i}(1,:))
        x = new_indexes{i}(1,j);
        y = new_indexes{i}(2,j);
        z = new_indexes{i}(3,j);
        new_L(x,y,z) = 1;
    end
end

im = logical(new_L);
new_CC = bwconncomp(im,26);
end


% L_out_file = [getpathname(atd) filesep 'ROIs' filesep output_itemname filesep output_itemname '_L' '.mat'];
% roi_out_file = [getpathname(atd) filesep 'ROIs' filesep output_itemname filesep output_itemname '_ROI' '.mat'];
% 
% try, mkdir([getpathname(atd) filesep 'ROIs' filesep output_itemname]); end;
% save(roi_out_file,'CC','-mat');
% save(L_out_file,'L','-mat');
% 
% h = gethistory(atd,'images',input_itemname);
% h(end+1) = struct('parent',input_itemname,'operation','at_roi_connect','parameters',parameters,...
% 	'description',['Found ' int2str(CC.NumObjects) ' ROIs with conn=' num2str(parameters.connectivity) ' to image ' input_itemname '.']);
% sethistory(atd,'ROIs',output_itemname,h);
% 
% str2text([getpathname(atd) filesep 'ROIs' filesep output_itemname filesep 'parent.txt'], input_itemname);



    
    



