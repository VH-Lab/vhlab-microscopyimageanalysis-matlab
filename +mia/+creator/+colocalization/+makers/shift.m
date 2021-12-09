classdef shift < mia.creator

	properties
	end % properties

	methods
        function mia_colocalization_makers_shift_obj = shift(varargin)
			mia_colocalization_makers_shift_obj = mia_colocalization_makers_shift_obj@mia.creator(varargin{:}); % call superclass constructor
			mia_colocalization_makers_shift_obj.input_types = {'CLAs'};
			mia_colocalization_makers_shift_obj.output_types = {'CLAs'}; 
			mia_colocalization_makers_shift_obj.iseditor = 1;
			mia_colocalization_makers_shift_obj.default_parameters = struct('shifts', -2:2, 'threshold', 0.33, 'roi_set_2' , ''); 
			mia_colocalization_makers_shift_obj.parameter_list = {'shifts','threshold','roi_set_2'};
			mia_colocalization_makers_shift_obj.parameter_descriptions = {'Shifts to examine (such as [-2:2])',...
		        'Percent by which ROIs must overlap to be called ''colocalized''',...
		        'Name of second ROI set with which to compute overlap (leave blank to choose)'};
			mia_colocalization_makers_shift_obj.parameter_selection_methods = {'choose_inputdlg'};
		end % creator()

        function b = make(mia_colocalization_makers_shift_obj, parameters)
            % MAKE - make the object requested from the parameters given
            %
            % B = mia.creator.make(MIA_CREATOR_OBJ, INPUT_NAME, OUTPUT_NAME, PARAMETERS)
            %
            % Make the new object from the parameters, input name, and output name.
            %
            % B is 1 if the action succeeds, and 0 otherwise.
            %
                input_itemname = mia_colocalization_makers_shift_obj.input_name;
                output_itemname = mia_colocalization_makers_shift_obj.output_name;
 
                % now actually do it
    
                % Step 1: load the data
                %   Step 1A:
                %    need the roi files for the 2 channels
    
                rois{1} = mia_colocalization_makers_shift_obj.mdir.getroifilename(input_itemname);
                L{1} = mia_colocalization_makers_shift_obj.mdir.getlabeledroifilename(input_itemname);
                
                rois{2} = mia_colocalization_makers_shift_obj.mdir.getroifilename(parameters.roi_set_2);
                L{2} = mia_colocalization_makers_shift_obj.mdir.getlabeledroifilename(parameters.roi_set_2);
                
                rois_{1} = load(rois{1},'-mat');
                L_{1} = load(L{1},'-mat');
                rois_{2} = load(rois{2},'-mat');
                L_{2} = load(L{2},'-mat');
                
                
                 % step 2: compute 
                
                [overlap_ab, overlap_ba] = ROI_3d_all_overlaps(rois_{1}.CC, L_{1}.L, rois_{2}.CC, L_{2}.L, parameters.shifts, parameters.shifts, parameters.shifts);
                
                search_size = size(overlap_ab,3)*size(overlap_ab,4)*size(overlap_ab,5);
                
                overlap_thresh = overlap_ab >= parameters.threshold;
                
                parameters.roi_set_1 = input_itemname;
                
                colocalization_data = var2struct('overlap_ab','overlap_ba','overlap_thresh','parameters');
                
                 % step 3: save and add history
                
                colocalizationdata_out_file = [mia_colocalization_makers_shift_obj.mdir.getpathname() filesep 'CLAs' filesep output_itemname filesep output_itemname '_CLA' '.mat'];
                
                try, mkdir([mia_colocalization_makers_shift_obj.mdir.getpathname() filesep 'CLAs' filesep output_itemname]); end;
                save(colocalizationdata_out_file,'colocalization_data','-mat');
                
                overlapped_objects = sum(overlap_thresh(:));
                
                h = mia_colocalization_makers_shift_obj.mdir.gethistory('images',input_itemname);
                h(end+1) = struct('parent',input_itemname,'operation','mia.creator.colocalization.makers.shift','parameters',parameters,...
	                'description',['Found ' int2str(overlapped_objects) ' CLs with threshold = ' num2str(parameters.threshold) ' of ROI ' input_itemname ' onto ROI ' parameters.roi_set_2 '.']);
                
                mia_colocalization_makers_shift_obj.mdir.sethistory('CLAs',output_itemname,h);
                
                str2text([mia_colocalization_makers_shift_obj.mdir.getpathname() filesep 'CLAs' filesep output_itemname filesep 'parent.txt'], input_itemname);

        end % make()

        function parameters = getuserparameters_choosedlg(mia_colocalization_makers_shift_obj)
            % GETUSERPARAMETERS_CHOOSEDLG - obtain parameters through a standard dialog box
            %
            % PARAMETERS = mia.creator.getuserparameters_choosedlg(MIA_CREATOR_OBJ)
            %
            % Obtain parameters by asking the user questions in a dialog box.
            %
            % If the user clicks cancel, PARAMETERS is empty.

                [plist,pdesc,psel] = mia_colocalization_makers_shift_obj.parameter_details();
                parameters = dlg2struct('Choose parameters',plist,pdesc,mia_colocalization_makers_shift_obj.default_parameters);
                if isempty(parameters.roi_set_2),
                    itemliststruct = mia_colocalization_makers_shift_obj.mdir.getitems('ROIs');
                    if ~isempty(itemliststruct),
                        itemlist_names = {itemliststruct.name};
                    else,
                        itemlist_names = {};
                    end;
                    itemlist_names = setdiff(itemlist_names,input_itemname);
                    if isempty(itemlist_names),
                        errordlg(['No additional ROIs to choose for 2nd set.']);
                        return;
                    end;
                    [selection,ok] = listdlg('PromptString','Select the 2nd ROI set:',...
                        'SelectionMode','single','ListString',itemlist_names);
                    if ok,
                        parameters.roi_set_2 = itemlist_names{selection};
                    else,
                        return;
                    end;
                end;

        end % getuserparameters_choosedlg(mia_colocalization_makers_shift_obj)

    end % methods
    
end % classdef
