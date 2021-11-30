classdef blur < mia.creator

	properties
	end % properties

	methods
		function mia_image_blur_obj = blur(varargin)
			mia_image_blur_obj = mia_image_blur_obj@mia.creator(varargin{:}); % call superclass constructor
			mia_image_blur_obj.input_types = {'image'};
			mia_image_blur_obj.output_types = {'image'}; % abstract creator does not make any objects
			mia_image_blur_obj.iseditor = 1;
			mia_image_blur_obj.default_parameters = struct('useGaussian',1, 'radius', 20, 'filtersize', 100); 
			mia_image_blur_obj.parameter_list = {'useGaussian', 'radius','filtersize'};
			mia_image_blur_obj.parameter_descriptions = {'Filter type: 1=gaussian, 0=pure circle','Radius in pixels','Convolution filter in pixels'};
			mia_image_blur_obj.parameter_selection_methods = {'choose_inputdlg'};
		end % creator()

		function b = make(mia_image_blur_obj, parameters)
			% MAKE - make the object requested from the parameters given
			%
			% B = mia.creator.make(MIA_CREATOR_OBJ, INPUT_NAME, OUTPUT_NAME, PARAMETERS)
			%
			% Make the new object from the parameters, input name, and output name.
			%
			% B is 1 if the action succeeds, and 0 otherwise.
			%
				input_itemname = mia_image_blur_obj.input_name;
				output_itemname = mia_image_blur_obj.output_name;

                if parameters.useGaussian,
	                filter_type_str = 'Gaussian';
                else,
	                filter_type_str = 'circular';
                end;

				h = mia_image_blur_obj.mdir.gethistory('images',input_itemname);
                h(end+1) = struct('parent',input_itemname,'operation','mia.creator.image.blur','parameters',parameters,...
	                'description',['Applied ' filter_type_str ' blur with radius ' num2str(parameters.radius) ...
                    ' and filtersize ' num2str(parameters.filtersize) ' to image ' input_itemname '.']);
				im_in_file = mia_image_blur_obj.mdir.getimagefilename(input_itemname);
				[dummy,image_raw_filename,ext] = fileparts(im_in_file);
				im_out_file = [getpathname(mia_image_blur_obj.mdir) filesep ...
					'images' filesep output_itemname filesep output_itemname ext];

				input_finfo = imfinfo(im_in_file);

				extra_args{1} = {'WriteMode','overwrite'};
				extra_args{2} = {'WriteMode','append'};

				foldername = [getpathname(mia_image_blur_obj.mdir) filesep 'images' filesep output_itemname];
				if ~isfolder(foldername),
					mkdir(foldername);
				end;

				for i=1:length(input_finfo),
	                im = imread(im_in_file,'index',i,'info',input_finfo);         % Reads the image
	                im_out = vlt.image.circular_filter(im,parameters.useGaussian, parameters.radius, parameters.filtersize);     % Calls the circular_filter function and applies threshold to the image.
	                imwrite(im_out,im_out_file,extra_args{1+double(i>1)}{:});
	                str2text([getpathname(mia_image_blur_obj.mdir) filesep 'images' filesep output_itemname filesep 'parent.txt'], input_itemname);
                end;
				mia_image_blur_obj.mdir.sethistory('images',output_itemname,h);
		end % make()

	end % methods

end % classdef
