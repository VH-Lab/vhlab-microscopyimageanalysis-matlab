function neighbors(dirname,graphical)
% mia.test.creator.colocalization.neighbors - test mia.creator.colocalization.neighbors
%
% mia.test.creator.colocalization.neighbors(DIRNAME, GRAPHICAL)
%
% Tests mia.creator.colocalization.neighbors test data in the specified
% DIRNAME, or uses [MIADIR]/testdata/simple by default if is empty or not
% provided. The mia directory must have a roi called 'ch1_bw_roi' and
% 'ch2_bw_roi'
%
% If GRAPHICAL is provided and is 1, then parameter input by interactive
% graphical methods are also tested.
%
% See also: mia.miadir, mia.creator.colocalization.neighbors
%

if nargin<1 | isempty(dirname),
    %     dirname = [userpath filesep 'tools' filesep 'vhlab-ArrayTomography-matlab' filesep 'testdata' filesep 'simple'];
    dirname = 'C:\Users\cxyka\OneDrive - brandeis.edu\Brandeis\research\2021 fall\vhlab-ArrayTomography-matlab\+mia\+testData\simple';

end;

if nargin<2,
    graphical = 0;
end;

mdir = mia.miadir(dirname);

test_input_cla = 'ch1_bw_cla_shift';
test_output_cla = 'ch1_bw_cla_neighbors';

if ~mdir.isitem('CLAs',test_input_cla),
    mia.test.creator.colocalization.shift(dirname);
end;

try,
    mdir.deleteitem('CLAs',test_output_cla);
end;

t = mia.creator.colocalization.neighbors(mdir, test_input_cla, test_output_cla);

parameters = struct('number_neighbors',2); 

t.make(parameters);

% try setting parameters

if graphical,
    p=t.getuserparameters_choosedlg()
end;


