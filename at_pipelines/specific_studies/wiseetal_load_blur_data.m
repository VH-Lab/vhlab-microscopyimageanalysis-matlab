function bd = wiseetal_load_blur_data(fullpath, channel)

atd = atdir(fullpath);

images_here = getitems(atd,'images');

image_name_sp = [channel '_DECsv7_th2_blur_th'];
image_name_nosp = [channel 'DECsv7_th2_blur_th'];

match1 = strcmpi(image_name_sp,   images_here);
match2 = strcmpi(image_name_nosp, images_here);

if ~isempty(match1),
	image_name = image_name_sp;
elseif ~isempty(match2),
	image_name = image_name_nosp;
else,
	error(['No blur information found.']);
end;

filename = getimagefilename(atd,image_name);

imf = imfinfo(filename);

total_num = [];
total_in = [];
total_out = [];

for i=1:numel(imf),
	im = imread(filename,i);
	total_num(i) = numel(im);
	total_in(i) = numel(find(im(:)));
	total_out(i) = numel(find(~im(:)));
end;

bd.total_num = sum(total_num);
bd.total_in = sum(total_in);
bd.total_out = sum(total_out);


