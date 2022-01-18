classdef maskfilter < mia.creator

    properties
    end % properties

    methods
        function mia_roi_editors_maskfilter_obj = maskfilter(varargin)
            mia_roi_editors_maskfilter_obj = mia_roi_editors_maskfilter_obj@mia.creator(varargin{:}); % call superclass constructor
            mia_roi_editors_maskfilter_obj.input_types = {'ROIs'};
            mia_roi_editors_maskfilter_obj.output_types = {'ROIs'};
            mia_roi_editors_maskfilter_obj.iseditor = 1;
            mia_roi_editors_maskfilter_obj.default_parameters = struct('mask_file','');
            mia_roi_editors_maskfilter_obj.parameter_list = {'mask_file'};
            mia_roi_editors_maskfilter_obj.parameter_descriptions = {'Mask file (leave blank to choose)'};
            mia_roi_editors_maskfilter_obj.parameter_selection_methods = {'choose_inputdlg','choose_graphical'};
        end % creator()

        function b = make(mia_roi_editors_maskfilter_obj, parameters)
            % MAKE - make the object requested from the parameters given
            %
            % B = mia.creator.make(MIA_CREATOR_OBJ, INPUT_NAME, OUTPUT_NAME, PARAMETERS)
            %
            % Make the new object from the parameters, input name, and output name.
            %
            % B is 1 if the action succeeds, and 0 otherwise.
            %
            input_itemname = mia_roi_editors_maskfilter_obj.input_name;
            output_itemname = mia_roi_editors_maskfilter_obj.output_name;

            if isempty(parameters.mask_file),
                [fname,fpath] = uigetfile('*');
                parameters.mask_file = fullfile(fpath,fname);
            end;

            input_finfo = imfinfo(parameters.mask_file);
            im = [];
            for i=1:numel(input_finfo),
                im = cat(3,im,imread(parameters.mask_file,'index',i,'info',input_finfo));
            end;

            L_in_file = mia_roi_editors_maskfilter_obj.mdir.getlabeledroifilename(input_itemname);
            roi_in_file = mia_roi_editors_maskfilter_obj.mdir.getroifilename(input_itemname);
            load(roi_in_file,'CC','-mat');
            load(L_in_file,'L','-mat');

            good_indexes = setdiff(unique(L(find(im>0))),0);

            h = mia_roi_editors_maskfilter_obj.mdir.gethistory('ROIs',input_itemname);
            h(end+1) = struct('parent',input_itemname,'operation','mia.creator.roi.editors.maskfilter','parameters',parameters,...
                'description',['Filtered all but ' int2str(numel(good_indexes)) ' ROIs based on ' parameters.mask_file ' of ROIS ' input_itemname '.']);

            mia.roi.functions.savesubset(mia_roi_editors_maskfilter_obj.mdir,input_itemname, good_indexes, output_itemname, h);

        end % make()

    end %methods

end % classdef
