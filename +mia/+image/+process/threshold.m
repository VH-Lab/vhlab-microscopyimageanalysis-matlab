function out = threshold(atd, input_itemname, output_itemname, parameters)
% THRESHOLD - Threshold an image and store results
%  
%  OUT = MIA.IMAGE.PROCESS.THRESHOLD(ATD, INPUT_ITEMNAME, OUTPUT_ITEMNAME, PARAMETERS)
%
%  If the function is called with no arguments, then a description of the
%  parameters is returned in OUT. OUT{1}{n} is the name of the nth parameter, and
%  OUT{2}{n} is a human-readable description of the parameter.
%  OUT{3} is a list of methods for user-guided selection of these parameters.
%
 
image_viewer_name = 'IM';

if nargin==0,
	out{1} = {'threshold'};
	out{2} = {'Threshold to apply to image to detect presence of objects (real number)'};
	out{3} = {'choose_inputdlg','choose_graphical'};
	return;
elseif nargin==1, % it means it is an image preview call

	im = atd;
	vars = image_viewer_gui(image_viewer_name,'command',[image_viewer_name 'get_vars']);

	fig = gcf;
	threshold = eval([get(findobj(fig,'tag','ThresholdEdit'),'string') ';']);

	threshold_channels = [];

	above_indexes = [];

	for i=1:size(im,3),
		threshold_channels(i) = rescale(threshold,...
					[vars.ImageScaleParams.Min(i) vars.ImageScaleParams.Max(i)], ...
					[vars.ImageDisplayScaleParams.Min(i) vars.ImageDisplayScaleParams.Max(i)]);
		above_indexes = cat(1,above_indexes,find(im(:,:,i)>threshold_channels(i)));
	end;

	if size(im,3)==1,
		im_downscale = rescale(im,[vars.ImageDisplayScaleParams.Min(i) vars.ImageDisplayScaleParams.Max(i)],[0 1]);
		im_abovedownscale = im_downscale;
		im_abovedownscale(above_indexes) = 1;
		im3 = cat(3,im_abovedownscale,im_abovedownscale,im_downscale);
	else,
		im3 = above;
	end;

	out = im3;
	return;
end;

if ischar(parameters),
	switch lower(parameters),
		case 'choose',
			out_choice = mia.image.process.threshold;
			choices = cat(2,out_choice{3},'Cancel');
			buttonname = questdlg('By which method should we choose parameters?',...
				'Which method?', choices{:},'Cancel');
			if ~strcmp(buttonname,'Cancel'),
				out = mia.image.process.threshold(atd,input_itemname,output_itemname,buttonname);
			else,
				out = [];
			end;

		case {'choose_inputdlg'},
			out_p = mia.image.process.threshold;
			default_parameters.threshold = 100;
			parameters = dlg2struct('Choose parameters',out_p{1},out_p{2},default_parameters);
			if isempty(parameters),
				out = [];
			else,
				out = mia.image.process.threshold(atd,input_itemname,output_itemname,parameters);
			end;
		case {'choose_graphical'},
			f = figure;
			pos = get(f,'position');
			set(f,'position',[pos([1 2]) 500 500]);
			imfile = mia.miadir.getimagefilename(atd,input_itemname);
			uidefs = basicuitools_defs;
			uicontrol(uidefs.txt,'position',  [20 350 45 25],'string','Threshold:');
			uicontrol(uidefs.edit,'position', [20 325 45 25],'string','1000','tag','ThresholdEdit','userdata',1,'callback',['set(gcbo,''userdata'',1); uiresume;']);
			uicontrol(uidefs.button,'position',[20 300 45 25],'string','OK', 'tag','OKButton','callback',['set(gcbo,''userdata'',1); uiresume;']);
			uicontrol(uidefs.button,'position',[20 270 45 25],'string','Cancel','tag','CancelButton','callback',['set(gcbo,''userdata'',1); uiresume;']);

			image_viewer_gui(image_viewer_name,'imfile',imfile,'imagemodifierfunc','mia.image.process.threshold(im);')

			success = 0;

			threshedit = 1;

			while ~success,
				if ~threshedit, uiwait; end; 

				cancel = get(findobj(gcf,'tag','CancelButton'),'userdata');
				ok = get(findobj(gcf,'tag','OKButton'),'userdata');
				threshedit = get(findobj(gcf,'tag','ThresholdEdit'),'userdata');

				if cancel,
					success = 1;
					out = [];
				elseif threshedit | ok,
					try,
						threshold_string = get(findobj(gcf,'tag','ThresholdEdit'),'string');
						threshold = eval([threshold_string ';']);
						if isempty(threshold) | ~isnumeric(threshold),
							error(['Syntax error in threshold: empty or not a number.']);
						end;
					catch,
						errordlg(['Error in setting threshold: ' lasterr]);
						set(findobj(gcf,'tag','OKButton'),'userdata',0);
						set(findobj(gcf,'tag','ThresholdEdit'),'userdata',0);
					end;

					if threshedit,
						handles=image_viewer_gui(image_viewer_name,'command',[image_viewer_name 'get_handles']);
						h = findobj(handles.HistogramAxes,'tag','histline');
						if ishandle(h), delete(h); end;
						oldaxes = gca;
						axes(handles.HistogramAxes);
						hold on;
						a = axis;
						plot([threshold threshold],[a(3) a(4)],'g-','tag','histline');
						set(handles.HistogramAxes,'tag',[image_viewer_name 'HistogramAxes']);
						axes(oldaxes);
						image_viewer_gui(image_viewer_name,'command',[image_viewer_name 'draw_image']);
						set(findobj(gcf,'tag','ThresholdEdit'),'userdata',0);
					elseif ok,
						parameters = struct('threshold',threshold);
						out = mia.image.process.threshold(atd,input_itemname,output_itemname,parameters);
						success = 1;
					end;
				end;
				threshedit = 0;
			end;
			close(gcf);
	end;
	return;
end;

 % perform the thresholding

h = mia.miadir.gethistory(atd,'images',input_itemname);
h(end+1) = struct('parent',input_itemname,'operation','mia.image.process.threshold','parameters',parameters,...
	'description',['Applied threshold of ' num2str(parameters.threshold) ' to image ' input_itemname '.']);

im_in_file = mia.miadir.getimagefilename(atd,input_itemname);

[dummy,image_raw_filename,ext] = fileparts(im_in_file);

im_out_file = [mia.miadir.getpathname(atd) filesep 'images' filesep output_itemname filesep output_itemname ext];

input_finfo = imfinfo(im_in_file);

extra_args{1} = {'WriteMode','overwrite'};
extra_args{2} = {'WriteMode','append'};

for i=1:length(input_finfo),
	im = imread(im_in_file,'index',i,'info',input_finfo);
	if i==1, try, mkdir([mia.miadir.getpathname(atd) filesep 'images' filesep output_itemname]); end; end;
	im = logical(im > parameters.threshold);
	imwrite(im,im_out_file,extra_args{1+double(i>1)}{:});
	str2text([mia.miadir.getpathname(atd) filesep 'images' filesep output_itemname filesep 'parent.txt'], input_itemname);
end;

mia.miadir.sethistory(atd,'images',output_itemname,h);

out = 1;

