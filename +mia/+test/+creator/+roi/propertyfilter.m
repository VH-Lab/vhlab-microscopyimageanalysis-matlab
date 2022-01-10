function propertyfilter(dirname,graphical)
% mia.test.creator.roi.propertyfilter - test mia.creator.roi.propertyfilter
% 
% mia.test.creator.roi.propertyfilter(DIRNAME, GRAPHICAL)
%
% Tests mia.creator.roi.propertyfilter test data in the specified
% DIRNAME, or uses [MIADIR]/testdata/simple by default if is empty or not
% provided. The mia directory must have an image called 'ch1_bw', a 
% thresholded image called 'ch1_bw_imagethreshold' and an roi called
% 'ch1_bw_roi'
%
% If GRAPHICAL is provided and is 1, then parameter input by interactive
% graphical methods are also tested.
% 
% See also: mia.miadir, mia.creator.roi.propertyfilter
%

if nargin<1 | isempty(dirname),
%     dirname = [userpath filesep 'tools' filesep 'vhlab-ArrayTomography-matlab' filesep 'testdata' filesep 'simple'];
    dirname = 'C:\Users\cxyka\OneDrive - brandeis.edu\Brandeis\research\2021 fall\vhlab-ArrayTomography-matlab\+mia\+testData\simple';

end;

if nargin<2,
    graphical = 0;
end;

mdir = mia.miadir(dirname);

test_input_image = 'ch1_bw_roi';
test_output_roi = 'ch1_bw_roipropertyfilter';

if ~mdir.isitem('ROIs',test_input_image),
	mia.test.creator.roi.connect(dirname);
end;

try,
    mdir.deleteitem('ROIs',test_output_roi);
end;

t = mia.creator.roi.propertyfilter(mdir, test_input_image, test_output_roi); 

parameters = struct('property_name','','min_property',Inf,'max_property',Inf); 

t.make(parameters);

 % try setting parameters
 
if graphical,
    p=t.getuserparameters_choosedlg()
end;


