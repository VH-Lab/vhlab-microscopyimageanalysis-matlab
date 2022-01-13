classdef thresholdimport < mia.creator

	properties
	end % properties

	methods
		function mia_image_thresholdimport_obj = thresholdimport(varargin)
			mia_image_thresholdimport_obj = mia_image_thresholdimport_obj@mia.creator(varargin{:}); % call superclass constructor
			mia_image_thresholdimport_obj.input_types = {'image'};
			mia_image_thresholdimport_obj.output_types = {'image'}; 
			mia_image_thresholdimport_obj.iseditor = 1;
			mia_image_thresholdimport_obj.default_parameters = struct('input_filename',''); 
			mia_image_thresholdimport_obj.parameter_list = {'input_filename'};
			mia_image_thresholdimport_obj.parameter_descriptions = {'Filename that has the thresholded input file (leave blank to choose on the fly)'};
			mia_image_thresholdimport_obj.parameter_selection_methods = {'choose_inputdlg'};
		end % creator()

		function b = make(mia_image_thresholdimport_obj, parameters)
			% MAKE - make the object requested from the parameters given
			%
			% B = mia.creator.make(MIA_CREATOR_OBJ, INPUT_NAME, OUTPUT_NAME, PARAMETERS)
			%
			% Make the new object from the parameters, input name, and output name.
			%
			% B is 1 if the action succeeds, and 0 otherwise.
			%
                if isempty(parameters.input_filename),
	                [fname,fpath] = uigetfile('*');
	                parameters.input_filename = fullfile(fpath,fname);
                end;

                parameters.input_filename,
                if isempty(parameters.input_filename),
	                error(['no file selected.']);
                end;

				input_itemname = mia_image_thresholdimport_obj.input_name;
				output_itemname = mia_image_thresholdimport_obj.output_name;
                
				h = mia_image_thresholdimport_obj.mdir.gethistory('images',input_itemname);
                h(end+1) = struct('parent',input_itemname,'operation','mia.creator.image.thresholdimport','parameters',parameters,...
	                'description',['Applied threshold using file ' parameters.input_filename ' to image ' input_itemname '.']);
                
                im_in_file = parameters.input_filename;
                [dummy,image_raw_filename,ext] = fileparts(im_in_file);

				im_out_file = [mia_image_thresholdimport_obj.mdir.getpathname() filesep ...
					'images' filesep output_itemname filesep output_itemname ext];

				input_finfo = imfinfo(im_in_file);

				extra_args{1} = {'WriteMode','overwrite'};
				extra_args{2} = {'WriteMode','append'};

                for i=1:length(input_finfo),
	                i,
	                im = imread(im_in_file,'index',i,'info',input_finfo);
	                if i==1,
		                try,
			                mkdir([mia_image_thresholdimport_obj.mdir.getpathname() filesep 'images' filesep output_itemname]);
		                end;
	                end;
	                im = logical(im > 0);
                    imwrite(uint8(im),im_out_file,extra_args{1+double(i>1)}{:});
	                str2text([mia_image_thresholdimport_obj.mdir.getpathname() filesep 'images' filesep output_itemname filesep 'parent.txt'], input_itemname);
                end;

				mia_image_thresholdimport_obj.mdir.sethistory('images',output_itemname,h);
		end % make()

    end % methods
    
end % classdef
