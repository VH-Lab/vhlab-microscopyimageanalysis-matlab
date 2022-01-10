function thresholdimport(dirname,graphical)
% mia.test.creator.image.thresholdimport test mia.creator.image.thresholdimport
% 
% mia.test.creator.image.thresholdimport(DIRNAME, GRAPHICAL)
%
% Tests mia.creator.image.thresholdimport on test data in the specified
% DIRNAME, or uses [MIADIR]/testdata/simple by default if is empty or not
% provided. The mia directory must have an image called 'ch1_bw' and a
% file to import the threshold 
%
% If GRAPHICAL is provided and is 1, then parameter input by interactive
% graphical methods are also tested.
% 
% See also: mia.miadir, mia.creator.image.thresholdimport
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
test_image_name = 'ch1_bw_imagethresholdimport';

try,
    mdir.deleteitem('images',test_image_name);
end;

t = mia.creator.image.threshold(mdir, test_input_image,test_image_name);

parameters = struct('input_filename',''); 

t.make(parameters);

 % try setting parameters
 
if graphical,
    p=t.getuserparameters_choosedlg()
end;


