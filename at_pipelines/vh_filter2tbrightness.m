function parameters = vh_filter2tbrightness(atd, inputname, outputname)
% VH-FILTER2BRIGHTNESS
%



h = gethistory(atd,'ROIs',inputname);

if isempty(h),
	disp(['Could not load history for ROIs ' inputname '.']);
	disp('skipping');
	parameters = [];
	return;
end;

p.property_name = 'MaxIntensity3';
p.min_property = h(1).parameters.threshold1;
p.max_property = Inf;

at_roi_propertyfilter(atd,inputname,outputname,p);

parameters = p;

