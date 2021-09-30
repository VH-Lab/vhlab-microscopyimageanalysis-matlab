%%
fname = 'C:\Users\Derek\Desktop\Analysis 5, spine 2\2 24 VV';

mia.utilities.automate.automateROIcreation(fname,'exclude_channel','spines');

mia.utilities.automate.automateCOLOCreciprocal(fname,'PSDDEC','VGDEC');

%% 

fname = 'D:\Analysis Data\Synaptic Imaging\Analysis 11, two volumes';

mia.utilities.automate.automateROIcreationdec(fname);
