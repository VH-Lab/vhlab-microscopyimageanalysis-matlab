classdef squatfilter < mia.creator

    properties
    end % properties

    methods
        function mia_roi_editors_squatfilter_obj = squatfilter(varargin)
            mia_roi_editors_squatfilter_obj = mia_roi_editors_squatfilter_obj@mia.creator(varargin{:}); % call superclass constructor
            mia_roi_editors_squatfilter_obj.input_types = {'ROIs'};
            mia_roi_editors_squatfilter_obj.output_types = {'ROIs'};
            mia_roi_editors_squatfilter_obj.iseditor = 1;
            mia_roi_editors_squatfilter_obj.default_parameters = struct('dist_cardinal',15,'prc_cut',5,'imagename','');
            mia_roi_editors_squatfilter_obj.parameter_list = {'dist_cardinal','prc_cut','imagename'};
            mia_roi_editors_squatfilter_obj.parameter_descriptions = {'Distace to scan for slope from peak (default shown)',...
                'Percentage of slope range to exclude (an integer percentage)', ...
                'Image name to use (leave blank to use default in history'};
            mia_roi_editors_squatfilter_obj.parameter_selection_methods = {'choose_inputdlg'};
        end % creator()

        function b = make(mia_roi_editors_squatfilter_obj, parameters)
            % MAKE - make the object requested from the parameters given
            %
            % B = mia.creator.make(MIA_CREATOR_OBJ, INPUT_NAME, OUTPUT_NAME, PARAMETERS)
            %
            % Make the new object from the parameters, input name, and output name.
            %
            % B is 1 if the action succeeds, and 0 otherwise.
            %
            input_itemname = mia_roi_editors_squatfilter_obj.input_name;
            output_itemname = mia_roi_editors_squatfilter_obj.output_name;

            %% Load or generate local background values & peak values
            ROIname = mia_roi_editors_squatfilter_obj.mdir.getroifilename(input_itemname);
            foldername = fileparts(ROIname);

            % [intensity_thresh,max_neg_slopes,cutoff,highest_pixel] = mia.roi.functions.secthreshslopes(atd,ROIname,parameters);
            [local_bg,whh,highest_pixel]= mia.roi.functions.widthhalfheight(mia_roi_editors_squatfilter_obj.mdir,ROIname,parameters);

            %% Load the ROIs in the set (both L and CC files from mia.GUI.archived_code.ATGUI code)
            L_in_file = mia_roi_editors_squatfilter_obj.mdir.getlabeledroifilename(input_itemname);
            roi_in_file = mia_roi_editors_squatfilter_obj.mdir.getroifilename(input_itemname);
            load(roi_in_file,'CC','-mat');
            load(L_in_file,'L','-mat');
            oldobjects = CC.NumObjects;

            %% Load the original image
            if isempty(parameters.imagename), % choose it
                [dummy,im_fname] = mia.roi.functions.underlying_image(mia_roi_editors_squatfilter_obj.mdir,input_itemname);
                parameters.imagename = im_fname;
            end

            [num_images,img_stack] = mia.loadscaledstack(parameters.imagename);

            %% Change ROI format from indexes to y x z (ind2sub)
            [puncta_info] = mia.utilities.puncta_info(img_stack,CC);

            %% Get simple puncta information
            for punctum = 1: size(puncta_info,1),
                intensities = cell2mat(puncta_info(punctum,3));
                pixel_locs = cell2mat(puncta_info(punctum,2));
                [highest_pixel(punctum) brightest_pixel_loc] = max(intensities);
                volume(punctum) = size(intensities,1);
            end

            %% Calculate a cutoff for squat puncta

            slenderness = highest_pixel ./ whh;
            range = max(slenderness) - min(slenderness);
            cutoff =  min(slenderness) + range / (100/parameters.prc_cut);
            % figure
            % hold on
            % plot(slenderness,'ko')
            % plot([0 size(puncta_info,1)],[cutoff cutoff],'r-')

            %% Remove any ROIs with a low maximum slope (squat puncta)
            % good_indexes = find(max_neg_slopes <= cutoff);

            good_indexes = find(slenderness >= cutoff);


            %% Save the new CC, L and parameter files
            newobjects = size(good_indexes,2);

            try,
                mkdir([mia_roi_editors_squatfilter_obj.mdir.getpathname() filesep 'ROIs' filesep output_itemname]);
            end;

            h = mia_roi_editors_squatfilter_obj.mdir.gethistory('ROIs',input_itemname);
            h(end+1) = struct('parent',input_itemname,'operation','mia.creator.roi.editors.squatfilter','parameters',parameters,...
                'description',['ROIs were pared down from ' int2str(oldobjects) ' to ' int2str(newobjects) ', rejecting non-prominent members from ' input_itemname '.']);
            mia_roi_editors_squatfilter_obj.mdir.sethistory('ROIs',output_itemname,h);

            mia.roi.functions.savesubset(mia_roi_editors_squatfilter_obj.mdir,input_itemname, good_indexes, output_itemname, h);

        end % make()

    end % methods

end % classdef
