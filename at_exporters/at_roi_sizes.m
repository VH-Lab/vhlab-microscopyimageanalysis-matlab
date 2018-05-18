function ROIsize = at_roi_sizes(filename)
% AT_ROI_SIZES - for an ROI filename, return the ROI sizes
%
% ROI_SIZES = AT_ROI_SIZES(FILENAME)
%
% Returns an array of the ROI sizes
%
% In addition, writes the data to a file called FILENAME_roisize.xls.
%

ROIsize = [];

a = load(filename,'-mat');

for i=1:a.CC.NumObjects,
    ROIsize(i) = numel(a.CC.PixelIdxList{i});
end;

[filepath,fname,ext] = fileparts(filename);

excelfilename = fullfile(filepath,[fname '_roisize.xls']);

xlswrite(excelfilename, ROIsize);


