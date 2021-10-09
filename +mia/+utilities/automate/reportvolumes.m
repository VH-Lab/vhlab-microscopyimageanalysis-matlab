function reportvolumes(atd,input_itemname)
%% COMPARES PSD ROIs TO VG ROIs

% Get the Image
[dummy,im_fname] = at_roi_underlying_image(atd,input_itemname);
parameters.imagename = im_fname;
[num_images,img_stack] = mia.at_loadscaledstack(parameters.imagename);

% Get the ROIs
L_in_file = getlabeledroifilename(atd,input_itemname);
roi_in_file = getroifilename(atd,input_itemname);
load(roi_in_file,'CC','-mat');
load(L_in_file,'L','-mat');

disp('ROI locations loaded!')

% Calculate the stuff
[puncta_info] = roilocint(img_stack,CC);
for punc = 1:size(puncta_info,1)
pixel_volumes(punc) = size(cell2mat(puncta_info(punc,3)),1);
end

count = CC.NumObjects;
meanvolume = mean(pixel_volumes);
stdvolume = std(pixel_volumes);

%% Find the integral "volume"
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

[thisfit,gof2] = fit(xdata',ydata','gauss2');
fit_ydata = thisfit(xdata);

[hm_val,hm_loc] = max(fit_ydata); 
hist_max =  xdata(hm_loc);
hh = hm_val/2;
th_hi= xdata(hm_loc+find(ydata(hm_loc:end)<hh,1));
th_lo = xdata(find(ydata(1:hm_loc)>hh,1));
whh = th_hi-th_lo;
parameters.prom_thresh = whh;
close(gcf)


for punc = 1:size(puncta_info,1)
integral_int(punc) = (sum(cell2mat(puncta_info(punc,3))))/whh;
end
avg_integral_int = mean(integral_int); % could name it something else to avoid confusion
std_integral = std(integral_int);

T1 = table(count,meanvolume,stdvolume,avg_integral_int,std_integral)


end % end main function




function [puncta_info] = roilocint(img_stack,CC)
%% FIND THE INTENSITY VALUES FOR EACH ROI
sz_matrix = [size(img_stack,1) size(img_stack,2) size(img_stack,3)];
for k = 1:length(CC.PixelIdxList), %For each ROI...
one_punctum =  cell2mat(CC.PixelIdxList(k));
if size(one_punctum,1) < size(one_punctum,2)
    one_punctum = one_punctum';
end
[row column z] = ind2sub(sz_matrix,one_punctum);
one_puncta_int = [];
for i = 1:length(one_punctum), % For each pixel in the ROI...
one_puncta_int(i) = img_stack(row(i),column(i),z(i));
end
puncta_info{k,1} = k; %puncta number
puncta_info{k,2} = [row column z]; %locations
puncta_info{k,3} = one_puncta_int'; %intensities
end

end
