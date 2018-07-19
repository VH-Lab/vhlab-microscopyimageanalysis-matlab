function [surrogate_CC,surrogate_L] = Simulating_psdset_advanced(control_psd_file,ttx_psd_file)

% for testing ttx treated size's contribution to the # of CLA's increase
% this code uses the center of each ROI in the control psd, and give the
% shape of a random ROI from the TTX treated psd.

controlCC = load([control_psd_file '_ROI.mat']);
control_CC = controlCC.CC;

ttxCC = load([ttx_psd_file '_ROI.mat']);
ttx_CC = ttxCC.CC;

ss_control = ROI_sortsizes(control_CC);
ss_ttx = ROI_sortsizes(ttx_CC);

surrogate_CC = control_CC;
num_cells = control_CC.NumObjects;
imsize = control_CC.ImageSize;

h = waitbar(0,'initializing...');
for i =1:num_cells
    num_ttxcell = round(ttx_CC.NumObjects*(i/num_cells));
    increased_size = ss_ttx(num_ttxcell,2)-ss_control(i,2);
    if increased_size >= 1
        limits = fix(increased_size^(1/3));
        num_control = ss_control(i,1);
        surrogate_CC.PixelIdxList{num_control} = ROI_addpixels(control_CC.PixelIdxList{num_control},imsize,increased_size,limits);
    end
    waitbar(i/num_cells,h,sprintf('%2.2f percent done',i/num_cells*100));
end
delete(h);
surrogate_L = labelmatrix(surrogate_CC);


