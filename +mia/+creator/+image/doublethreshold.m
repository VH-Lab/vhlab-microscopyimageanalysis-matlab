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
				im_out_file = [getpathname(mia_image_doublethreshold_obj.mdir) filesep ...
					'images' filesep output_itemname filesep output_itemname ext];

				input_finfo = imfinfo(im_in_file);

				extra_args{1} = {'WriteMode','overwrite'};
				extra_args{2} = {'WriteMode','append'};

				foldername = [getpathname(mia_image_doublethreshold_obj.mdir) filesep 'images' filesep output_itemname];
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

                str2text([getpathname(mia_image_doublethreshold_obj.mdir) filesep 'images' filesep output_itemname filesep 'parent.txt'], input_itemname);
				mia_image_doublethreshold_obj.mdir.sethistory('images',output_itemname,h);
		end % make()

	end % methods

end % classdef
