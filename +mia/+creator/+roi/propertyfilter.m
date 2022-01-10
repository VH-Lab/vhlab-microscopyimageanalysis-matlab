classdef propertyfilter < mia.creator

	properties
	end % properties

	methods
		function mia_roi_editors_propertyfilter_obj = propertyfilter(varargin)
			mia_roi_editors_propertyfilter_obj = mia_roi_editors_propertyfilter_obj@mia.creator(varargin{:}); % call superclass constructor
			mia_roi_editors_propertyfilter_obj.input_types = {'ROIs'};
			mia_roi_editors_propertyfilter_obj.output_types = {'ROIs'}; 
			mia_roi_editors_propertyfilter_obj.iseditor = 1;
			mia_roi_editors_propertyfilter_obj.default_parameters = struct('property_name','','min_property',Inf,'max_property',Inf); 
			mia_roi_editors_propertyfilter_obj.parameter_list = {'property_name','min_property','max_property'};
			mia_roi_editors_propertyfilter_obj.parameter_descriptions = {'property name (can be solidity3, solidity2, area2, volume3, eccentricity2, MaxIntensity3)',...
                'Minimum value of property to allow', ...
                'Maximum value to allow'};
			mia_roi_editors_propertyfilter_obj.parameter_selection_methods = {'choose_inputdlg'};
		end % creator()

		function b = make(mia_roi_editors_propertyfilter_obj, parameters)
			% MAKE - make the object requested from the parameters given
			%
			% B = mia.creator.make(MIA_CREATOR_OBJ, INPUT_NAME, OUTPUT_NAME, PARAMETERS)
			%
			% Make the new object from the parameters, input name, and output name.
			%
			% B is 1 if the action succeeds, and 0 otherwise.
			%
				input_itemname = mia_roi_editors_propertyfilter_obj.input_name;
				output_itemname = mia_roi_editors_propertyfilter_obj.output_name;

				 % edit this part

                roi_in_file = mia_roi_editors_propertyfilter_obj.mdir.getroifilename(input_itemname);
                load(roi_in_file,'CC','-mat');
                roi_properties_file = mia_roi_editors_propertyfilter_obj.mdir.getroiparametersfilename(input_itemname);
                load(roi_properties_file,'-mat');
                
                eval(['ROI_property = [ROIparameters.params' parameters.property_name(end) 'd.' parameters.property_name(1:end-1) '];']);
                good_indexes = find( (ROI_property >= parameters.min_property) & (ROI_property <= parameters.max_property) );
                
                h = mia_roi_editors_propertyfilter_obj.mdir.gethistory('ROIs',input_itemname);
                h(end+1) = struct('parent',input_itemname,'operation','mia.creator.roi.editors.propertyfilter','parameters',parameters,...
	                'description',['Filtered all but ' int2str(numel(good_indexes)) ' ROIs with property ' parameters.property_name ' between ' num2str(parameters.min_property) ' and ' num2str(parameters.max_property) ' of ROIS ' input_itemname '.']);
                
                mia.roi.functions.savesubset(mia_roi_editors_propertyfilter_obj.mdir,input_itemname, good_indexes, output_itemname, h);
		end % make()

	end % methods

end % classdef
