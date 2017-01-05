% This directory contains all image plug-ins that can process images for AT.
%
%   Each function should have the following form:
%
%   [OUT] = ATI_IMAGE_PROCESSOR(AD, INPUT_DIRNAME, OUTPUT_DIRNAME, PARAMETERS)
%
%   If the function is called with no arguments, then out is a 2 element cell
%   array of strings; OUT{1}{n} is the name of the nth parameter, and
%   OUT{2}{n} is a human-readable description of the parameter.
%   OUT{3} is a list of text options that one can pass for PARAMETERS, such as
%   'choose_graphical', which might allow the user to graphically choose the parameters.
%   The option 'choose' should be supported, and prompt the user to make some choice about
%   the parameter in a user-guided manner.
%
%   AD is the ATDIR object that manages the experiment directory. INPUT_DIRNAME and
%   OUTPUT_DIRNAME are names of directories within the 'images' subfolder.
%
%   The function is responsible for writing the following files in
%   the OUTPUT_DIRNAME directory:
%     image.ext - the image file, in a format readable by Matlab's imread (ext is variable)
%     history.mat - a structure giving the history of the operations on this image
%     parent.txt - the name of the parent image directory (if applicable)
