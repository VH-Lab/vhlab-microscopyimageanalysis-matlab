classdef numabovethreshfilter < mia.creator

    properties
    end % properties

    methods
        function mia_roi_editors_numabovethreshfilter_obj = numabovethreshfilter(varargin)
            mia_roi_editors_numabovethreshfilter_obj = mia_roi_editors_numabovethreshfilter_obj@mia.creator(varargin{:}); % call superclass constructor
            mia_roi_editors_numabovethreshfilter_obj.input_types = {'ROIs'};
            mia_roi_editors_numabovethreshfilter_obj.output_types = {'ROIs'};
            mia_roi_editors_numabovethreshfilter_obj.iseditor = 1;
            mia_roi_editors_numabovethreshfilter_obj.default_parameters = struct('num_above',50,'imagename','');
            mia_roi_editors_numabovethreshfilter_obj.parameter_list = {'num_above','imagename'};
            mia_roi_editors_numabovethreshfilter_obj.parameter_descriptions = {'Number of pixels that must exceed the peak inclusion threshold',
                'Image name to use (leave blank to use default in history'};
            mia_roi_editors_numabovethreshfilter_obj.parameter_selection_methods = {'choose_inputdlg'};
        end % creator()

        function b = make(mia_roi_editors_numabovethreshfilter_obj, parameters)
            % MAKE - make the object requested from the parameters given
            %
            % B = mia.creator.make(MIA_CREATOR_OBJ, INPUT_NAME, OUTPUT_NAME, PARAMETERS)
            %
            % Make the new object from the parameters, input name, and output name.
            %
            % B is 1 if the action succeeds, and 0 otherwise.
            %
            input_itemname = mia_roi_editors_numabovethreshfilter_obj.input_name;
            output_itemname = mia_roi_editors_numabovethreshfilter_obj.output_name;

            %% Load the ROIs in the set (both L and CC files from mia.GUI.archived_code.ATGUI code)
            L_in_file = mia_roi_editors_numabovethreshfilter_obj.mdir.getlabeledroifilename(input_itemname);
            roi_in_file = mia_roi_editors_numabovethreshfilter_obj.mdir.getroifilename(input_itemname);
            load(roi_in_file,'CC','-mat');
            load(L_in_file,'L','-mat');
            oldobjects = CC.NumObjects;

            %% Load the original image
            if isempty(parameters.imagename), % choose it
                [dummy,im_fname] = mia.roi.functions.underlying_image(mia_roi_editors_numabovethreshfilter_obj.mdir,input_itemname);
                parameters.imagename = im_fname;
            end

            [num_images,img_stack] = mia.loadscaledstack(parameters.imagename);

            %% Change ROI format from indexes to y x z (ind2sub)
            [puncta_info] = mia.utilities.puncta_info(img_stack,CC);

            %% Get the threshold data
            hist = mia_roi_editors_numabovethreshfilter_obj.mdir.gethistory('ROIs',input_itemname);
            doublethreshname = hist(2).parent;
            hh = mia_roi_editors_numabovethreshfilter_obj.mdir.gethistory('images',doublethreshname);
            thresholdinfo = hh(end).parameters.thresholdinfo;

            threshold_to_meet = thresholdinfo(1);

            %% Remove any ROIs with lower prominence than chosen threshold
            for k = 1:size(puncta_info,1),
                number_above_threshold(k) = size(find(puncta_info{k,3} >= threshold_to_meet),1); %check that this is the correct dimension
            end

            exceeds_num_above_thresh = find(number_above_threshold >= parameters.num_above);

            new_idx_list = CC.PixelIdxList(1,exceeds_num_above_thresh);

            NewCC.Connectivity = CC.Connectivity;
            NewCC.ImageSize = CC.ImageSize;
            NewCC.NumObjects = size(new_idx_list,2);
            NewCC.PixelIdxList = new_idx_list;
            CC = NewCC;
            L = labelmatrix(CC);

            %% Save the new CC, L and parameter files
            newobjects = CC.NumObjects;

            L_out_file = [mia_roi_editors_numabovethreshfilter_obj.mdir.getpathname() filesep 'ROIs' filesep output_itemname filesep output_itemname '_L' '.mat'];
            roi_out_file = [mia_roi_editors_numabovethreshfilter_obj.mdir.getpathname() filesep 'ROIs' filesep output_itemname filesep output_itemname '_ROI' '.mat'];

            try,
                mkdir([mia_roi_editors_numabovethreshfilter_obj.mdir.getpathname() filesep 'ROIs' filesep output_itemname]);
            end;

            save(roi_out_file,'CC','-mat');
            save(L_out_file,'L','-mat');

            h = mia_roi_editors_numabovethreshfilter_obj.mdir.gethistory('ROIs',input_itemname);
            h(end+1) = struct('parent',input_itemname,'operation','mia.creator.roi.editors.numabovethreshfilter','parameters',parameters,...
                'description',['Pared down ' int2str(oldobjects) ' ROIs below ' int2str(parameters.num_above) ' pixels above peak threshold into ' int2str(newobjects) ' from ' input_itemname '.']);
            mia_roi_editors_numabovethreshfilter_obj.mdir.sethistory('ROIs',output_itemname,h);

            str2text([mia_roi_editors_numabovethreshfilter_obj.mdir.getpathname() filesep 'ROIs' filesep output_itemname filesep 'parent.txt'], input_itemname);

            mia.roi.functions.parameters(mia_roi_editors_numabovethreshfilter_obj.mdir,roi_out_file);
        end % make()

    end % methods

end % classdef
