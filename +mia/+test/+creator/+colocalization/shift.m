function shift(dirname,graphical)
% mia.test.creator.colocalization.shift - test mia.creator.colocalization.shift
%
% mia.test.creator.colocalization.shift(DIRNAME, GRAPHICAL)
%
% Tests mia.creator.colocalization.shift test data in the specified
% DIRNAME, or uses [MIADIR]/testdata/simple by default if is empty or not
% provided. The mia directory must have a roi called 'ch1_bw_roi' and
% 'ch2_bw_roi'
%
% If GRAPHICAL is provided and is 1, then parameter input by interactive
% graphical methods are also tested.
%
% See also: mia.miadir, mia.creator.colocalization.shift
%

if nargin<1 | isempty(dirname),
    %     dirname = [userpath filesep 'tools' filesep 'vhlab-ArrayTomography-matlab' filesep 'testdata' filesep 'simple'];
    dirname = 'C:\Users\cxyka\OneDrive - brandeis.edu\Brandeis\research\2021 fall\vhlab-ArrayTomography-matlab\+mia\+testData\simple';

end;

if nargin<2,
    graphical = 0;
end;

mdir = mia.miadir(dirname);

test_input_roi = 'ch1_bw_roi';
test_output_cla = 'ch1_bw_cla_shift';

if ~mdir.isitem('ROIs',test_input_roi),
    mia.test.creator.roi.connect(dirname);
end;

try,
    mdir.deleteitem('CLAs',test_output_cla);
end;

t = mia.creator.colocalization.shift(mdir, test_input_roi, test_output_cla);

parameters = struct('shifts', -2:2, 'threshold', 0.33, 'roi_set_2' , 'ch2_bw_roi'); 

t.make(parameters);

% try setting parameters

if graphical,
    p=t.getuserparameters_choosedlg()
end;


