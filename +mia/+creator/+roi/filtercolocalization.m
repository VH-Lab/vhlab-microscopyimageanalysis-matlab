classdef filtercolocalization < mia.creator

    properties
    end % properties

    methods
        function mia_roi_editors_filtercolocalization_obj = filtercolocalization(varargin)
            mia_roi_editors_filtercolocalization_obj = mia_roi_editors_filtercolocalization_obj@mia.creator(varargin{:}); % call superclass constructor
            mia_roi_editors_filtercolocalization_obj.input_types = {'ROIs'};
            mia_roi_editors_filtercolocalization_obj.output_types = {'ROIs'};
            mia_roi_editors_filtercolocalization_obj.iseditor = 1;
            mia_roi_editors_filtercolocalization_obj.default_parameters = struct('colocalization_name','','include_overlaps',1);
            mia_roi_editors_filtercolocalization_obj.parameter_list = {'colocalization_name','include_overlaps'};
            mia_roi_editors_filtercolocalization_obj.parameter_descriptions = {'Name of colocalization record to use to filter ROIs','Should we include ROIs that overlap (or exclude) (0/1)?'};
            mia_roi_editors_filtercolocalization_obj.parameter_selection_methods = {'choose_inputdlg'};
        end % creator()

        function b = make(mia_roi_editors_filtercolocalization_obj, parameters)
            % MAKE - make the object requested from the parameters given
            %
            % B = mia.creator.make(MIA_CREATOR_OBJ, INPUT_NAME, OUTPUT_NAME, PARAMETERS)
            %
            % Make the new object from the parameters, input name, and output name.
            %
            % B is 1 if the action succeeds, and 0 otherwise.
            %
            input_itemname = mia_roi_editors_filtercolocalization_obj.input_name;
            output_itemname = mia_roi_editors_filtercolocalization_obj.output_name;

            L_in_file = mia_roi_editors_filtercolocalization_obj.mdir.getlabeledroifilename(input_itemname);
            roi_in_file = mia_roi_editors_filtercolocalization_obj.mdir.getroifilename(input_itemname);
            load(roi_in_file,'CC','-mat');
            load(L_in_file,'L','-mat');

            oldobjects = CC.NumObjects;

            if ~isempty(parameters.include_overlaps), % DLW
                include_overlaps = parameters.include_overlaps;
            end

            if ~isempty(parameters.colocalization_name), % DLW
                cfile = mia_roi_editors_filtercolocalization_obj.mdir.getcolocalizationfilename(parameters.colocalization_name);
                load(cfile,'colocalization_data','-mat');

            elseif 0, % ask the user to choose it
                itemliststruct = mia_roi_editors_filtercolocalization_obj.mdir.getitems('CLAs');
                if ~isempty(itemliststruct),
                    itemlist_names = {itemliststruct.name};
                else,
                    itemlist_names = {};
                end;
                itemlist_names = setdiff(itemlist_names,input_itemname);
                if isempty(itemlist_names),
                    errordlg(['No CLAs to choose for raw data.']);
                    out = [];
                    return;
                end;
                [selection,ok] = listdlg('PromptString','Select the colocalizations image:',...
                    'SelectionMode','single','ListString',itemlist_names);
                if ok,
                    parameters.colocalization_name = itemlist_names{selection};
                else,
                    out = [];
                    return;
                end;
            end;

            % DLW
            if include_overlaps == 1;
                [A B] = find(colocalization_data.overlap_thresh);
                CC.NumObjects = size(A,1);
                CC.PixelIdxList = CC.PixelIdxList(A);
                L = labelmatrix(CC);
                newobjects = CC.NumObjects;

            elseif include_overlaps == 0,
                [A B] = find(colocalization_data.overlap_thresh);
                comp = [1:CC.NumObjects];
                A = setdiff(comp,A)';
                CC.NumObjects = size(A,1);
                CC.PixelIdxList = CC.PixelIdxList(A);
                L = labelmatrix(CC);
                newobjects = CC.NumObjects;
            end
            % end DLW

            L_out_file = [mia_roi_editors_filtercolocalization_obj.mdir.getpathname() filesep 'ROIs' filesep output_itemname filesep output_itemname '_L' '.mat'];
            roi_out_file = [mia_roi_editors_filtercolocalization_obj.mdir.getpathname() filesep 'ROIs' filesep output_itemname filesep output_itemname '_ROI' '.mat'];

            try,
                mkdir([mia_roi_editors_filtercolocalization_obj.mdir.getpathname() filesep 'ROIs' filesep output_itemname]);
            end;

            save(roi_out_file,'CC','-mat');
            save(L_out_file,'L','-mat');

            h = mia_roi_editors_filtercolocalization_obj.mdir.gethistory('ROIs',input_itemname);
            h(end+1) = struct('parent',input_itemname,'operation','mia.creator.roi.editors.filtercolocalization','parameters',parameters,...
                'description',['Filtered by colocalization: ' int2str(oldobjects) ' ROIs became ' int2str(newobjects) ' from ' input_itemname '.']);
            mia_roi_editors_filtercolocalization_obj.mdir.sethistory('ROIs',output_itemname,h);

            str2text([mia_roi_editors_filtercolocalization_obj.mdir.getpathname() filesep 'ROIs' filesep output_itemname filesep 'parent.txt'], input_itemname);

            mia.roi.functions.parameters(mia_roi_editors_filtercolocalization_obj.mdir,roi_out_file);
        end % make()

    end % methods

end % classdef
