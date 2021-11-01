function [im_out] = circular_filter(im,useGaussian, radius, filtersize)
   
% circular_filter - applies a circular filter around a pixel that blurs.
        % im - an image
        % useGaussian - 1 means use a gaussian fall off, 0 means circle
        % radius - the radius of the filter 
        % filtersize - the size of the convolution filter (e.g., 100)

[X,Y] = meshgrid([-filtersize:filtersize], [-filtersize:filtersize]);   
                                        % Creates a grid with variables X and Y on which we can do math. 
                                        % Goes from -filtersize to +filtersize in steps of integer 1. 
                                        % filtersize is set through an input value


 % Create the filter. 
                                        
if useGaussian == 1,                    % If 1 is used, than the else condition will be bypassed.
    
    F=exp(-(X.^2+Y.^2)/(2*radius^2));   % Standard formula for Guassian dist with std dev of 'radius' units. 
                                        % 'Period' indicates step by step squaring of the grid. 
                                        
else,                                   % If above criteria is not satisfied, will resort to the 'else' condition.  
    
    F=(X.^2+Y.^2) <= (radius^2);         % Creates circular filter with falloff of 'radius'.

end

F = F./sum(F(:));                       % There is lots of 'noise'. Must normalize F so filter is closer to 1. 
                                        % Restricts image from getting brighter. 

im_out = conv2(double(im),F,'same');    % 2D convolution converting the image into a double. Apply the filter 
                                        % and argument 'same' so that filter and image have the same size. 

end

