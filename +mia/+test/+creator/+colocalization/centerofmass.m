function centerofmass(dirname,graphical)
% mia.test.creator.colocalization.centerofmass - test mia.creator.colocalization.centerofmass
%
% mia.test.creator.colocalization.centerofmass(DIRNAME, GRAPHICAL)
%
% Tests mia.creator.colocalization.centerofmass test data in the specified
% DIRNAME, or uses [MIADIR]/testdata/simple by default if is empty or not
% provided. The mia directory must have a roi called 'ch1_bw_roi' and
% 'ch2_bw_roi'
%
% If GRAPHICAL is provided and is 1, then parameter input by interactive
% graphical methods are also tested.
%
% See also: mia.miadir, mia.creator.colocalization.centerofmass
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
test_output_cla = 'ch1_bw_cla_centerofmass';

if ~mdir.isitem('ROIs',test_input_roi),
    mia.test.creator.roi.connect(dirname);
end;

try,
    mdir.deleteitem('CLAs',test_output_cla);
end;

t = mia.creator.colocalization.centerofmass(mdir, test_input_roi, test_output_cla);

parameters = struct('distance_threshold', 5, 'distance_infinity', 50, 'show_graphical_progress', 1, 'roi_set_2', 'ch2_bw_roi'); 

t.make(parameters);

% try setting parameters

if graphical,
    p=t.getuserparameters_choosedlg()
end;


