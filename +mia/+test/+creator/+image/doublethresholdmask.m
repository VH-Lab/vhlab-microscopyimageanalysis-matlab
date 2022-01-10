function doublethresholdmask(dirname,graphical)
% mia.test.creator.image.doublethresholdmask test mia.creator.image.doublethresholdmask
% 
% mia.test.creator.image.doublethresholdmask(DIRNAME, GRAPHICAL)
%
% Tests mia.creator.image.doublethresholdmask on test data in the specified
% DIRNAME, or uses [MIADIR]/testdata/simple by default if is empty or not
% provided. The mia directory must have an image called 'ch1_bw'.
%
% If GRAPHICAL is provided and is 1, then parameter input by interactive
% graphical methods are also tested.
% 
% See also: mia.miadir, mia.creator.image.doublethresholdmask
%

if nargin<1 | isempty(dirname),
%     dirname = [userpath filesep 'tools' filesep 'vhlab-ArrayTomography-matlab' filesep 'testdata' filesep 'simple'];
    dirname = 'C:\Users\cxyka\OneDrive - brandeis.edu\Brandeis\research\2021 fall\vhlab-ArrayTomography-matlab\+mia\+testData\simple';

end;

if nargin<2,
    graphical = 0;
end;

mdir = mia.miadir(dirname);

test_input_image = 'ch1_bw';
test_image_name = 'ch1_bw_imagedoublethresholdmask';

try,
    mdir.deleteitem('images',test_image_name);
end;

t = mia.creator.image.doublethresholdmask(mdir, test_input_image,test_image_name);

parameters = struct('threshold1',95, 'threshold2', 75, 'threshold_units', 'percentile','mask_pixels_set_in_image', 65e3, 'connectivity', 26, 'mask_itemname', ''); 

t.make(parameters);

 % try setting parameters
 
if graphical,
    p=t.getuserparameters_choosedlg()
end;

