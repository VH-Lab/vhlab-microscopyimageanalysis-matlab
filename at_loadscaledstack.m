%% Get image values
function [num_images,img_stack] = at_loadscaledstack(fname)
%% INSTRUCTIONS

%% INITIALIZE
info = imfinfo(fname); num_images = numel(info); s = clock;

%% Load images, assign to matrices and get average intensity
wait_bar = waitbar(0,'Please wait...');
for k = 1:num_images
    A = double(imread(fname, k, 'Info', info))+1; %+1 to go to double, -10,000 cuz there's a weird scalar on the Airyscan images.
    img_stack(:,:,k) = A; % Save in matrix.
    frame_avg(k) = mean(mean(A)); % Mean intensity per frame.
    if k ==1
        is = etime(clock,s);
        esttime = is * num_images;
    end
    waitbar(k/50,wait_bar,['Loading images, remaining time = ',num2str(esttime-etime(clock,s),'%4.1f'),' seconds' ]);
end
close(wait_bar)
disp('Images loaded!')

end