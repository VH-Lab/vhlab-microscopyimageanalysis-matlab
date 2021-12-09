classdef centerofmass < mia.creator

	properties
	end % properties

	methods
        function mia_colocalization_makers_centerofmass_obj = centerofmass(varargin)
			mia_colocalization_makers_centerofmass_obj = mia_colocalization_makers_centerofmass_obj@mia.creator(varargin{:}); % call superclass constructor
			mia_colocalization_makers_centerofmass_obj.input_types = {'CLAs'};
			mia_colocalization_makers_centerofmass_obj.output_types = {'CLAs'}; 
			mia_colocalization_makers_centerofmass_obj.iseditor = 1;
			mia_colocalization_makers_centerofmass_obj.default_parameters = struct('distance_threshold', 5, 'distance_infinity', 50, 'show_graphical_progress', 1, 'roi_set_2', ''); 
			mia_colocalization_makers_centerofmass_obj.parameter_list = {'distance_threshold','distance_infinity', 'show_graphical_progress', 'roi_set_2'};
			mia_colocalization_makers_centerofmass_obj.parameter_descriptions = {'Distance threshold (pixels) that determines when 2 ROIs will be considered colocalized.' , ...
                'Distance at which ROIs are considered very far apart (saves memory)', ...
                '0/1 Should we show a progress bar?', ...
                'Name of second ROI set with which to compute overlap (leave blank to choose)'};
			mia_colocalization_makers_centerofmass_obj.parameter_selection_methods = {'choose_inputdlg'};
		end % creator()

        function b = make(mia_colocalization_makers_centerofmass_obj, parameters)
            % MAKE - make the object requested from the parameters given
            %
            % B = mia.creator.make(MIA_CREATOR_OBJ, INPUT_NAME, OUTPUT_NAME, PARAMETERS)
            %
            % Make the new object from the parameters, input name, and output name.
            %
            % B is 1 if the action succeeds, and 0 otherwise.
            %
                input_itemname = mia_colocalization_makers_centerofmass_obj.input_name;
                output_itemname = mia_colocalization_makers_centerofmass_obj.output_name;
 
                % now actually do it
    
                % Step 1: load the data
                %   Step 1A:
                %    need the roi files for the 2 channels
    
                if parameters.show_graphical_progress, progressbar('Setting up for ROI overlap calculation'); end;
    
                rois{1} = mia_colocalization_makers_centerofmass_obj.mdir.getroifilename(input_itemname);
                
                L{1} = mia_colocalization_makers_centerofmass_obj.mdir.getlabeledroifilename(input_itemname);
                try,
                    roipfilename{1} = mia_colocalization_makers_centerofmass_obj.mdir.getroiparametersfilename(input_itemname);
                    if isempty(roipfilename{1}), error('filename is empty.'); end;
                catch,
                    mia.roi.functions.parameters(mia_colocalization_makers_centerofmass_obj.mdir,rois{1});
                    roipfilename{1} = mia_colocalization_makers_centerofmass_obj.mdir.getroiparametersfilename(input_itemname);
                end;
    
                if parameters.show_graphical_progress, progressbar(0.2); end;
    
                rois{2} = mia_colocalization_makers_centerofmass_obj.mdir.getroifilename(parameters.roi_set_2);
                L{2} = mia_colocalization_makers_centerofmass_obj.mdir.getlabeledroifilename(parameters.roi_set_2);
                try,
                    roipfilename{2} = mia_colocalization_makers_centerofmass_obj.mdir.getroiparametersfilename(parameters.roi_set_2);
                catch,
                    mia.roi.functions.parameters(mia_colocalization_makers_centerofmass_obj.mdir,rois{2});
                    roipfilename{2} = mia_colocalization_makers_centerofmass_obj.mdir.getroiparametersfilename(parameters.roi_set_2);
                end
    
                if parameters.show_graphical_progress, progressbar(0.4); end;
    
                rois_{1} = load(rois{1},'-mat');
                L_{1} = load(L{1},'-mat');
                rois_{2} = load(rois{2},'-mat');
                L_{2} = load(L{2},'-mat');
                ROIp{1} = load(roipfilename{1},'-mat');
                ROIp{2} = load(roipfilename{2},'-mat');
    
                if parameters.show_graphical_progress, progressbar(0.6); end;
    
                if parameters.show_graphical_progress, progressbar(0.9); end;
    
                if parameters.show_graphical_progress, progressbar(1); end;
    
                stepsize = 1;
    
                tic,
                [distances,Is,Js,Vs] = ROI_centerofmassdistance(cat(1,ROIp{1}.ROIparameters.params3d.WeightedCentroid) , L_{1}.L, ...
                    cat(1,ROIp{2}.ROIparameters.params3d.WeightedCentroid), L_{2}.L, parameters.distance_infinity, ...
                    0.1,'ShowGraphicalProgress',parameters.show_graphical_progress);
    
                if parameters.show_graphical_progress,
                    toc,
                end;
    
                overlaps = find(Vs>0 & Vs<= parameters.distance_threshold);
    
                overlap_thresh = sparse(Is(overlaps),Js(overlaps),Vs(overlaps));
    
                parameters.roi_set_1 = input_itemname;
    
                colocalization_data = var2struct('distances','overlap_thresh','parameters');
    
                % step 3: save and add history
    
                colocalizationdata_out_file = [mia_colocalization_makers_centerofmass_obj.mdir.getpathname() filesep 'CLAs' filesep output_itemname filesep output_itemname '_CLA' '.mat'];
    
                try, mkdir([mia_colocalization_makers_centerofmass_obj.mdir.getpathname() filesep 'CLAs' filesep output_itemname]); end;
                save(colocalizationdata_out_file,'colocalization_data','-mat');
    
                overlapped_objects = numel(overlaps);
    
                h = mia_colocalization_makers_centerofmass_obj.mdir.gethistory('images',input_itemname);
                h(end+1) = struct('parent',input_itemname,'operation','mia.creator.colocalization.makers.centerofmass','parameters',parameters,...
                    'description',['Found ' int2str(overlapped_objects) ' CLs with distance threshold <= ' num2str(parameters.distance_threshold) ...
                    ' pixels of ROI ' input_itemname ' onto ROI ' parameters.roi_set_2 '.']);
    
                mia_colocalization_makers_centerofmass_obj.mdir.sethistory('CLAs',output_itemname,h);
    
                str2text([mia_colocalization_makers_centerofmass_obj.mdir.getpathname() filesep 'CLAs' filesep output_itemname filesep 'parent.txt'], input_itemname);

        end % make()

        function parameters = getuserparameters_choosedlg(mia_colocalization_makers_centerofmass_obj)
            % GETUSERPARAMETERS_CHOOSEDLG - obtain parameters through a standard dialog box
            %
            % PARAMETERS = mia.creator.getuserparameters_choosedlg(MIA_CREATOR_OBJ)
            %
            % Obtain parameters by asking the user questions in a dialog box.
            %
            % If the user clicks cancel, PARAMETERS is empty.

                [plist,pdesc,psel] = mia_colocalization_makers_centerofmass_obj.parameter_details();
                parameters = dlg2struct('Choose parameters',plist,pdesc,mia_colocalization_makers_centerofmass_obj.default_parameters);
                if isempty(parameters.roi_set_2),
                    itemliststruct = mia_colocalization_makers_centerofmass_obj.mdir.getitems('ROIs');
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

        end % getuserparameters_choosedlg(mia_colocalization_makers_centerofmass_obj)

    end % methods
    
end % classdef
