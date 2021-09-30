%%
fname = 'C:\Users\Derek\Desktop\Analysis 5, spine 2\2 24 VV';

automateROIcreation(fname,'exclude_channel','spines');

automateCOLOCreciprocal(fname,'PSDDEC','VGDEC');

%% 

fname = 'D:\Analysis Data\Synaptic Imaging\Analysis 11, two volumes';

automateROIcreationdec(fname);
