%% PROMINENCY FILTER
function out = at_roi_prominencyfilter (atd, input_itemname, output_itemname, parameters)
% out = AT_ROI_PROMINENCY FILTER (ATD,INPUT_ITEMANME,OUTPUT_ITEMNAME,PARAMETERS) 
% atd should be a directory culminating in an "analysis" file for ATGUI
% code.
% input_itemname is specified in at_gui as a selected ROI set
% output_itemname is also specified in at_gui, and entered as you wish
% this filter has one parameter, the threshold of prominence needed to
% consider a punctum sufficiently prominent over its local background - the
% logic being that if it not prominent, it is unlikely to be real.
% you can also manually set these three parameters for at_roi_locbacgr if you
% want: % parameters.dist_cardinal (default 50); parameters.CV_binsize
% (default 5);
% parameters.CV_thresh (default 0.01).
% 
% EXAMPLE PARAMETERS (for troubleshooting)
% atd = atdir(['C:\Users\Derek\Desktop\Analysis 4, ground truth of ROIs\2 24 VV CTRL 2\analysis']);
% input_itemname = 'PSD_test_th_roi';
% output_itemname = 'PSD_test_th_roi_pf';
% parameters.imagename = '';

%% Give users options to input parameters, set defaults if not
if nargin==0,
	out{1} = {'prom_thresh','dist_cardinal','CV_binsize','imagename'};
	out{2} = {'Reject puncta if their peak is less than this value higher than local background (0 to calculate best guess)','Distace to scan for local background (default shown)', 'Number of pixels considered for coeffvar for local background (default shown)', ...
			'Image name to use (leave blank to use default in history'};
	out{3} = {'choose_inputdlg'};
	return;
end;

if ischar(parameters),
	switch lower(parameters),
		case 'choose',
			out_choice = at_roi_prominencyfilter;
			choices = cat(2,out_choice{3},'Cancel');
			buttonname = questdlg('By which method should we choose parameters?',...
				'Which method?', choices{:},'Cancel');
			if ~strcmp(buttonname,'Cancel'),
				out = at_roi_prominencyfilter(atd,input_itemname,output_itemname,buttonname);
			else,
				out = [];
			end;
		case 'choose_inputdlg',
			out_p = at_roi_prominencyfilter;
			defaultparameters.prom_thresh = 0;
			defaultparameters.dist_cardinal = 50;
			defaultparameters.CV_binsize = 5;
			defaultparameters.imagename = '';
			parameters = dlg2struct('Choose parameters', out_p{1}, out_p{2}, defaultparameters);
			if isempty(parameters),
				out = [];
			else,
				out = at_roi_prominencyfilter(atd,input_itemname,output_itemname,parameters);
			end
	end; % switch
	return;
end;

%% Load or generate local background values & peak values
ROIname = getroifilename(atd,input_itemname);
foldername = fileparts(ROIname);
if exist([foldername filesep input_itemname '_ROI_roiintparam.mat']) == 2    
   load([foldername filesep input_itemname '_ROI_roiintparam.mat'])
   local_bg = ROIintparam.local_bg; highest_pixel = ROIintparam.highest_int;
disp(['Found local background value, loaded in!'])
else
disp(['Cannot find local background value, recalculating with provided settings!'])
[local_bg,highest_pixel] = at_roi_locbacgr(atd,ROIname,parameters);
end

%% Load the ROIs in the set (both L and CC files from ATGUI code)
L_in_file = getlabeledroifilename(atd,input_itemname);
roi_in_file = getroifilename(atd,input_itemname);
load(roi_in_file,'CC','-mat');
load(L_in_file,'L','-mat');
oldobjects = CC.NumObjects;

%% Load the original image
if isempty(parameters.imagename), % choose it 
    [dummy,im_fname] = at_roi_underlying_image(atd,input_itemname);
    parameters.imagename = im_fname;
end

[num_images,img_stack] = at_loadscaledstack(parameters.imagename);

%% Change ROI format from indexes to y x z (ind2sub)
[puncta_info] = at_puncta_info(img_stack,CC);

%% Calculate Best Guess for Prominency Filter (if not disabled in settings)
if parameters.prom_thresh == 0,
data_2D = img_stack(:,:,1); data = data_2D(:)';
figure
g = oghist(data,[min(data)-0.1 : 10 : max(data)],'Visible','off'); % better bins?
xBinEdge = g.BinEdges;
for i = 1:(size(xBinEdge,2)-1)
    xdata(i) = (xBinEdge(i)+xBinEdge(i+1))/2;
end
ydata = g.BinCounts;

realydata = find(ydata ~= 0);
ydata = ydata(realydata);
xdata = xdata(realydata);

[thisfit,gof2] = fit(xdata',ydata','gauss1');
fit_ydata = thisfit(xdata);

[hm_val,hm_loc] = max(fit_ydata); 
hist_max =  xdata(hm_loc);
hh = hm_val/2;
th_hi= xdata(hm_loc+find(ydata(hm_loc:end)<hh,1));
th_lo = xdata(find(ydata(1:hm_loc)>hh,1));
whh = th_hi-th_lo;
parameters.prom_thresh = whh;
close(gcf)
end

%% Remove any ROIs with lower prominence than chosen threshold
prominence = highest_pixel-local_bg;
good_indexes = find(prominence >= parameters.prom_thresh);

%% Save the new CC, L and parameter files
newobjects = size(good_indexes,2);

try,
	mkdir([getpathname(atd) filesep 'ROIs' filesep output_itemname]);
end;

h = gethistory(atd,'ROIs',input_itemname);
h(end+1) = struct('parent',input_itemname,'operation','at_roi_resegment','parameters',parameters,...
	'description',['ROIs were pared down from ' int2str(oldobjects) ' to ' int2str(newobjects) ', rejecting non-prominent members from ' input_itemname '.']);
sethistory(atd,'ROIs',output_itemname,h);

at_roi_savesubset(atd,input_itemname, good_indexes, output_itemname, h);

out = 1;
end