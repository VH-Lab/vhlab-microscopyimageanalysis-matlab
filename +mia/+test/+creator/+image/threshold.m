function threshold(dirname,graphical)
% mia.test.creator.image.threshold test mia.creator.image.threshold
% 
% mia.test.creator.image.threshold(DIRNAME, GRAPHICAL)
%
% Tests mia.creator.image.threshold on test data in the specified
% DIRNAME, or uses [MIADIR]/testdata/simple by default if is empty or not
% provided. The mia directory must have an image called 'ch1_bw'.
%
% If GRAPHICAL is provided and is 1, then parameter input by interactive
% graphical methods are also tested.
% 
% See also: mia.miadir, mia.creator.image.threshold
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
test_image_name = 'ch1_bw_imagethreshold';

try,
    mdir.deleteitem('images',test_image_name);
end;

t = mia.creator.image.threshold(mdir, test_input_image,test_image_name);

parameters = struct('threshold',100);

t.make(parameters);

 % try setting parameters
 
if graphical,
    p=t.getuserparameters_choosedlg()
    p=t.getuserparameters_graphical()
end;


