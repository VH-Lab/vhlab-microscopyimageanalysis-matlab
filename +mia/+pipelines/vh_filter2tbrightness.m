function parameters = vh_filter2tbrightness(mdir, inputname, outputname)
% VH-FILTER2BRIGHTNESS
%

h = mdir.gethistory('ROIs',inputname);

if isempty(h),
	error(['Could not load history for ROIs ' inputname '.']);
end;

p.property_name = 'MaxIntensity3';
p.min_property = h(1).parameters.threshold1;
p.max_property = Inf;

mia_roi_propertyfilter_obj = mia.creator.roi.propertyfilter(mdir,inputname,outputname);
parameters = p;
mia_roi_propertyfilter_obj.make(parameters);
