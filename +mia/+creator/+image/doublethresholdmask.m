classdef doublethresholdmask < mia.creator

	properties
	end % properties

	methods
		function mia_image_doublethresholdmask_obj = doublethresholdmask(varargin)
			mia_image_doublethresholdmask_obj = mia_image_doublethresholdmask_obj@mia.creator(varargin{:}); % call superclass constructor
			mia_image_doublethresholdmask_obj.input_types = {'image'};
			mia_image_doublethresholdmask_obj.output_types = {'image'}; 
			mia_image_doublethresholdmask_obj.iseditor = 1;
			mia_image_doublethresholdmask_obj.default_parameters = struct('threshold1',95, 'threshold2', 75, 'threshold_units', 'percentile','mask_pixels_set_in_image', 65e3, 'connectivity', 26, 'mask_itemname', ''); 
			mia_image_doublethresholdmask_obj.parameter_list = {'threshold1', 'threshold2', 'threshold_units', 'mask_pixels_set_in_image', 'connectivity', 'mask_itemname' };
			mia_image_doublethresholdmask_obj.parameter_descriptions = {'Threshold1 to apply to image to detect presence of objects (real number)', ...
			    'Threshold2 to apply to image to detect presence of objects (real number)', ...
			    'Units of thresholds; can be ''raw'' to use raw image units or ''percentile'' to use percentile of data.', ...
			    'Value to assign pixels in the input image for pixels that are positive in the mask image.', ...
			    'Connectivity argument to bwconncomp (26 for 3d all edge connectivity)'...
                'file name of the mask item to apply to image'};
			mia_image_doublethresholdmask_obj.parameter_selection_methods = {'choose_inputdlg'};
		end % creator()

		function b = make(mia_image_doublethresholdmask_obj, parameters)
			% MAKE - make the object requested from the parameters given
			%
			% B = mia.creator.make(MIA_CREATOR_OBJ, INPUT_NAME, OUTPUT_NAME, PARAMETERS)
			%
			% Make the new object from the parameters, input name, and output name.
			%
			% B is 1 if the action succeeds, and 0 otherwise.
			%
				input_itemname = mia_image_doublethresholdmask_obj.input_name;
				output_itemname = mia_image_doublethresholdmask_obj.output_name;

                if isempty(parameters.mask_itemname),
	                [fname,fpath] = uigetfile('*');
	                parameters.mask_itemname = fullfile(fpath,fname);
                    im_mask_file = parameters.mask_itemname;
                else 
                    im_mask_file = mia_image_doublethresholdmask_obj.mdir.getimagefilename(parameters.mask_itemname);
                end;

				h = mia_image_doublethresholdmask_obj.mdir.gethistory('images',input_itemname);
                h(end+1) = struct('parent',input_itemname,'operation','mia.creator.image.doublethreshold','parameters',parameters,...
                    'description',['Applied threshold1 of ' num2str(parameters.threshold1) ...
                    ' and threshold2 of ' num2str(parameters.threshold2) ' with units ' parameters.threshold_units ' to image ' input_itemname ' with mask ' parameters.mask_itemname '.']);
				im_in_file = mia_image_doublethresholdmask_obj.mdir.getimagefilename(input_itemname);
                
				[dummy,image_raw_filename,ext] = fileparts(im_in_file);
                [dummy,image_mask_filename,ext] = fileparts(im_mask_file);
				im_out_file = [getpathname(mia_image_doublethresholdmask_obj.mdir) filesep ...
					'images' filesep output_itemname filesep output_itemname ext];

				input_finfo = imfinfo(im_in_file);
                mask_finfo = imfinfo(im_mask_file);

				extra_args{1} = {'WriteMode','overwrite'};
                extra_args{2} = {'WriteMode','append'};

				im = [];
                im_raw = [];
                for i=1:length(input_finfo),
	                im_here = imread(im_in_file,'index',i,'info',input_finfo);
	                im_raw = cat(3,im_raw,im_here);
	                mask_here = imread(im_mask_file,'index',i,'info',mask_finfo);
	                im_here(find(mask_here>0)) = parameters.mask_pixels_set_in_image;
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
                
                class(im)
                bin = vlt.image.doublethresholdresegment(im,t1,t2,parameters.connectivity,im_raw);
                
                % write the new file

                foldername = [getpathname(mia_image_doublethresholdmask_obj.mdir) filesep 'images' filesep output_itemname];
				if ~isfolder(foldername),
					mkdir(foldername);
				end;
                
                for i=1:length(input_finfo),
	                im_here = logical(bin(:,:,i));
	                imwrite(im_here,im_out_file,extra_args{1+double(i>1)}{:});
                end;
                str2text([getpathname(mia_image_doublethresholdmask_obj.mdir) filesep ...
					'images' filesep output_itemname filesep 'parent.txt'], input_itemname);
				mia_image_doublethresholdmask_obj.mdir.sethistory('images',output_itemname,h);
		end % make()

	end % methods

    methods (Static) % static methods

		function im_out = process_double_threshold_mask(im) 
			image_viewer_name = 'IM_double_threshold_mask';
	        vars = image_viewer_gui(image_viewer_name,'command',[image_viewer_name 'get_vars']);

			fig = gcf;
            dummy = mia.creator.image.doublethresholdmask();
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
        end % process_double_threshold_mask

	end % static methods

end % classdef
