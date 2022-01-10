classdef combine < mia.creator

	properties
	end % properties

	methods
		function mia_roi__editors_combine_obj = combine(varargin)
			mia_roi__editors_combine_obj = mia_roi__editors_combine_obj@mia.creator(varargin{:}); % call superclass constructor
			mia_roi__editors_combine_obj.input_types = {'ROIs'};
			mia_roi__editors_combine_obj.output_types = {'ROIs'}; 
			mia_roi__editors_combine_obj.iseditor = 1;
			mia_roi__editors_combine_obj.default_parameters = struct([]); 
			mia_roi__editors_combine_obj.parameter_list = {};
			mia_roi__editors_combine_obj.parameter_descriptions = {};
			mia_roi__editors_combine_obj.parameter_selection_methods = {'The Default'};
		end % creator()

		function b = make(mia_roi__editors_combine_obj, parameters)
			% MAKE - make the object requested from the parameters given
			%
			% B = mia.creator.make(MIA_CREATOR_OBJ, INPUT_NAME, OUTPUT_NAME, PARAMETERS)
			%
			% Make the new object from the parameters, input name, and output name.
			%
			% B is 1 if the action succeeds, and 0 otherwise.
			%
                input_itemname = mia_roi__editors_combine_obj.input_name;
				output_itemname = mia_roi__editors_combine_obj.output_name;

				L_in_file = mia_roi__editors_combine_obj.mdir.getlabeledroifilename(input_itemname);
                roi_in_file = mia_roi__editors_combine_obj.mdir.getroifilename(input_itemname);
                load(roi_in_file,'CC','-mat');
                
                oldobjects = CC.NumObjects;
                
                CC.PixelIdxList = {cat(1,CC.PixelIdxList{:})};
                CC.NumObjects = 1;
                
                L = labelmatrix(CC);
                
                L_out_file = [mia_roi__editors_combine_obj.mdir.getpathname() filesep 'ROIs' filesep output_itemname filesep output_itemname '_L' '.mat'];
                roi_out_file = [mia_roi__editors_combine_obj.mdir.getpathname() filesep 'ROIs' filesep output_itemname filesep output_itemname '_ROI' '.mat'];
                
                try, mkdir([mia_roi__editors_combine_obj.mdir.getpathname() filesep 'ROIs' filesep output_itemname]); end;
                save(roi_out_file,'CC','-mat');
                save(L_out_file,'L','-mat');
                
                h = mia_roi__editors_combine_obj.mdir.gethistory('ROIs',input_itemname),
                h(end+1) = struct('parent',input_itemname,'operation','mia.creator.roi.editors.combine','parameters',parameters,...
	                'description',['Combined ' int2str(oldobjects) ' ROIs into 1 from ' input_itemname '.']);
                mia_roi__editors_combine_obj.mdir.sethistory('ROIs',output_itemname,h);
                
                str2text([mia_roi__editors_combine_obj.mdir.getpathname() filesep 'ROIs' filesep output_itemname filesep 'parent.txt'], input_itemname);
		end % make()

        function parameters = getuserparameters_nonstandard(mia_roi__editors_combine_obj, method)
			% GETUSERPARAMETERS_NONSTANDARD - select user parameters via a method other than 'choose_inputdlg' or 'choose_graphical'
			%
			% PARAMETERS = mia.creator.getuserparameters_nonstandard(method)
			%
			% Return the parameters via a method other than 'choose_inputdlg' or 'choose_graphical'.
			% 
			% In the base class, this returns an error because there are no other methods. It can
			% be overridden in subclasses to perform actions.
			%
			%
                if ischar(method) & method == 'the default',
                    parameters = [];
                    make(mia_roi__editors_combine_obj, parameters);
                end;
		end % getuserparameters_nonstandard()

	end % methods

end % classdef
