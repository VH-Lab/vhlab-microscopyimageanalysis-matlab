function bd = wiseetal_load_blur_data(fullpath, channel,exper_type)

atd = atdir(fullpath);

images_here = getitems(atd,'images')

if strcmp(exper_type,'structure')|strcmp(exper_type,'handcalled')
    if strcmp(channel,'VG'),
        channel = 'PSD';
    end;
end;

image_name_sp = [channel '_DECsv7_th2_blur_th']
image_name_nosp = [channel 'DECsv7_th2_blur_th']

{images_here.name}'

match1 = find(strcmpi(image_name_sp,   {images_here.name}))
match2 = find(strcmpi(image_name_nosp, {images_here.name}))

if ~isempty(match1),
	image_name = image_name_sp;
elseif ~isempty(match2),
	image_name = image_name_nosp;
else,
	disp(['No blur information found.']);
    bd = [];
    return;
	error(['No blur information found.']);
end;

filename = getimagefilename(atd,image_name)

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


