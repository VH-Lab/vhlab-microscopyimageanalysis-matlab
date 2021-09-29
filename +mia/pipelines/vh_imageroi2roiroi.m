function [parameters] = vh_imageroi2roiroi(atd, varargin)
% VH_IMAGEROI2ROIROI - Convert ROIs that have been placed in image files into actual AT ROIs
%
% VH_IMAGEROI2ROIROI(ATD, ...)
% 
% Runs a pipeline (VH version 1) that looks for image files that define ROIs on the
% AT_DIR object ATD.
%
% It examines all image files that have the name SOMETHING_ROI_SOMETHING and
% makes ROIs that have the same name.
% 
%  The output will be named [outname '_*'].
% 
% Several parameters can be altered by name/value pairs (see help NAMEVALUEPAIR).
% Parameter (default)       | Description
% --------------------------------------------------------------------
% connectivity (26)         | Connectivity for ROIs
% do_resegemnt (1)          | Resegment the ROIs that come through
%
% Example:
%    atd = at_dir([MYEXPERIMENTPATH]);
%    vh_imageroi2roiroi(atd);
%


connectivity = 26;
do_resegment = 1;

assign(varargin{:});

parameters = workspace2struct;

disp(['Working on new directory: ' getpathname(atd)])

imagelist = getitems(atd,'images');

indexes = [];

for i=1:numel(imagelist),
	if findstr(imagelist(i).name,'_ROI_'),
		indexes(end+1) = i;
	end;
end;

 % now make ROIs
p.connectivity = connectivity;
resegment_props.resegment_algorithm = 'watershed';
resegment_props.connectivity = 0;
resegment_props.values_outside_roi = 0;
resegment_props.use_bwdist = 0;

for i=1:numel(indexes),
	disp(['Making rois from ' imagelist(indexes(i)).name ' ... ']);
	at_roi_connect(atd, imagelist(indexes(i)).name, [imagelist(indexes(i)).name '_ROI'], p);

	if do_resegment,
		resegment_props.imagename = imagelist(indexes(i)).name;
		disp(['Resegmenting those ROIs, with borders']);
		resegment_props.assignborders = 1;
		at_roi_resegment(atd,[imagelist(indexes(i)).name '_ROI'], [imagelist(indexes(i)).name '_ROIres'],  resegment_props);
		disp(['Resegmenting those ROIs, without borders']);
		resegment_props.assignborders = 0;
		at_roi_resegment(atd,[imagelist(indexes(i)).name '_ROI'], [imagelist(indexes(i)).name '_ROIres_noborder'],  resegment_props);
	end;
end;

