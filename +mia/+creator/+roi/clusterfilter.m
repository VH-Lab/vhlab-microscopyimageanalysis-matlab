classdef clusterfilter < mia.creator

    properties
    end % properties

    methods
        function mia_roi_editors_clusterfilter_obj = clusterfilter(varargin)
            mia_roi_editors_clusterfilter_obj = mia_roi_editors_clusterfilter_obj@mia.creator(varargin{:}); % call superclass constructor
            mia_roi_editors_clusterfilter_obj.input_types = {'ROIs'};
            mia_roi_editors_clusterfilter_obj.output_types = {'ROIs'};
            mia_roi_editors_clusterfilter_obj.iseditor = 1;
            mia_roi_editors_clusterfilter_obj.default_parameters = struct('indexes_to_include', 1);
            mia_roi_editors_clusterfilter_obj.parameter_list = {'indexes_to_include'};
            mia_roi_editors_clusterfilter_obj.parameter_descriptions = {'Indexes of ROIs to include'};
            mia_roi_editors_clusterfilter_obj.parameter_selection_methods = {'choose_inputdlg','choose_graphical'};
        end % creator()

        function b = make(mia_roi_editors_clusterfilter_obj, parameters)
            % MAKE - make the object requested from the parameters given
            %
            % B = mia.creator.make(MIA_CREATOR_OBJ, INPUT_NAME, OUTPUT_NAME, PARAMETERS)
            %
            % Make the new object from the parameters, input name, and output name.
            %
            % B is 1 if the action succeeds, and 0 otherwise.
            %
            input_itemname = mia_roi_editors_clusterfilter_obj.input_name;
            output_itemname = mia_roi_editors_clusterfilter_obj.output_name;

            h = mia_roi_editors_clusterfilter_obj.mdir.gethistory('ROIs',input_itemname);
            h(end+1) = struct('parent',input_itemname,'operation','mia.creator.roi.editors.clusterfilter','parameters',parameters,...
                'description',['Filtered all but ' int2str(numel(parameters.indexes_to_include)) ' of ROIS ' input_itemname '.']);
            mia.roi.functions.savesubset(mia_roi_editors_clusterfilter_obj.mdir,input_itemname, parameters.indexes_to_include, output_itemname, h);
        end % make()

        function parameters = getuserparameters_graphical(mia_roi_editors_clusterfilter_obj)
            % GETUSERPARAMETERS_GRAPHICAL - obtain parameters through a graphical user interface window
            %
            % PARAMETERS = mia.creator.getuserparameters_graphical(mia_roi_clusterfilter_obj);
            %
            % Opens a graphical user interface window to allow the user to graphically choose the parameters.
            %
            out = [];
            roi_pfile = mia_roi_editors_clusterfilter_obj.mdir.getroiparametersfilename(input_itemname);
            ROIp = load(roi_pfile,'-mat');
            o = mia.roi.functions.parameters2struct(ROIp.ROIparameters);

            [cl,ci] = cluster_points_gui('points',o);

            if isempty(cl), return; end;

            indexes = [];

            for i=1:numel(ci),
                if strcmpi(ci(i).qualitylabel,'Usable'),
                    indexes = [indexes(:) ; colvec(find(cl==i))];
                end;
            end;

            parameters = [];
            parameters.indexes_to_include = indexes;
        end % getuserparameters_graphical(mia_roi_clusterfilter_obj)

    end % methods

end % classdef
