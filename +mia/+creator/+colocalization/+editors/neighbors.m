classdef neighbors < mia.creator

	properties
	end % properties

	methods
        function mia_colocalization_editors_neighbors_obj = neighbors(varargin)
			mia_colocalization_editors_neighbors_obj = mia_colocalization_editors_neighbors_obj@mia.creator(varargin{:}); % call superclass constructor
			mia_colocalization_editors_neighbors_obj.input_types = {'CLAs'};
			mia_colocalization_editors_neighbors_obj.output_types = {'CLAs'}; 
			mia_colocalization_editors_neighbors_obj.iseditor = 1;
			mia_colocalization_editors_neighbors_obj.default_parameters = struct('number_neighbors',2); 
			mia_colocalization_editors_neighbors_obj.parameter_list = {'number_neighbors'};
			mia_colocalization_editors_neighbors_obj.parameter_descriptions = {'Number of neighbors a colocalization must have to remain'};
			mia_colocalization_editors_neighbors_obj.parameter_selection_methods = {'choose_inputdlg'};
		end % creator()

		function b = make(mia_colocalization_editors_neighbors_obj, parameters)
			% MAKE - make the object requested from the parameters given
			%
			% B = mia.creator.make(MIA_CREATOR_OBJ, INPUT_NAME, OUTPUT_NAME, PARAMETERS)
			%
			% Make the new object from the parameters, input name, and output name.
			%
			% B is 1 if the action succeeds, and 0 otherwise.
			%
				input_itemname = mia_colocalization_editors_neighbors_obj.input_name;
				output_itemname = mia_colocalization_editors_neighbors_obj.output_name;
                
				 % edit this part

                cfile = mia_colocalization_editors_neighbors_obj.mdir.getcolocalizationfilename(input_itemname);
                
                load(cfile,'colocalization_data','-mat');
                
                parent = mia_colocalization_editors_neighbors_obj.mdir.getparent('CLAs', input_itemname);
                allrois = mia_colocalization_editors_neighbors_obj.mdir.getitems('ROIs');
                
                
                
                if ~isfield(colocalization_data.parameters,'roi_set_1') & ~isempty(intersect(parent,{allrois.name})),
	                colocalization_data.parameters.roi_set_1 = parent;
                end;
                
                [I,J] = find(colocalization_data.overlap_thresh>0);
                multi_count = [];
                
                all_cla = [I,J];
                no_neighbors = [];
                multi_neighbors = [];
                unique_I = unique(I);
                for z = 1:length(unique_I)
                    neighbors_here = numel(find(I == unique_I(z)));
                    
                    if neighbors_here >= parameters.number_neighbors
                        multi_count = [multi_count neighbors_here]; 
                    else
                        colocalization_data.overlap_thresh(unique_I(z),:) = 0;
                    end
                end
                figure
                histogram(multi_count)
                
                
                overlapped_objects = numel(multi_count);
                
                colocalization_out_file = [mia_colocalization_editors_neighbors_obj.mdir.getpathname() filesep 'CLAs' filesep output_itemname filesep output_itemname '_CLA' '.mat'];
                
                try, mkdir([mia_colocalization_editors_neighbors_obj.mdir.getpathname() filesep 'CLAs' filesep output_itemname]); end;
                save(colocalization_out_file,'colocalization_data','-mat');
                
                h = mia_colocalization_editors_neighbors_obj.mdir.gethistory('CLAs',input_itemname),
                h(end+1) = struct('parent',input_itemname,'operation','mia.creator.colocalization.editors.neighbors','parameters',parameters,...
	                'description',['Found number of neighbors at least ' num2str(parameters.number_neighbors) '. Found ' int2str(overlapped_objects) ' CLs.' ]);
                mia_colocalization_editors_neighbors_obj.mdir.sethistory('CLAs',output_itemname,h);
                
                str2text([mia_colocalization_editors_neighbors_obj.mdir.getpathname() filesep 'CLAs' filesep output_itemname filesep 'parent.txt'], input_itemname);

		end % make()

    end % methods
    
end % classdef
