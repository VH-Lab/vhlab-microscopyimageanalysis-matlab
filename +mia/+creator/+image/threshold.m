classdef threshold < mia.creator

	properties
	end % properties

	methods
		function mia_image_threshold_obj = threshold(varargin)
			mia_image_threshold_obj = mia_image_threshold_obj@mia.creator(varargin{:}); % call superclass constructor
			mia_image_threshold_obj.input_types = {'image'};
			mia_image_threshold_obj.output_types = {'image'}; % abstract creator does not make any objects
			mia_image_threshold_obj.iseditor = 1;
			mia_image_threshold_obj.default_parameters = struct('threshold',100); 
			mia_image_threshold_obj.parameter_list = {'threshold'};
			mia_image_threshold_obj.parameter_descriptions = {'Threshold to apply to image to detect presence of objects (real number)'};
			mia_image_threshold_obj.parameter_selection_methods = {'choose_inputdlg','choose_graphical'};
		end % creator()

		function b = make(mia_image_threshold_obj, parameters)
			% MAKE - make the object requested from the parameters given
			%
			% B = mia.creator.make(MIA_CREATOR_OBJ, INPUT_NAME, OUTPUT_NAME, PARAMETERS)
			%
			% Make the new object from the parameters, input name, and output name.
			%
			% B is 1 if the action succeeds, and 0 otherwise.
			%
				input_itemname = mia_image_threshold_obj.input_name;
				output_itemname = mia_image_threshold_obj.output_name;

				h = mia_image_threshold_obj.mdir.gethistory('images',input_itemname);
				h(end+1) = struct('parent',input_itemname,'operation','mia.creator.image.threshold','parameters',parameters,...
					'description',['Applied threshold of ' num2str(parameters.threshold) ' to image ' input_itemname '.']);
				im_in_file = mia_image_threshold_obj.mdir.getimagefilename(input_itemname);
				[dummy,image_raw_filename,ext] = fileparts(im_in_file);
				im_out_file = [getpathname(mia_image_threshold_obj.mdir) filesep ...
					'images' filesep output_itemname filesep output_itemname ext];

				input_finfo = imfinfo(im_in_file);

				extra_args{1} = {'WriteMode','overwrite'};
				extra_args{2} = {'WriteMode','append'};

				foldername = [getpathname(mia_image_threshold_obj.mdir) filesep 'images' filesep output_itemname];
				if ~isfolder(foldername),
					mkdir(foldername);
				end;

				for i=1:length(input_finfo),
					im = imread(im_in_file,'index',i,'info',input_finfo);
					im = logical(im > parameters.threshold);
					imwrite(im,im_out_file,extra_args{1+double(i>1)}{:});
					% really ought to have a setparent method
				end;
				str2text([getpathname(mia_image_threshold_obj.mdir) filesep ...
					'images' filesep output_itemname filesep 'parent.txt'], input_itemname);
				mia_image_threshold_obj.mdir.sethistory('images',output_itemname,h);
		end % make()

		function f = build_gui_parameterwindow(mia_image_threshold_obj)
				f = figure;
				pos = get(f,'position');
				set(f,'position',[pos([1 2]) 500 500]);
				imfile = getimagefilename(mia_image_threshold_obj.mdir, mia_image_threshold_obj.input_name);
				uidefs = vlt.ui.basicuitools_defs;
				uicontrol(uidefs.txt,'position',  [20 350 45 25],'string','Threshold:');
				uicontrol(uidefs.edit,'position', [20 325 45 25],'string','1000','tag',...
					'ThresholdEdit','userdata',1,'callback',['set(gcbo,''userdata'',1); uiresume;']);
				uicontrol(uidefs.button,'position',[20 300 45 25],'string','OK', ...
					'tag','OKButton','callback',['set(gcbo,''userdata'',1); uiresume;']);
				uicontrol(uidefs.button,'position',[20 270 45 25],'string','Cancel',...
					'tag','CancelButton','callback',['set(gcbo,''userdata'',1); uiresume;']);

				image_viewer_name = 'IM_threshold';
				image_viewer_gui(image_viewer_name,'imfile',imfile,'imagemodifierfunc','mia.creator.image.threshold.process_threshold(im);')
		end % build_gui_parameterwindow()

		function success = process_gui_click(mia_image_threshold_obj, f)
				success = 0;
				image_viewer_name = 'IM_threshold';

				cancel = get(findobj(f,'tag','CancelButton'),'userdata');
				ok = get(findobj(f,'tag','OKButton'),'userdata');
				threshedit = get(findobj(f,'tag','ThresholdEdit'),'userdata');

				if cancel,
					success = -1;
				elseif threshedit | ok,
					try,
						p = gui2parameters(mia_image_threshold_obj,f);
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
						plot([p.threshold p.threshold],[a(3) a(4)],'g-','tag','histline');
						set(handles.HistogramAxes,'tag',[image_viewer_name 'HistogramAxes']);
						axes(oldaxes);
						image_viewer_gui(image_viewer_name,'command',[image_viewer_name 'draw_image']);
						set(findobj(gcf,'tag','ThresholdEdit'),'userdata',0);
					elseif ok,
						success = 1;
					end;
				end;
			
		end % process_gui_click()
        
		function p = gui2parameters(mia_image_threshold_obj,f)
			threshold_string = get(findobj(f,'tag','ThresholdEdit'),'string');
            if isempty(threshold_string),
                threshold = [];
            else,
    			threshold = eval([threshold_string ';']);
            end;
			if isempty(threshold) | ~isnumeric(threshold),
				error(['Syntax error in threshold: empty or not a number.']);
			end;
            p.threshold = threshold;
		end % gui2parameters()        
        

	end % methods

	methods (Static) % static methods

		function im_out = process_threshold(im) 
			image_viewer_name = 'IM_threshold';
			vars = image_viewer_gui(image_viewer_name,'command',[image_viewer_name 'get_vars']);

			fig = gcf;
            dummy = mia.creator.image.threshold();
			p = dummy.gui2parameters(fig);
			
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

			im_out = im3;
		end % process_threshold

	end % static methods

end % classdef
