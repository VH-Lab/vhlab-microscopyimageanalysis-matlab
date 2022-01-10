function zspanfilter(dirname,graphical)
% mia.test.creator.roi.zspanfilter - test mia.creator.roi.zspanfilter
% 
% mia.test.creator.roi.zspanfilter(DIRNAME, GRAPHICAL)
%
% Tests mia.creator.roi.zspanfilter test data in the specified
% DIRNAME, or uses [MIADIR]/testdata/simple by default if is empty or not
% provided. The mia directory must have an image called 'ch1_bw', a 
% thresholded image called 'ch1_bw_imagethreshold' and an roi called
% 'ch1_bw_roi'
%
% If GRAPHICAL is provided and is 1, then parameter input by interactive
% graphical methods are also tested.
% 
% See also: mia.miadir, mia.creator.roi.zspanfilter
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
test_output_roi = 'ch1_bw_roizspanfilter';

if ~mdir.isitem('ROIs',test_input_roi),
	mia.test.creator.roi.connect(dirname);
end;

try,
    mdir.deleteitem('ROIs',test_output_roi);
end;

t = mia.creator.roi.zspanfilter(mdir, test_input_roi, test_output_roi); 

parameters = struct('z_span_minimum',1,'z_span_maximum',Inf); 

t.make(parameters);

 % try setting parameters
 
if graphical,
    p=t.getuserparameters_choosedlg()
    p=t.getuserparameters_graphical()
end;
