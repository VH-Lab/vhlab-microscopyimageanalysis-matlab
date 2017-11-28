function at_maketoydata(imsize, dotsize, numdots, channels, dotsame, dotshift)
% AT_MAKETOYDATA - make toy data for testing array tomography analysis
%
%  Makes a directory called 'at_toydata_example' with an image with randomly generated
%  dots. Two images of different channels are created. The "dots" are 3-dimensional 
%  Gaussian spots.
%
%  Inputs:
%    IMSIZE = [X Y Z] the size of the image
%    DOTSIZE = [x y z] the size of each dot (covariance matrix of 3-d normal)
%    NUMDOTS = the number of dots to generate
%    CHANNELS = the number of channels to generate
%    DOTSAME = fraction of dots that are preserved across channels
%    DOTSHIFT = [Xs Ys Zs] shift of dots from one channel to the next
%

 % Step 1: create empty image


C = diag(dotsize);

master_dots = ceil(rand(numdots,3).*repmat(imsize(:)'-1,numdots,1));

if exist(['at_toydata_example']),
	error(['Directory ' [pwd filesep 'at_toydata_example'] '.']);
end

for i=1:channels,
	im = zeros(imsize);
	
	newdots = round((1-dotsame)*numdots);

	dots = master_dots;
	dots(1:newdots,:) = ceil(rand(numdots,3).*repmat(imsize(:)-1, newdots, 1));

	mvnpdf
	

end

