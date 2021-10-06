function at_maketoydata(varargin)
% AT_MAKETOYDATA - make toy data for testing array tomography analysis
%
%  AT_MAKETOYDATA(...)
%  
%  Makes a directory called 'at_toydata_example' in the present directory with an
%  image with randomly generated dots. The "dots" are 3-dimensional Gaussian spots.
%
%  The default behavior can be modified by passing name/value pairs:
%  Parameter (default value)     | Description
%  ------------------------------------------------------------------
%  parentdir (pwd)               | The directory in which to create the 'at_toydata_example' directory
%  dirname ('at_toydata_example')| The directory name
%  imsize ([200 300 2])          | The size of the images to create for each channel
%                                |   in [X Y Z]
%  dotsize ([2 3 2])             | The size of each dot ([x y z]); these are parameters of
%                                |   the 3-d covariance matrix
%  numdots (10)                  | The number of dots to create
%  dotsame (0.5)                 | The fraction of dots that are the same across channels
%  dotshift ([2 -2 0])           | The shift of the dots across different channels
%  dotpeak (255)                 | The peak value of the dot intensity
%  

   % Set up initial variables
 
parentdir = pwd;
dirname = 'at_toydata_example';
imsize = [ 200 300 10 ];
dotsize = [ 2 3 2 ];
numdots = 10;
channels = 2;
dotsame = 0.5;
dotshift = [ 2 -2 0];
dotpeak = 255;

  % let user override 
assign(varargin{:});

 % Step 1: create empty image

C = diag(dotsize);

master_dots = ceil(rand(numdots,3).*repmat(imsize(:)'-1,numdots,1));

thedir = [parentdir filesep dirname];
imdir = [thedir filesep 'images'];

if exist(thedir)
	error(['Directory ' thedir  ' already exists'.']);
else,
	mkdir(thedir);
	mkdir(imdir);
end

[x1,x2,x3] = meshgrid(1:imsize(1),1:imsize(2),1:imsize(3));
img_coords = [ x1(:) x2(:) x3(:) ];

for i=1:channels,
	im = zeros(imsize);
	
	number_newdots = round((1-dotsame)*numdots); % determine number of dots to shift

	dots_thischannel = master_dots;
	dots_thischannel(1:number_newdots,:) = ceil(rand(number_newdots,3).*repmat(imsize(:)'-1, number_newdots, 1));

	for j=1:numdots,
		dotimg = mvnpdf(img_coords, dots_thischannel(j,:)+(i-1)*dotshift, C);
		dotimg = reshape(dotimg, imsize(2), imsize(1), imsize(3));
		dotimg = permute(dotimg, [2 1 3]);
		dotimg = dotpeak * dotimg / max(dotimg(:));   % normalize
		if 0 & i==1 & j==1,  % debugging code
			dots_thischannel
			figure;
			image(dotimg(:,:,1));
			figure;
			imagesc(dotimg(:,:,1));
		end
		im = im + dotimg;
	end

	% write the image to disk

	  % make the directory
	thisdir = [imdir filesep 'ch' int2str(i)];
	thisfile = [thisdir filesep 'ch' int2str(i) '.tif'];
	mkdir(thisdir);
	for k=1:imsize(3),
		if k==1,
			imwrite(im(:,:,k),gray(256),thisfile);
		else,
			imwrite(im(:,:,k),gray(256),thisfile,'WriteMode','append');
		end
	end
end

