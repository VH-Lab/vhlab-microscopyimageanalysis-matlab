classdef doublethreshold < mia.creator

	properties
	end % properties

	methods
		function mia_image_doublethreshold_obj = doublethreshold(varargin)
			mia_image_doublethreshold_obj = mia_image_doublethreshold_obj@mia.creator(varargin{:}); % call superclass constructor
			mia_image_doublethreshold_obj.input_types = {'image'};
			mia_image_doublethreshold_obj.output_types = {'image'}; % abstract creator does not make any objects
			mia_image_doublethreshold_obj.iseditor = 1;
			mia_image_doublethreshold_obj.default_parameters = struct('threshold1',95, 'threshold2', 75, 'threshold_units', 'percentile', 'connectivity', 26); 
			mia_image_doublethreshold_obj.parameter_list = {'threshold1', 'threshold2', 'threshold_units', 'connectivity' };
			mia_image_doublethreshold_obj.parameter_descriptions = {'Threshold1 to apply to image to detect presence of objects (real number)',...
                'Threshold2 to apply to image to detect presence of objects (real number)', ...
                'Units of thresholds; can be ''raw'' to use raw image units or ''percentile'' to use percentile of data.', ...
			    'Connectivity argument to bwconncomp (26 for 3d all edge connectivity)'};
			mia_image_doublethreshold_obj.parameter_selection_methods = {'choose_inputdlg'};
		end % creator()

		function b = make(mia_image_doublethreshold_obj, parameters)
			% MAKE - make the object requested from the parameters given
			%
			% B = mia.creator.make(MIA_CREATOR_OBJ, INPUT_NAME, OUTPUT_NAME, PARAMETERS)
			%
			% Make the new object from the parameters, input name, and output name.
			%
			% B is 1 if the action succeeds, and 0 otherwise.
			%
				input_itemname = mia_image_doublethreshold_obj.input_name;
				output_itemname = mia_image_doublethreshold_obj.output_name;

				h = mia_image_doublethreshold_obj.mdir.gethistory('images',input_itemname);
				h(end+1) = struct('parent',input_itemname,'operation','mia.creator.image.doublethreshold','parameters',parameters,...
	                'description',['Applied threshold1 of ' num2str(parameters.threshold1) ' and threshold2 of ' num2str(parameters.threshold2) ' with units ' parameters.threshold_units ' to image ' input_itemname '.']);

				im_in_file = mia_image_doublethreshold_obj.mdir.getimagefilename(input_itemname);
				[dummy,image_raw_filename,ext] = fileparts(im_in_file);
				im_out_file = [mia_image_doublethreshold_obj.mdir.getpathname() filesep ...
					'images' filesep output_itemname filesep output_itemname ext];

				input_finfo = imfinfo(im_in_file);

				extra_args{1} = {'WriteMode','overwrite'};
				extra_args{2} = {'WriteMode','append'};

				foldername = [mia_image_doublethreshold_obj.mdir.getpathname() filesep 'images' filesep output_itemname];
				if ~isfolder(foldername),
					mkdir(foldername);
				end;

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
	                im_here = logical(bin(:,:,i));
	                imwrite(im_here,im_out_file,extra_args{1+double(i>1)}{:});
                end;

                str2text([mia_image_doublethreshold_obj.mdir.getpathname() filesep 'images' filesep output_itemname filesep 'parent.txt'], input_itemname);
				mia_image_doublethreshold_obj.mdir.sethistory('images',output_itemname,h);
		end % make()

        function f = build_gui_parameterwindow(mia_image_doublethreshold_obj)
				f = figure;
				pos = get(f,'position');
				set(f,'position',[pos([1 2]) 500 500]);
				imfile = mia_image_doublethreshold_obj.mdir.getimagefilename(mia_image_doublethreshold_obj.input_name);
				uidefs = vlt.ui.basicuitools_defs;
				row = 25;
			    uicontrol(uidefs.txt,'position',  [20 350-0*row 45 25],'string','Threshold1:');
			    uicontrol(uidefs.edit,'position', [20 350-1*row 45 25],'string','95','tag','ThresholdEdit1','userdata',1,'callback',['set(gcbo,''userdata'',1); uiresume;']);
			    uicontrol(uidefs.txt,'position',  [20 350-2*row 45 25],'string','Threshold2:');
			    uicontrol(uidefs.edit,'position', [20 350-3*row 45 25],'string','75','tag','ThresholdEdit2','userdata',1,'callback',['set(gcbo,''userdata'',1); uiresume;']);
			    uicontrol(uidefs.txt,'position',[20 350-4*row 45 25],'string','Threshold units:','tag','ThresholdUnitsTxt');
			    uicontrol(uidefs.popup,'position',[20+45+10 350-4*row 50 25],'string',{'raw','percentile'},'value',2);
			    uicontrol(uidefs.button,'position',[20 350-5*row 45 25],'string','OK', 'tag','OKButton','callback',['set(gcbo,''userdata'',1); uiresume;']);
			    uicontrol(uidefs.button,'position',[20 350-6*row 45 25],'string','Cancel','tag','CancelButton','callback',['set(gcbo,''userdata'',1); uiresume;']);

				image_viewer_name = 'IM_double_threshold';
				image_viewer_gui(image_viewer_name,'imfile',imfile,'imagemodifierfunc','mia.creator.image.doublethreshold.process_double_threshold(im);')
		end % build_gui_parameterwindow()

		function success = process_gui_click(mia_image_doublethreshold_obj, f)
				success = 0;
				image_viewer_name = 'IM_double_threshold';

				cancel = get(findobj(f,'tag','CancelButton'),'userdata');
				ok = get(findobj(f,'tag','OKButton'),'userdata');
				threshedit = get(findobj(gcf,'tag','Threshold1Edit'),'userdata') | ...
					get(findobj(gcf,'tag','Threshold2Edit'),'userdata');

				if cancel,
					success = -1;
				elseif threshedit | ok,
					try,
						p = gui2parameters(mia_image_doublethreshold_obj,f);
					catch,
						errordlg(['Error in setting threshold1: ' lasterr]);
						set(findobj(gcf,'tag','OKButton'),'userdata',0);
						set(findobj(gcf,'tag','Threshold1Edit'),'userdata',0);
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
						plot([p.threshold1 p.threshold1],[a(3) a(4)],'g-','tag','histline');
                        plot([p.threshold2 p.threshold2],[a(3) a(4)],'g-','tag','histline');
						set(handles.HistogramAxes,'tag',[image_viewer_name 'HistogramAxes']);
						axes(oldaxes);
						image_viewer_gui(image_viewer_name,'command',[image_viewer_name 'draw_image']);
						set(findobj(gcf,'tag','Threshold1Edit'),'userdata',0);
                        set(findobj(gcf,'tag','Threshold2Edit'),'userdata',0);
					elseif ok,
						success = 1;
					end;
				end;
			
		end % process_gui_click()

        function p = gui2parameters(mia_image_doublethreshold_obj,f)
            threshold1_string = get(findobj(f,'tag','Threshold1Edit'),'string');
            if isempty(threshold1_string),
                threshold1 = [];
            else,
    			threshold1 = eval([threshold1_string ';']);
            end;
			if isempty(threshold1) | ~isnumeric(threshold1),
				error(['Syntax error in threshold1: empty or not a number.']);
			end;
            p.threshold1 = threshold1;

            threshold2_string = get(findobj(f,'tag','Threshold2Edit'),'string');
            if isempty(threshold2_string),
                threshold2 = [];
            else,
    			threshold2 = eval([threshold2_string ';']);
            end;
			if isempty(threshold2) | ~isnumeric(threshold2),
				error(['Syntax error in threshold2: empty or not a number.']);
			end;
            p.threshold2 = threshold2;

			threshold_units_string = get(findobj(gcf,'tag','thresholdUnitsPopup'),'string');
            p.threshold_units = threshold_units_string;

			threshold_units_value = get(findobj(gcf,'tag','thresholdUnitsPopup'),'value');
            p.connectivity = threshold_units_value;
		end % gui2parameters()   

	end % methods

    methods (Static) % static methods

		function im_out = process_double_threshold(im) 
			image_viewer_name = 'IM_double_threshold';
			vars = image_viewer_gui(image_viewer_name,'command',[image_viewer_name 'get_vars']);

			fig = gcf;
            dummy = mia.creator.image.doublethreshold();
			p = dummy.gui2parameters(fig);
			
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

			im_out = im3;
        end % process_double_threshold

	end % static methods

end % classdef
