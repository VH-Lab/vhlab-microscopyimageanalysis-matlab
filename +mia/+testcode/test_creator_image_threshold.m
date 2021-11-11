function test_creator_image_threshold(dirname)
% TEST_CREATOR_IMAGE_THRESHOLD - test mia.creator.image.threshold
% 
% Tests mia.creator.image.threshold on test data in 
%

if nargin<1,
    dirname = [userpath filesep 'tools' filesep 'vhlab-ArrayTomography-matlab' filesep 'testdata' filesep 'simple'];
end;

mdir = mia.miadir(dirname);

test_input_image = 'ch1';
test_image_name = 'ch1_1_imagethreshold';


try,
    mdir.deleteitem('images',test_image_name);
end;

t = mia.creator.image.threshold(mdir, test_input_image,test_image_name);

parameters = struct('threshold',100);

t.make(parameters);
