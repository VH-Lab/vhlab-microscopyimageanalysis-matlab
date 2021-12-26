classdef connect < mia.creator

	properties
	end % properties

	methods
		function mia_roi_makers_connect_obj = connect(varargin)
				mia_roi_makers_connect_obj = mia_roi_makers_connect_obj@mia.creator(varargin{:}); % call superclass constructor
				mia_roi_makers_connect_obj.input_types = {'image'};
				mia_roi_makers_connect_obj.output_types = {'ROIs'}; 
				mia_roi_makers_connect_obj.iseditor = 0;
				mia_roi_makers_connect_obj.default_parameters = struct('connectivity',26); 
				mia_roi_makers_connect_obj.parameter_list = {'connectivity'};
				mia_roi_makers_connect_obj.parameter_descriptions = {'Connectivity to examine, such as 6, 18, 26 (see help bwconncomp)'};
				mia_roi_makers_connect_obj.parameter_selection_methods = {'choose_inputdlg'};
		end % creator()

		function b = make(mia_roi_makers_connect_obj, parameters)
			% MAKE - make the object requested from the parameters given
			%
			% B = mia.creator.make(MIA_CREATOR_OBJ, INPUT_NAME, OUTPUT_NAME, PARAMETERS)
			%
			% Make the new object from the parameters, input name, and output name.
			%
			% B is 1 if the action succeeds, and 0 otherwise.
			%
				input_itemname = mia_roi_makers_connect_obj.input_name;
				output_itemname = mia_roi_makers_connect_obj.output_name;

				im_in_file = mia_roi_makers_connect_obj.mdir.getimagefilename(input_itemname);
				[dummy,image_raw_filename,ext]=fileparts(im_in_file);
                
				L_out_file = [mia_roi_makers_connect_obj.mdir.getpathname() filesep 'ROIs' filesep ...
					 output_itemname filesep output_itemname '_L' '.mat'];
				roi_out_file = [mia_roi_makers_connect_obj.mdir.getpathname() filesep 'ROIs' filesep ...
					output_itemname filesep output_itemname '_ROI' '.mat'];
                
				input_finfo = imfinfo(im_in_file);
                
				im = logical([]);
				for i=1:length(input_finfo)
					newim = logical(imread(im_in_file,'index',i,'info',input_finfo));
					im(:,:,i) = newim;
				end;
                
				CC = bwconncomp(im,parameters.connectivity);
				L = labelmatrix(CC);
				
				try,
					mkdir([mia_roi_makers_connect_obj.mdir.getpathname() filesep 'ROIs' ...
					filesep output_itemname]);
				end;

				save(roi_out_file,'CC','-mat');
				save(L_out_file,'L','-mat');
				
				h = mia_roi_makers_connect_obj.mdir.gethistory('images',input_itemname);
				h(end+1) = struct('parent',input_itemname,'operation','mia.creator.roi.makers.connect',...
					'parameters',parameters,'description',...
					['Found ' int2str(CC.NumObjects) ' ROIs with conn=' ...
						num2str(parameters.connectivity) ' to image ' input_itemname '.']);
				mia_roi_makers_connect_obj.mdir.sethistory('ROIs',output_itemname,h);
				
				str2text([mia_roi_makers_connect_obj.mdir.getpathname() filesep 'ROIs' filesep ...
					output_itemname filesep 'parent.txt'], input_itemname);
				
				mia.roi.functions.parameters(mia_roi_makers_connect_obj.mdir,roi_out_file);
		end % make()

	end % methods

end % classdef
