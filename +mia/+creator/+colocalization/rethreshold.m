classdef rethreshold < mia.creator

	properties
	end % properties

	methods
        function mia_colocalization_editors_rethreshold_obj = rethreshold(varargin)
			mia_colocalization_editors_rethreshold_obj = mia_colocalization_editors_rethreshold_obj@mia.creator(varargin{:}); % call superclass constructor
			mia_colocalization_editors_rethreshold_obj.input_types = {'CLAs'};
			mia_colocalization_editors_rethreshold_obj.output_types = {'CLAs'}; 
			mia_colocalization_editors_rethreshold_obj.iseditor = 1;
			mia_colocalization_editors_rethreshold_obj.default_parameters = struct('threshold',0.33); 
			mia_colocalization_editors_rethreshold_obj.parameter_list = {'threshold'};
			mia_colocalization_editors_rethreshold_obj.parameter_descriptions = {'threshold of ROI overlap to label as colocalization'};
			mia_colocalization_editors_rethreshold_obj.parameter_selection_methods = {'choose_inputdlg'};
		end % creator()

		function b = make(mia_colocalization_editors_rethreshold_obj, parameters)
			% MAKE - make the object requested from the parameters given
			%
			% B = mia.creator.make(MIA_CREATOR_OBJ, INPUT_NAME, OUTPUT_NAME, PARAMETERS)
			%
			% Make the new object from the parameters, input name, and output name.
			%
			% B is 1 if the action succeeds, and 0 otherwise.
			%
				input_itemname = mia_colocalization_editors_rethreshold_obj.input_name;
				output_itemname = mia_colocalization_editors_rethreshold_obj.output_name;
                
				 % edit this part

                cfile = mia_colocalization_editors_rethreshold_obj.mdir.getcolocalizationfilename(input_itemname);
                
                load(cfile,'colocalization_data','-mat');
                
                parent = mia_colocalization_editors_rethreshold_obj.mdir.getparent('CLAs', input_itemname);
                allrois = mia_colocalization_editors_rethreshold_obj.mdir.getitems('ROIs');
                
                if ~isfield(colocalization_data.parameters,'roi_set_1') & ~isempty(intersect(parent,{allrois.name})),
	                colocalization_data.parameters.roi_set_1 = parent;
                end;
                
                colocalization_data.parameters.threshold = parameters.threshold;
                colocalization_data.overlap_thresh = colocalization_data.overlap_ab >= parameters.threshold;
                
                overlapped_objects = sum(colocalization_data.overlap_thresh(:));
                
                colocalization_out_file = [mia_colocalization_editors_rethreshold_obj.mdir.getpathname() filesep 'CLAs' filesep output_itemname filesep output_itemname '_CLA' '.mat'];
                
                try, mkdir([mia_colocalization_editors_rethreshold_obj.mdir.getpathname() filesep 'CLAs' filesep output_itemname]); end;
                save(colocalization_out_file,'colocalization_data','-mat');
                
                h = mia_colocalization_editors_rethreshold_obj.mdir.gethistory('CLAs',input_itemname),
                h(end+1) = struct('parent',input_itemname,'operation','mia.creator.colocalization.editors.rethreshold','parameters',parameters,...
	                'description',['Rethresholded with new threshold ' num2str(parameters.threshold) '. Found ' int2str(overlapped_objects) ' CLs.' ]);
                mia_colocalization_editors_rethreshold_obj.mdir.sethistory('CLAs',output_itemname,h);
                
                str2text([mia_colocalization_editors_rethreshold_obj.mdir.getpathname() filesep 'CLAs' filesep output_itemname filesep 'parent.txt'], input_itemname);

		end % make()

    end % methods
    
end % classdef
