%% Local Background
function [intensity_thresh,max_neg_slope,cutoff,highest_pixel]= secthreshslopes(atd,filename,varargin)
% [local_bg,highest_pixel] = SECTHRESHSLOPES(ATD,FILENAME,VARARGIN) 
% atd should be a directory culminating in an "analysis" file for mia.GUI.archived_code.ATGUI
% code.
% filename is the full path to an ROI dataset, including the ".mat"
% exension 
% you can manually set these three parameters, or they will default:
% dist_cardinal = 50; the distance to search for local
% background in each direction, in pixels
% CV_binsize = 5; the binsize of pixels at which coefficient of
% variation is computed
% CV_thresh = 0.01; the coefficient of variation threshold that
% will say a value is invariant enough to be considered local background
% Writes ROI max intensity and local background to a file called
% FILENAME_roiintparam.mat, and also returns these values as an output.

%% Default parameters
dist_cardinal = 15;
slopethresh = 0.33;
prc_cut = 10;
assign(varargin{:});

ROIintparam = [];

%% Use mia.roi.roi_functions.at_roi_parameters code to identify the correct .CC and img file
disp(['Grabbing image and ROI information!']);
a = load(filename,'-mat');

% Original image
[parentdirname,itemfilename,ext] = fileparts(filename);
itemnamecutoff = strfind(itemfilename,'_ROI');
if isempty(itemnamecutoff),
	error(['Could not identiy ROI name!']);
end;
itemname = itemfilename(1:itemnamecutoff(1)-1);
[dummy,im_fname] = mia.roi.roi_functions.at_roi_underlying_image(atd,itemname);

%% Convert information into DLW formats
[num_images,img_stack] = mia.at_loadscaledstack(im_fname);
[puncta_info] = mia.utilities.at_puncta_info(img_stack,a.CC);

%% Calculate the cardinal slopes
disp(['Calculating local background!']);

for punctum = 1: size(puncta_info,1),
%% Find the location, intensity, and frame of the peak pixel
intensities = cell2mat(puncta_info(punctum,3));
pixel_locs = cell2mat(puncta_info(punctum,2));
[highest_pixel(punctum) brightest_pixel_loc] = max(intensities);
highest_zframe(punctum) = pixel_locs(brightest_pixel_loc,3);
peak_loc = pixel_locs(brightest_pixel_loc,:);

volume(punctum) = size(intensities,1);

mean_pixel(punctum) =  mean(intensities);
sum_pixels(punctum) = sum(intensities);
stdev_pixels(punctum) = std(intensities);

if punctum > 1, clear lines; clear slopes; end
% Now draw lines out from the peak, find local background in each direction
% NOTE: peak_loc is set up so it's [y x z], and +y = down, +x = right
%% NORTH
if peak_loc(1,1) > dist_cardinal + 2 %1000x1000, and we're drawing 50 pixels out
    for pix = 1:dist_cardinal, % starting from the peak now we're here
        lines.north(pix) = img_stack(peak_loc(1,1)-pix+1,peak_loc(1,2),peak_loc(1,3));
    end,
else %1000x1000, if we're too close to get 50, we'll get what we can
    for pix = 1:peak_loc(1,1)-1
        lines.north(pix) = img_stack(peak_loc(1,1)-pix+1,peak_loc(1,2),peak_loc(1,3));
    end
end
if exist('linetest'), clear linetest; end
try linetest = lines.north; end
if exist('linetest')
    lines.north(find(lines.north == 0)) = [];
if size(lines.north,2) > 5,
    slopes.north = diff(lines.north);
    firstslopeunder = find(slopes.north >= slopes.north(find(min(slopes.north)),1));
    candidates.north = lines.north(firstslopeunder);
    mins.north = min(slopes.north);
else candidates.north = []; mins.north = []; end
else candidates.north = []; mins.north = []; end

%% SOUTH
if peak_loc(1,1) < size(img_stack,2) - (dist_cardinal + 2) %1000x1000, and we're drawing 50 pixels out
    for pix = 1:dist_cardinal,
        lines.south(pix) = img_stack(peak_loc(1,1)+pix-1,peak_loc(1,2),peak_loc(1,3));
    end
else %1000x1000, if we're too close to get 50, we'll get what we can
    for pix = 1:size(img_stack,2)-peak_loc(1,1)-1
        lines.south(pix) = img_stack(peak_loc(1,1)+pix-1,peak_loc(1,2),peak_loc(1,3));
    end
end
if exist('linetest'), clear linetest; end
try linetest = lines.south; end
if exist('linetest'),
    lines.south(find(lines.south == 0)) = [];
if size(lines.south,2) > 5,
    slopes.south = diff(lines.south);
    firstslopeunder = find(slopes.south >= slopes.south(find(min(slopes.south)),1));
    candidates.south = lines.south(firstslopeunder); % could add +1, not doing so means this represents the pixel right before the slope drops below our threshold
    mins.south = min(slopes.south);
else candidates.south = []; mins.south = []; end
else candidates.south = []; mins.south = []; end

%% EAST
if peak_loc(1,2) < size(img_stack,1) - (dist_cardinal + 2) %1000x1000, and we're drawing 50 pixels out
    for pix = 1:dist_cardinal,
        lines.east(pix) = img_stack(peak_loc(1,1),peak_loc(1,2)+pix-1,peak_loc(1,3));
    end
else %1000x1000, if we're too close to get 50, we'll get what we can
    for pix = 1:size(img_stack,1)-peak_loc(1,2)-1
        lines.east(pix) = img_stack(peak_loc(1,1),peak_loc(1,2)+pix-1,peak_loc(1,3));
    end
end
if exist('linetest'), clear linetest; end
try linetest = lines.east; end
if exist('linetest'),
    lines.east(find(lines.east == 0)) = [];
if size(lines.east,2) > 5,
    slopes.east = diff(lines.east);
    firstslopeunder = find(slopes.east >= slopes.east(find(min(slopes.east)),1));
    candidates.east = lines.east(firstslopeunder);
    mins.east = min(slopes.east);
else, candidates.east = []; mins.east = [];end
else, candidates.east = []; mins.east = []; end

%% WEST
if peak_loc(1,2) > dist_cardinal + 1 %1000x1000, and we're drawing 50 pixels out
    for pix = 1:dist_cardinal,
        lines.west(pix) = img_stack(peak_loc(1,1),peak_loc(1,2)-pix+1,peak_loc(1,3));
    end
else %1000x1000, if we're too close to get 50, we'll get what we can
    for pix = 1:peak_loc(1,2)-1
        lines.west(pix) = img_stack(peak_loc(1,1),peak_loc(1,2)-pix+1,peak_loc(1,3));
    end
end
if exist('linetest'), clear linetest; end
try linetest = lines.west; end
if exist('linetest'),
    lines.west(find(lines.west == 0)) = [];
if size(lines.west,2) > 5,
    slopes.west = diff(lines.west);
    firstslopeunder = find(slopes.west >= slopes.west(find(min(slopes.west)),1));
    candidates.west = lines.west(firstslopeunder);
    mins.west = min(slopes.west);
else candidates.west = []; mins.west = []; end
else candidates.west = []; mins.west = []; end

%% COMBINE LINES
try
    max_neg_slope(punctum) = min([mins.east,mins.west,mins.north,mins.south]);
catch
    disp(['Unable to find min slope for punctum #' num2str(punctum)])
end

try
    intensity_thresh(punctum) = mean([candidates.north,candidates.south,candidates.east,candidates.west]);
catch
    disp(['Unable to find intensity threshold for punctum #' num2str(punctum)])
end

end % end of calculating local background for each punctum

range = -(min(max_neg_slope) - max(max_neg_slope));
cutoff =  max(max_neg_slope) - range / (100/prc_cut);

riseoverrun = highest_pixel ./ volume;
range = max(riseoverrun) - min(riseoverrun);
cutoff =  min(riseoverrun) + range / (100/prc_cut);
figure
hold on
plot(riseoverrun,'ko')
plot([0 size(puncta_info,1)],[cutoff cutoff],'r-')


%% Plot a visual of the slope cutoff
figure
hold on
plot(max_neg_slope,'ko')
plot([0 size(puncta_info,1)],[cutoff cutoff],'r-')
keyboard

figure
hold on
plot(-max_neg_slope,highest_pixel,'ko')
xlabel(['Negative slope']); ylabel(['Highest Pixel']);

figure
hold on
plot(-max_neg_slope,mean_pixel,'ko')
xlabel(['Negative slope']); ylabel(['Mean Pixel']);

figure
hold on
plot(-max_neg_slope,sum_pixels,'ko')
xlabel(['Negative slope']); ylabel(['Pixel Integral']);

figure
hold on
plot(-max_neg_slope,stdev_pixels,'ko')
xlabel(['Negative slope']); ylabel(['Standard Deviation']);

% %% Save file
% ROIintparam.local_bg = intensity_thresh;
% ROIintparam.highest_int = highest_pixel;
% 
% [filepath,im_fname,ext] = fileparts(filename);
% 
% roipfilename = fullfile(filepath,[im_fname '_roiintparam.mat']);
% 
% save(roipfilename, 'ROIintparam');
end
