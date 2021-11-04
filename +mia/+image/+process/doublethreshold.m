function out = at_image_doublethreshold(atd, input_itemname, output_itemname, parameters)
% AT_IMAGE_DOUBLETHRESHOLD - Threshold an image and store results
%  
%  OUT = MIA.IMAGE.PROCESS.AT_IMAGE_DOUBLETHRESHOLD(ATD, INPUT_ITEMNAME, OUTPUT_ITEMNAME, PARAMETERS)
%
%  If the function is called with no arguments, then a description of the
%  parameters is returned in OUT. OUT{1}{n} is the name of the nth parameter, and
%  OUT{2}{n} is a human-readable description of the parameter.
%  OUT{3} is a list of methods for user-guided selection of these parameters.
%
%  MIA.IMAGE.PROCESS.AT_IMAGE_DOUBLETHRESHOLD has several parameters:
%  | Parameter (default)                | Description                           |
%  |------------------------------------|---------------------------------------|
%  | threshold1 (95)                    | Value of threshold1                   |
%  | threshold2 (75)                    | Value of threshold2                   |
%  | threshold_units ('percentile')     | Unit of threshold (can be 'raw' or    |
%  |                                    |    'percentile'                       |
%  | connectivity (26)                  | Connectivity for ROI finding          |
%  
%

image_viewer_name = 'IM';

if nargin==0,
	out{1} = {'threshold1','threshold2','threshold_units','connectivity'};
	out{2} = {'Threshold1 to apply to image to detect presence of objects (real number)', ...
			'Threshold2 to apply to image to detect presence of objects (real number)', ...
			'Units of thresholds; can be ''raw'' to use raw image units or ''percentile'' to use percentile of data.', ...
			'Connectivity argument to bwconncomp (26 for 3d all edge connectivity)'};
	out{3} = {'choose_inputdlg'}; % ,'choose_graphical'}; not yet ready for graphical
	return;
elseif nargin==1, % it means it is an image preview call

	im = atd;
	vars = image_viewer_gui(image_viewer_name,'command',[image_viewer_name 'get_vars']);

	fig = gcf;
	threshold1 = eval([get(findobj(fig,'tag','ThresholdEdit1'),'string') ';']);
	threshold2 = eval([get(findobj(fig,'tag','ThresholdEdit2'),'string') ';']);
	threshold_units_list = get(findobj(fig,'tag','ThresholdUnitPopup'),'string');
	threshold_units_value = get(findobj(fig,'tag','ThresholdUnitPopup'),'value');
	threshold_units = threshold_units_list(threshold_units_value);

	if strcmp(threshold_units,'percentile'),
		threshold1 = prctile(im(:),threshold1);
		threshold2 = prctile(im(:),threshold2);
	end;

	threshold_channels = [];

	above_indexes = [];

	for i=1:size(im,3),
		threshold_channels(i) = rescale(threshold1,...
			[vars.ImageScaleParams.Min(i) vars.ImageScaleParams.Max(i)], ...
			[vars.ImageDisplayScaleParams.Min(i) vars.ImageDisplayScaleParams.Max(i)]);
		above_indexes = cat(1,above_indexes,find(im(:,:,i)>threshold1_channels(i)));
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
			out_choice = mia.image.process.at_image_doublethreshold;
			choices = cat(2,out_choice{3},'Cancel');
			buttonname = questdlg('By which method should we choose parameters?',...
				'Which method?', choices{:},'Cancel');
			if ~strcmp(buttonname,'Cancel'),
				out = mia.image.process.at_image_doublethreshold(atd,input_itemname,output_itemname,buttonname);
			else,
				out = [];
			end;
		case {'choose_inputdlg'},
			out_p = mia.image.process.at_image_doublethreshold;
			default_parameters.threshold1 = 95;
			default_parameters.threshold2 = 75;
			default_parameters.threshold_units = 'percentile';
			default_parameters.connectivity = 26;
			parameters = dlg2struct('Choose parameters',out_p{1},out_p{2},default_parameters);
			if isempty(parameters),
				out = [];
			else,
				out = mia.image.process.at_image_doublethreshold(atd,input_itemname,output_itemname,parameters);
			end;
		case {'choose_graphical_notyet'},
			f = figure;
			pos = get(f,'position');
			set(f,'position',[pos([1 2]) 500 500]);
			imfile = mia.miadir.getimagefilename(atd,input_itemname);
			uidefs = basicuitools_defs;
			row = 25;
			uicontrol(uidefs.txt,'position',  [20 350-0*row 45 25],'string','Threshold1:');
			uicontrol(uidefs.edit,'position', [20 350-1*row 45 25],'string','95','tag','ThresholdEdit1','userdata',1,'callback',['set(gcbo,''userdata'',1); uiresume;']);
			uicontrol(uidefs.txt,'position',  [20 350-2*row 45 25],'string','Threshold2:');
			uicontrol(uidefs.edit,'position', [20 350-3*row 45 25],'string','75','tag','ThresholdEdit2','userdata',1,'callback',['set(gcbo,''userdata'',1); uiresume;']);
			uicontrol(uidefs.txt,'position',[20 350-4*row 45 25],'string','Threshold units:','tag','ThresholdUnitsTxt');
			uicontrol(uidefs.popup,'position',[20+45+10 350-4*row 50 25],'string',{'raw','percentile'},'value',2);
			uicontrol(uidefs.button,'position',[20 350-5*row 45 25],'string','OK', 'tag','OKButton','callback',['set(gcbo,''userdata'',1); uiresume;']);
			uicontrol(uidefs.button,'position',[20 350-6*row 45 25],'string','Cancel','tag','CancelButton','callback',['set(gcbo,''userdata'',1); uiresume;']);

			image_viewer_gui(image_viewer_name,'imfile',imfile,'imagemodifierfunc','mia.image.process.at_image_doublethreshold(im);')

			success = 0;

			threshedit = 1;

			while ~success,
				if ~threshedit, uiwait; end; 

				cancel = get(findobj(gcf,'tag','CancelButton'),'userdata');
				ok = get(findobj(gcf,'tag','OKButton'),'userdata');
				threshedit = get(findobj(gcf,'tag','Threshold1Edit'),'userdata') | ...
					get(findobj(gcf,'tag','Threshold2Edit'),'userdata');

				if cancel,
					success = 1;
					out = [];
				elseif threshedit | ok,
					try,
						threshold1_string = get(findobj(gcf,'tag','Threshold1Edit'),'string');
						threshold1 = eval([threshold1_string ';']);
						if isempty(threshold1) | ~isnumeric(threshold1),
							error(['Syntax error in threshold1: empty or not a number.']);
						end;
					catch,
						errordlg(['Error in setting threshold1: ' lasterr]);
						set(findobj(gcf,'tag','OKButton'),'userdata',0);
						set(findobj(gcf,'tag','Threshold1Edit'),'userdata',0);
					end;

					try,
						threshold2_string = get(findobj(gcf,'tag','Threshold2Edit'),'string');
						threshold2 = eval([threshold2_string ';']);
						if isempty(threshold2) | ~isnumeric(threshold2),
							error(['Syntax error in threshold2: empty or not a number.']);
						end;
					catch,
						errordlg(['Error in setting threshold2: ' lasterr]);
						set(findobj(gcf,'tag','OKButton'),'userdata',0);
						set(findobj(gcf,'tag','Threshold2Edit'),'userdata',0);
					end;

					threshold_units_string = get(findobj(gcf,'tag','thresholdUnitsPopup'),'string');
					threshold_units_value = get(findobj(gcf,'tag','thresholdUnitsPopup'),'value');

					if threshedit,
						handles=image_viewer_gui(image_viewer_name,'command',[image_viewer_name 'get_handles']);
						h = findobj(handles.HistogramAxes,'tag','histline');
						if ishandle(h), delete(h); end;
						oldaxes = gca;
						axes(handles.HistogramAxes);
						hold on;
						a = axis;
						plot([threshold1 threshold1],[a(3) a(4)],'g-','tag','histline');
						plot([threshold2 threshold2],[a(3) a(4)],'g-','tag','histline');
						set(handles.HistogramAxes,'tag',[image_viewer_name 'HistogramAxes']);
						axes(oldaxes);
						image_viewer_gui(image_viewer_name,'command',[image_viewer_name 'draw_image']);
						set(findobj(gcf,'tag','Threshold1Edit'),'userdata',0);
						set(findobj(gcf,'tag','Threshold2Edit'),'userdata',0);
					elseif ok,
						parameters = struct('threshold1',threshold1,'threshold2',threshold2,'threshold_units',...
							threshold_units_string(threshold_units_value));
						out = mia.image.process.at_image_doublethreshold(atd,input_itemname,output_itemname,parameters);
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
h(end+1) = struct('parent',input_itemname,'operation','mia.image.process.at_image_doublethreshold','parameters',parameters,...
	'description',['Applied threshold1 of ' num2str(parameters.threshold1) ' and threshold2 of ' num2str(parameters.threshold2) ' with units ' parameters.threshold_units ' to image ' input_itemname '.']);

im_in_file = mia.miadir.getimagefilename(atd,input_itemname);

[dummy,image_raw_filename,ext] = fileparts(im_in_file);

im_out_file = [mia.miadir.getpathname(atd) filesep 'images' filesep output_itemname filesep output_itemname ext];

input_finfo = imfinfo(im_in_file);

extra_args{1} = {'WriteMode','overwrite'};
extra_args{2} = {'WriteMode','append'};

im = [];
for i=1:length(input_finfo),
	im_here = imread(im_in_file,'index',i,'info',input_finfo);
	im = cat(3,im,im_here);
end;

if strcmp(parameters.threshold_units,'percentile'),
	t1 = prctile(im(:),parameters.threshold1);
	t2 = prctile(im(:),parameters.threshold2);
elseif strcmp(parameters.threshold_units, 'raw'),
	t1 = parameters.threshold1;
	t2 = parameters.threshold2;
else,
	error(['Unknown threshold units: ' parameters.threshold_units '.']);
end; 

bin = vlt.image.doublethreshold(im,t1,t2,26);

% write the new file

for i=1:length(input_finfo),
	if i==1, try, mkdir([mia.miadir.getpathname(atd) filesep 'images' filesep output_itemname]); end; end;
	im_here = logical(bin(:,:,i));
	imwrite(im_here,im_out_file,extra_args{1+double(i>1)}{:});
end;

str2text([mia.miadir.getpathname(atd) filesep 'images' filesep output_itemname filesep 'parent.txt'], input_itemname);

mia.miadir.sethistory(atd,'images',output_itemname,h);

out = 1;

