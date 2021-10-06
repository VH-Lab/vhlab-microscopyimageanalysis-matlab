function parameters = vh_filter2tbrightness(atd, inputname, outputname)
% VH-FILTER2BRIGHTNESS
%

h = gethistory(atd,'ROIs',inputname);

if isempty(h),
	error(['Could not load history for ROIs ' inputname '.']);
end;

p.property_name = 'MaxIntensity3';
p.min_property = h(1).parameters.threshold1;
p.max_property = Inf;

mia.roi.roi_editors.at_roi_propertyfilter(atd,inputname,outputname,p);

parameters = p;
