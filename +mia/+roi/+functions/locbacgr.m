%% Local Background
function [local_bg,highest_pixel]= locbacgr(atd,filename,varargin)
% [local_bg,highest_pixel] = MIA.ROI.FUNCTIONS.LOCBACGR(ATD,FILENAME,VARARGIN) 
% atd should be a directory culminating in an "analysis" file for mia.GUI.archived_code.ATGUI
% code.
% filename is the full path to an ROI dataset, including the ".mat"
% exension 
% you can manually set these three parameters, or they will default:
% parameters.dist_cardinal = 50; the distance to search for local
% background in each direction, in pixels
% parameters.CV_binsize = 5; the binsize of pixels at which coefficient of
% variation is computed
% parameters.CV_thresh = 0.01; the coefficient of variation threshold that
% will say a value is invariant enough to be considered local background
% Writes ROI max intensity and local background to a file called
% FILENAME_roiintparam.mat, and also returns these values as an output.

%% Baseline parameters
parameters.dist_cardinal = 50;
parameters.CV_binsize = 5;
assign(varargin{:});

ROIintparam = [];

%% Use mia.roi.functions.parameters code to identify the correct .CC and img file
disp(['Grabbing image and ROI information!']);
a = load(filename,'-mat');

% Original image
[parentdirname,itemfilename,ext] = fileparts(filename);
itemnamecutoff = strfind(itemfilename,'_ROI');
if isempty(itemnamecutoff),
	error(['Could not identiy ROI name!']);
end;
itemname = itemfilename(1:itemnamecutoff(1)-1);
[dummy,im_fname] = mia.roi.functions.underlying_image(atd,itemname);

%% Convert information into DLW formats
[num_images,img_stack] = mia.loadscaledstack(im_fname);
[puncta_info] = mia.utilities.puncta_info(img_stack,a.CC);

%% Calculate the local background
disp(['Calculating local background!']);
h = waitbar(0,'Beginning calculation of local background!');

binsi = parameters.CV_binsize;

for punctum = 1: size(puncta_info,1),
%% Find the location, intensity, and frame of the peak pixel
intensities = cell2mat(puncta_info(punctum,3));
pixel_locs = cell2mat(puncta_info(punctum,2));
[highest_pixel(punctum) brightest_pixel_loc] = max(intensities);
highest_zframe(punctum) = pixel_locs(brightest_pixel_loc,3);
peak_loc = pixel_locs(brightest_pixel_loc,:);

if punctum > 1, clear lines; end
% Now draw lines out from the peak, find local background in each direction
% NOTE: peak_loc is set up so it's [y x z], and +y = down, +x = right
%% NORTH
if peak_loc(1,1) > parameters.dist_cardinal + 1 %1000x1000, and we're drawing 50 pixels out
    for pix = 1:parameters.dist_cardinal,
    if peak_loc(1,1)-pix < min(pixel_locs(:,1)) % let's only look outside the ROI
        lines.northline(pix) = img_stack(peak_loc(1,1)-pix,peak_loc(1,2),peak_loc(1,3));
    end, end
else %1000x1000, if we're too close to get 50, we'll get what we can
    for pix = 1:peak_loc(1,1)-1
    if peak_loc(1,1)-pix < min(pixel_locs(:,1))
        lines.northline(pix) = img_stack(peak_loc(1,1)-pix,peak_loc(1,2),peak_loc(1,3));
    end, end
end
if exist('linetest'), clear linetest; end
try linetest = lines.northline; end
if exist('linetest')
    lines.northline(find(lines.northline == 0)) = [];
for scan = 1:size(lines.northline,2)-binsi % get coeff of variation for each pixel, with w/ next 5
    scandata =  lines.northline(scan:scan+(binsi-1));
    coeffvar(scan) = std(scandata)/mean(scandata);
end
% CHECK
% figure
% plot(coeffvar)
% ylabel('Coefficient of Variation (binsize)')
% xlabel('Distance from peak (pixels)')
if exist('coeffvar') == 1 & size(lines.northline,2) > binsi,% if the coeffvar was ever under the thresh, we record the average of the pixels where the coeff was recorded low
    start_bg = find(coeffvar == min(coeffvar));
    if size(lines.northline,2) >= (start_bg+(binsi-1)),
    north_bg = mean(lines.northline(start_bg:start_bg+(binsi-1)));
    else
    north_bg = [];
    end 
else % if it never reaches a static, then just return an empty
    north_bg = [];
end
else
    north_bg = [];
end

%% SOUTH
if peak_loc(1,1) < size(img_stack,2) - (parameters.dist_cardinal + 1) %1000x1000, and we're drawing 50 pixels out
    for pix = 1:parameters.dist_cardinal,
    if peak_loc(1,1)+pix > max(pixel_locs(:,1))
        lines.southline(pix) = img_stack(peak_loc(1,1)+pix,peak_loc(1,2),peak_loc(1,3));
    end, end
else %1000x1000, if we're too close to get 50, we'll get what we can
    for pix = 1:size(img_stack,2)-peak_loc(1,1)-1
    if peak_loc(1,1)+pix > max(pixel_locs(:,1))
        lines.southline(pix) = img_stack(peak_loc(1,1)+pix,peak_loc(1,2),peak_loc(1,3));
    end, end
end
if exist('linetest'), clear linetest; end
try linetest = lines.southline; end
if exist('linetest'),
    lines.southline(find(lines.southline == 0)) = [];
for scan = 1:size(lines.southline,2)-binsi % get coeff of variation for each pixel, with w/ next 5
    scandata =  lines.southline(scan:scan+(binsi-1));
    coeffvar(scan) = std(scandata)/mean(scandata);
end
% CHECK
% figure
% plot(coeffvar)
if exist('coeffvar') == 1 & size(lines.southline,2) > binsi,% if the coeffvar was ever under the thresh, we record the average of the pixels where the coeff was recorded low 
    start_bg = find(coeffvar == min(coeffvar));
    if size(lines.southline,2) >= (start_bg+(binsi-1)),
    south_bg = mean(lines.southline(start_bg:start_bg+(binsi-1)));
    else
    south_bg = [];
    end 
else % if it never reaches a static, then just return an empty
    south_bg = [];
end
else
    south_bg = [];
end

%% EAST
if peak_loc(1,2) < size(img_stack,1) - (parameters.dist_cardinal + 1) %1000x1000, and we're drawing 50 pixels out
    for pix = 1:parameters.dist_cardinal,
    if peak_loc(1,2)+pix > max(pixel_locs(:,2))
        lines.eastline(pix) = img_stack(peak_loc(1,1),peak_loc(1,2)+pix,peak_loc(1,3));
    end, end
else %1000x1000, if we're too close to get 50, we'll get what we can
    for pix = 1:size(img_stack,1)-peak_loc(1,2)-1
    if peak_loc(1,2)+pix > max(pixel_locs(:,2))
        lines.eastline(pix) = img_stack(peak_loc(1,1),peak_loc(1,2)+pix,peak_loc(1,3));
    end, end
end
if exist('linetest'), clear linetest; end
try linetest = lines.eastline; end
if exist('linetest'),
    lines.eastline(find(lines.eastline == 0)) = [];
for scan = 1:size(lines.eastline,2)-binsi % get coeff of variation for each pixel, with w/ next 5
    scandata =  lines.eastline(scan:scan+(binsi-1));
    coeffvar(scan) = std(scandata)/mean(scandata);
end
% CHECK
% figure
% plot(coeffvar)
if exist('coeffvar') == 1 & size(lines.eastline,2) > binsi, % if the coeffvar was ever under the thresh, we record the average of the pixels where the coeff was recorded low
    start_bg = find(coeffvar == min(coeffvar));
    if size(lines.eastline,2) >= (start_bg+(binsi-1)),
    east_bg = mean(lines.eastline(start_bg:start_bg+(binsi-1)));
    else
    east_bg = [];
    end
else % if it never reaches a static, then just return an empty
    east_bg = [];
end
else
    east_bg = [];
end

%% WEST
if peak_loc(1,2) > parameters.dist_cardinal + 1 %1000x1000, and we're drawing 50 pixels out
    for pix = 1:parameters.dist_cardinal,
    if peak_loc(1,2)-pix < min(pixel_locs(:,2))
        lines.westline(pix) = img_stack(peak_loc(1,1),peak_loc(1,2)-pix,peak_loc(1,3));
    end, end
else %1000x1000, if we're too close to get 50, we'll get what we can
    for pix = 1:peak_loc(1,2)-1
    if peak_loc(1,2)-pix < min(pixel_locs(:,2))
        lines.westline(pix) = img_stack(peak_loc(1,1),peak_loc(1,2)-pix,peak_loc(1,3));
    end, end
end
if exist('linetest'), clear linetest; end
try linetest = lines.westline; end
if exist('linetest'),
    lines.westline(find(lines.westline == 0)) = [];
for scan = 1:size(lines.westline,2)-binsi % get coeff of variation for each pixel, with w/ next 5
    scandata =  lines.westline(scan:scan+(binsi-1));
    coeffvar(scan) = std(scandata)/mean(scandata);
end
% CHECK
% figure
% plot(coeffvar)
if exist('coeffvar') == 1 & size(lines.westline,2) > binsi,% if the coeffvar was ever under the thresh, we record the average of the pixels where the coeff was recorded low
    start_bg = find(coeffvar == min(coeffvar));
    if size(lines.westline,2) >= (start_bg+(binsi-1)),
    west_bg = mean(lines.westline(start_bg:start_bg+(binsi-1)));
    else
    west_bg = [];
    end
else % if it never reaches a static, then just return an empty
    west_bg = [];
end
else
    west_bg = [];
end

%% COMBINE LINES
try
    local_bg(punctum) = min([north_bg,south_bg,east_bg,west_bg]);
catch
    disp(['Unable to find local background for punctum #' num2str(punctum)])
end

end % end of calculating local background for each punctum
close(h)

%% Save file
ROIintparam.local_bg = local_bg;
ROIintparam.highest_int = highest_pixel;

[filepath,im_fname,ext] = fileparts(filename);

roipfilename = fullfile(filepath,[im_fname '_roiintparam.mat']);

save(roipfilename, 'ROIintparam');
end
