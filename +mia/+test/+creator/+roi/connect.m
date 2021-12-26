function connect(dirname,graphical)
% mia.test.creator.roi.connect - test mia.creator.roi.connect
% 
% mia.test.creator.roi.connect(DIRNAME, GRAPHICAL)
%
% Tests mia.creator.roi.connect test data in the specified
% DIRNAME, or uses [MIADIR]/testdata/simple by default if is empty or not
% provided. The mia directory must have an image called 'ch1_bw' and a 
% thresholded image called 'ch1_bw_imagethreshold'
%
% If GRAPHICAL is provided and is 1, then parameter input by interactive
% graphical methods are also tested.
% 
% See also: mia.miadir, mia.creator.image.threshold
%

if nargin<1 | isempty(dirname),
    dirname = [userpath filesep 'tools' filesep 'vhlab-ArrayTomography-matlab' filesep 'testdata' filesep 'simple'];
end;

if nargin<2,
    graphical = 0;
end;

mdir = mia.miadir(dirname);

test_input_image = 'ch1_bw_imagethreshold';
test_output_roi = 'ch1_bw_roi';

if ~mdir.isitem('image',test_input_image),
	mia.test.creator.image.threshold(dirname);
end;

try,
    mdir.deleteitem('roi',test_output_roi);
end;

t = mia.creator.roi.connect(mdir, test_input_image, test_output_roi); 

parameters = struct('connectivity',26);

t.make(parameters);

 % try setting parameters
 
if graphical,
    p=t.getuserparameters_choosedlg()
end;


