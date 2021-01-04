function airyscaler = airyscaler3(fname,varargin)
% AIRYSCALER3(FNAME) scales an image stack produced by AiryScan processing.
% AIRYSCALER finds an estimate of the signal from a frame of an image, then
% fits the change of this value over frames to an exponential decay fxn.
% The noise distribution of the image is centered around 0, and then each
% value is multiplied by the inverse of the exponential decay, causing the
% signal of each frame to better resemble the first frame.
% fname should be the name of a single-channel .tif image (the full name, incuding the
% file path) generated from the Airyscan microscope.
% adj_scale is an option to hone your scaling if you feel the application
% did a poor job. It will add an additional scaling factor to that derived
% from the exponential decay over depth.

%% INITIALIZE
info = imfinfo(fname); num_images = numel(info); tic; close all; assignin(varargin{:});

%% LOAD IMAGES, GET INTENSITY HISTOGRAM DATA
% Loads an AiryScan tiffstack then fits a curve to the intensity histogram
% for each frame and gets back a bunch of properties for it: its maxima
% (which should be the middle of the noise distribution), its width at
% half-height, the 95th percentile of the data as an estimate of "signal"
% later, and a presumptive threshold for each frame (which this function
% currently doesn't use).
[num_images,img_stack] = loadairystack(fname);
[background_maxima,frame_signal] = calchistvals(num_images,img_stack);
base_norm = max(background_maxima);

%% FIT EXPONENTIAL DECAY TO THE BRIGHTEST PIXELS OVER DEPTH
[decay_fit] = fitplotexpdecay(1:num_images,frame_signal');
vars = coeffvalues(decay_fit);
a = vars(1); b = vars(2); c = vars(3); d = vars(4); e = vars(5);
for x = 1:num_images,
scale_factorfit95(x,1) = 1./((a*exp(-x/b)+c+d*exp(-x/e))/(a*exp(-1/b)+c+d*exp(-1/e)));
% additional scalar optional
if exist('adj_scale') == 1,
scale_factorfit95(x,1) = scale_factorfit95(x,1) * (((adj_scale - 1) * (x/num_images))+1);
end, end

%% STRETCHING NORMALIZATION WITH DECAY FIT
%  Normalizes by subtracting the background maxima (noise distribution) for
%  each frame so we can stretch out from a 0-point Then, we multiply each
%  intensity value by the inverse of the decay function of the brightest
%  pixels from ROIs over depth. Finally, we add back an arbitrary number,
%  1000, so that no values are negative.

wait_bar = waitbar(0,'Please wait...'); s = clock;
for k = 1:num_images,
    img_stack_remove_base = img_stack(:,:,k) - background_maxima(k); 
    img_stack_scale_up = img_stack_remove_base .* scale_factorfit95(k);
    img_stack_normalized(:,:,k) = img_stack_scale_up + 1000;

if k == 1, is = etime(clock,s); esttime = is * num_images; end
waitbar(k/num_images,wait_bar,['Scaling to decay of signal, remaining time = ',num2str(esttime-etime(clock,s),'%4.1f'),' seconds' ]);
end % Final should be img_stack_normalized(:,:,k)
close(wait_bar)
disp('Scaling: Part 1 complete!')


%% GRAPH TO CHECK NORMALIZATION
whichframes = [1,num_images];
plotscalecheck(img_stack_normalized,num_images,whichframes);

%% RESAVE
% Save as a multi-plane tiff stack image in 1 color.

save_name = fname(1:end-4); %remove .tif from filename
for k = 1:num_images;
plane = uint16(img_stack_normalized(:,:,k)); %gotta put it back in uint16
if k==1
    imwrite(plane,[save_name '-as3scaled.tif'])
else
    imwrite(plane,[save_name '-as3scaled.tif'],'WriteMode','append') %appending each frame to the first one (multi-image tiff).
end

end 
disp('New file saved!')
disp('Scaling complete!')

toc
end

%% LOAD AIRYSTACK
function [num_images,img_stack] = loadairystack(fname)
% Initialize
info = imfinfo(fname); num_images = numel(info); s = clock;
% Load images, assign to matrices and get average intensity
wait_bar = waitbar(0,'Please wait...');
for k = 1:num_images
A = double(imread(fname, k, 'Info', info))+1-10000; %+1 to go to double, -10,000 for the arbitrary +10,000 value on AS processing.
img_stack(:,:,k) = A; % Save in matrix.
if k == 1, is = etime(clock,s); esttime = is * num_images; end
waitbar(k/num_images,wait_bar,['Loading images, remaining time = ',num2str(esttime-etime(clock,s),'%4.1f'),' seconds' ]);
end
close(wait_bar)
disp('Images loaded!')
end

%% CALCULATE HISTOGRAM PROPERTIES
function [background_maxima,frame_signal_est] = calchistvals(num_images,img_stack)
% Uses histfit, which plots histograms and applies a distfit function, to
% find the maxima of the fit.  This should represent the peak of the noise
% distribution. Distfit (and histfit) default to trying to fit a normal
% distribution. Tried, and gave up on, paring down histfit so that it
% doesn't need to plot things. May return to try to do this faster.
wait_bar = waitbar(0,'Please wait...'); s = clock;

for k = 1:num_images,
data_2D = img_stack(:,:,k);
data = data_2D(:)';

background_maxima(k) = fitplothistmax(data);

int_cutoff = prctile(data,95); %take the top data, but more than the signal peaks
data_above = data(find(data >= int_cutoff))-background_maxima(k);
frame_signal_est(k) = sum(data_above)/size(data_above,2);

if k ==1, is = etime(clock,s); esttime = is * num_images; end
waitbar(k/num_images,wait_bar,['Calculating data properties, remaining time = ',num2str(esttime-etime(clock,s),'%4.1f'),' seconds' ]);
end
close gcf
close(wait_bar)
disp('Intensity histogram analyzed!')
end

%% FIND HISTOGRAM BACKGROUND MAXIMUS
function [hist_max] = fitplothistmax(data)

indexes = find((data >= (mode(data)-20)) & (data <= (mode(data) +20)));

g = oghist(data(indexes),max(data(indexes))-min(data(indexes))+1,'Visible','off');
xBinEdge = g.BinEdges;
for i = 1:(size(xBinEdge,2)-1)
    xdata(i) = (xBinEdge(i)+xBinEdge(i+1))/2;
end
ydata = g.BinCounts;

[thisfit,gof2] = fit(xdata',ydata','gauss1');
fit_ydata = thisfit(xdata);

f4 = figure('Name','Fit to data over depth');
hold on
plot(xdata,ydata,'k');
plot(xdata,fit_ydata,'b')
xlabel('Z Frame (0.2 um/frame)'); ylabel('Intensity');
legend('Data','Fit')

[val,loc] = max(fit_ydata); 
hist_max =  xdata(loc);
close gcf 
end

%% PLOT TO THE EXPONENTIAL DECAY (OBSERVED IN SIGNAL)
function [thisfit] = fitplotexpdecay(xdata,ydata)
s2 = fitoptions('Method','NonlinearLeastSquares',...
               'Lower',[-Inf 0 -Inf -Inf 0],...
               'Upper',[Inf,size(ydata,1),Inf,Inf,size(ydata,1)],...
               'Startpoint',[ydata(1)-ydata(end) 25 ydata(end) 0 30]);
f2 = fittype('a*exp(-x/b)+c+d*exp(-x/e)','options',s2);
[thisfit,gof2] = fit(xdata',ydata,f2);
fit_ydata = thisfit(xdata);

f4 = figure('Name','Fit to data over depth');
hold on
plot(xdata,ydata,'k');
plot(xdata,fit_ydata,'b')
xlabel('Z Frame (0.2 um/frame)'); ylabel('Intensity');
legend('Data','Fit')
% close gcf
end

%% CHECK YOUR SCALED DATA BACK TO THE FIRST FRAME
function plotter = plotscalecheck(img_stack,num_images,whichframes)
close all
figure; 
% sgtitle('Plot First and Last Frames (Red and Blue, respectively)');
k = whichframes(1);
hold on
data = img_stack(:,:,k);
data_vector = data(:)';
oghist(data_vector,'BinWidth',20,'FaceColor','red');

k = whichframes(2);
hold on
data = img_stack(:,:,k);
data_vector = data(:)';
oghist(data_vector,'BinWidth',20,'FaceColor','blue');
disp('Displaying histogram; press "continue" to save your image!')
keyboard 

end