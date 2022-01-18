classdef prominencyfilter < mia.creator

    properties
    end % properties

    methods
        function mia_roi_editors_prominencyfilter_obj = prominencyfilter(varargin)
            mia_roi_editors_prominencyfilter_obj = mia_roi_editors_prominencyfilter_obj@mia.creator(varargin{:}); % call superclass constructor
            mia_roi_editors_prominencyfilter_obj.input_types = {'ROIs'};
            mia_roi_editors_prominencyfilter_obj.output_types = {'ROIS'};
            mia_roi_editors_prominencyfilter_obj.iseditor = 1;
            mia_roi_editors_prominencyfilter_obj.default_parameters = struct('prom_thresh', 0, 'dist_cardinal', 50, 'CV_binsize', 5, 'imagename', '');
            mia_roi_editors_prominencyfilter_obj.parameter_list = {'prom_thresh','dist_cardinal','CV_binsize','imagename'};
            mia_roi_editors_prominencyfilter_obj.parameter_descriptions = {'Reject puncta if their peak is less than this value higher than local background (0 to calculate best guess)',...
                'Distace to scan for local background (default shown)', ...
                'Number of pixels considered for coeffvar for local background (default shown)', ...
                'Image name to use (leave blank to use default in history'};
            mia_roi_editors_prominencyfilter_obj.parameter_selection_methods = {'choose_inputdlg'};
        end % creator()

        function b = make(mia_roi_editors_prominencyfilter_obj, parameters)
            % MAKE - make the object requested from the parameters given
            %
            % B = mia.creator.make(MIA_CREATOR_OBJ, INPUT_NAME, OUTPUT_NAME, PARAMETERS)
            %
            % Make the new object from the parameters, input name, and output name.
            %
            % B is 1 if the action succeeds, and 0 otherwise.
            %
            input_itemname = mia_roi_editors_prominencyfilter_obj.input_name;
            output_itemname = mia_roi_editors_prominencyfilter_obj.output_name;

            %% Load or generate local background values & peak values
            ROIname = mia_roi_editors_prominencyfilter_obj.mdir.getroifilename(input_itemname);
            foldername = fileparts(ROIname);
            if exist([foldername filesep input_itemname '_ROI_roiintparam.mat']) == 2
                load([foldername filesep input_itemname '_ROI_roiintparam.mat'])
                local_bg = ROIintparam.local_bg; highest_pixel = ROIintparam.highest_int;
                disp(['Found local background value, loaded in!'])
            else
                disp(['Cannot find local background value, recalculating with provided settings!'])
                [local_bg,highest_pixel] = mia.roi.functions.locbacgr(mia_roi_editors_prominencyfilter_obj.mdir,ROIname,parameters);
            end

            %% Load the ROIs in the set (both L and CC files from mia.GUI.archived_code.ATGUI code)
            L_in_file = mia_roi_editors_prominencyfilter_obj.mdir.getlabeledroifilename(input_itemname);
            roi_in_file = mia_roi_editors_prominencyfilter_obj.mdir.getroifilename(input_itemname);
            load(roi_in_file,'CC','-mat');
            load(L_in_file,'L','-mat');
            oldobjects = CC.NumObjects;

            %% Load the original image
            if isempty(parameters.imagename), % choose it
                [dummy,im_fname] = mia.roi.functions.underlying_image(mia_roi_editors_prominencyfilter_obj.mdir,input_itemname);
                parameters.imagename = im_fname;
            end

            [num_images,img_stack] = mia.loadscaledstack(parameters.imagename);

            %% Change ROI format from indexes to y x z (ind2sub)
            [puncta_info] = mia.utilities.puncta_info(img_stack,CC);

            %% Calculate Best Guess for Prominency Filter (if not disabled in settings)
            if parameters.prom_thresh == 0,
                data_2D = img_stack(:,:,1); data = data_2D(:)';
                figure
                g = oghist(data,[min(data)-0.1 : 10 : max(data)],'Visible','off'); % better bins?
                xBinEdge = g.BinEdges;
                for i = 1:(size(xBinEdge,2)-1)
                    xdata(i) = (xBinEdge(i)+xBinEdge(i+1))/2;
                end
                ydata = g.BinCounts;

                realydata = find(ydata ~= 0);
                ydata = ydata(realydata);
                xdata = xdata(realydata);

                [thisfit,gof2] = fit(xdata',ydata','gauss1');
                fit_ydata = thisfit(xdata);

                [hm_val,hm_loc] = max(fit_ydata);
                hist_max =  xdata(hm_loc);
                hh = hm_val/2;
                th_hi= xdata(hm_loc+find(ydata(hm_loc:end)<hh,1));
                th_lo = xdata(find(ydata(1:hm_loc)>hh,1));
                whh = th_hi-th_lo;
                parameters.prom_thresh = whh;
                close(gcf)
            end

            %% Remove any ROIs with lower prominence than chosen threshold
            prominence = highest_pixel-local_bg;
            good_indexes = find(prominence >= parameters.prom_thresh);

            %% Save the new CC, L and parameter files
            newobjects = size(good_indexes,2);

            try,
                mkdir([mia_roi_editors_prominencyfilter_obj.mdir.getpathname() filesep 'ROIs' filesep output_itemname]);
            end;

            h = mia_roi_editors_prominencyfilter_obj.mdir.gethistory('ROIs',input_itemname);
            h(end+1) = struct('parent',input_itemname,'operation','mia.roi.editors.prominencyfilter','parameters',parameters,...
                'description',['ROIs were pared down from ' int2str(oldobjects) ' to ' int2str(newobjects) ', rejecting non-prominent members from ' input_itemname '.']);
            mia_roi_editors_prominencyfilter_obj.mdir.sethistory('ROIs',output_itemname,h);

            mia.roi.functions.savesubset(mia_roi_editors_prominencyfilter_obj.mdir,input_itemname, good_indexes, output_itemname, h);
        end % make()

    end % methods

end % classdef
