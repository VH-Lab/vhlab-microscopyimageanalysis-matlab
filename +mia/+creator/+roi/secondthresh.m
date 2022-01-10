classdef secondthresh < mia.creator

	properties
	end % properties

	methods
		function mia_roi_editors_secondthresh_obj = secondthresh(varargin)
			mia_roi_editors_secondthresh_obj = mia_roi_editors_secondthresh_obj@mia.creator(varargin{:}); % call superclass constructor
			mia_roi_editors_secondthresh_obj.input_types = {'ROIs'};
			mia_roi_editors_secondthresh_obj.output_types = {'ROIs'}; 
			mia_roi_editors_secondthresh_obj.iseditor = 1;
			mia_roi_editors_secondthresh_obj.default_parameters = struct('secthresh','dist_cardinal','CV_binsize','imagename'); 
			mia_roi_editors_secondthresh_obj.parameter_list = {'secthresh',0.20,'dist_cardinal',50,'CV_binsize',5,'imagename',''};
			mia_roi_editors_secondthresh_obj.parameter_descriptions = {'Second threshold (ratio of peak height)','Distace to scan for local background (default shown)', ...
                'Number of pixels considered for coeffvar for local background (default shown)', ...
			    'Image name to use (leave blank to use default in history'};
			mia_roi_editors_secondthresh_obj.parameter_selection_methods = {'choose_inputdlg'};
		end % creator()

		function b = make(mia_roi_editors_secondthresh_obj, parameters)
			% MAKE - make the object requested from the parameters given
			%
			% B = mia.creator.make(MIA_CREATOR_OBJ, INPUT_NAME, OUTPUT_NAME, PARAMETERS)
			%
			% Make the new object from the parameters, input name, and output name.
			%
			% B is 1 if the action succeeds, and 0 otherwise.
			%
				input_itemname = mia_roi_editors_secondthresh_obj.input_name;
				output_itemname = mia_roi_editors_secondthresh_obj.output_name;

				%% Load or generate local background values & peak values
                % will gather these from the input image - they won't be saved in the new ROI
                % folder
                ROIname = mia_roi_editors_secondthresh_obj.mdir.getroifilename(input_itemname);
                foldername = fileparts(ROIname);
                if exist([foldername filesep input_itemname '_ROI_roiintparam.mat']) == 2    
                    load([foldername filesep input_itemname '_ROI_roiintparam.mat'])
                    local_bg = ROIintparam.local_bg; highest_int = ROIintparam.highest_int;
                    disp(['Found local background value, loaded in!'])
                else
                    disp(['Cannot find local background value, recalculating with provided settings!'])
                    [local_bg,highest_pixel] = mia.roi.functions.locbacgr(mia_roi_editors_secondthresh_obj.mdir,ROIname,parameters);
                end
                
                %% Load the ROIs in the set (both L and CC files from mia.GUI.archived_code.ATGUI code)
                L_in_file = mia_roi_editors_secondthresh_obj.mdir.getlabeledroifilename(input_itemname);
                roi_in_file = mia_roi_editors_secondthresh_obj.mdir.getroifilename(input_itemname);
                load(roi_in_file,'CC','-mat');
                load(L_in_file,'L','-mat');
                oldobjects = CC.NumObjects;
                
                %% Load the original image
                if isempty(parameters.imagename), % choose it 
                    [dummy,im_fname] = mia.roi.functions.underlying_image(mia_roi_editors_secondthresh_obj.mdir,input_itemname);
                    parameters.imagename = im_fname;
                end
                
                [num_images,img_stack] = mia.loadscaledstack(parameters.imagename);
                
                %% Change ROI format from indexes to y x z (ind2sub)
                [puncta_info] = mia.utilities.puncta_info(img_stack,CC);
                
                %% Find the location, intensity, and frame of the peak pixel
                for punctum = 1: size(puncta_info,1),
                intensities = cell2mat(puncta_info(punctum,3));
                pixel_locs = cell2mat(puncta_info(punctum,2));
                
                %% Narrow our selections to the second threshold
                which_zframes = unique(pixel_locs(:,3));
                loc_abv = [];
                
                if size(local_bg,2) < size(puncta_info,1)
                    local_bg(size(local_bg,2)+1:size(puncta_info,1)) = 0;
                end
                
                if isnan(local_bg(punctum)),
                    local_bg(punctum) = 1000;
                end
                
                for frame = which_zframes(1):which_zframes(end),
                    locs_this_frame = find(pixel_locs(:,3) == frame);
                    int_this_frame = intensities(locs_this_frame);
                    max_this_frame = max(int_this_frame); % can use max per frame, but in retrospect I think this is unwise
                    loc_add = locs_this_frame(find(intensities(locs_this_frame) >=  local_bg(punctum) + ((1 - parameters.secthresh) * (max_this_frame - local_bg(punctum)))));
                %     loc_add = locs_this_frame(find(intensities(locs_this_frame) >=  local_bg(punctum) + ((1 - parameters.secthresh) * (highest_pixel(punctum) - local_bg(punctum)))));
                    loc_abv = [loc_abv,loc_add'];
                end
                int_abv = intensities(loc_abv)';
                
                new_puncta_info{punctum,1} = punctum; %puncta number
                new_puncta_info{punctum,2} = pixel_locs(loc_abv,:); %locations, note this is [y x z]
                new_puncta_info{punctum,3} = int_abv; %intensities
                end
                
                %% Delete emtpy cells if necessary
                real_cells = find(~cellfun(@isempty,new_puncta_info(:,3)));
                new_puncta_info = new_puncta_info(real_cells,:);
                
                %% Restore ROI format from y x z to indexes (sub2ind) & reconstruct CC file
                sz_matrix = [size(img_stack,1) size(img_stack,2) size(img_stack,3)];
                for rois = 1:size(new_puncta_info,1)
                these_locs = cell2mat(new_puncta_info(rois,2));
                PixelIdxList{1,rois} = sub2ind(sz_matrix,these_locs(:,1),these_locs(:,2),these_locs(:,3));
                end
                
                NewCC.Connectivity = CC.Connectivity;
                NewCC.ImageSize = CC.ImageSize;
                NewCC.NumObjects = size(PixelIdxList,2);
                NewCC.PixelIdxList = PixelIdxList;
                CC = NewCC;
                L = labelmatrix(CC);
                
                %% Save the new CC, L and parameter files
                newobjects = CC.NumObjects;
                
                L_out_file = [mia_roi_editors_secondthresh_obj.mdir.getpathname() filesep 'ROIs' filesep output_itemname filesep output_itemname '_L' '.mat'];
                roi_out_file = [mia_roi_editors_secondthresh_obj.mdir.getpathname() filesep 'ROIs' filesep output_itemname filesep output_itemname '_ROI' '.mat'];
                
                try,
	                mkdir([mia_roi_editors_secondthresh_obj.mdir.getpathname() filesep 'ROIs' filesep output_itemname]);
                end;
                
                save(roi_out_file,'CC','-mat');
                save(L_out_file,'L','-mat');
                
                h = mia_roi_editors_secondthresh_obj.mdir.gethistory('ROIs',input_itemname);
                h(end+1) = struct('parent',input_itemname,'operation','mia.creator.roi.editors.secondthresh','parameters',parameters,...
	                'description',['Second threshold took ' int2str(oldobjects) ' ROIs, and transformed into ' int2str(newobjects) ' from ' input_itemname '.']);
                mia_roi_editors_secondthresh_obj.mdir.sethistory('ROIs',output_itemname,h);
                
                str2text([mia_roi_editors_secondthresh_obj.mdir.getpathname() filesep 'ROIs' filesep output_itemname filesep 'parent.txt'], input_itemname);
                mia.roi.functions.parameters(atd,roi_out_file);
		end % make()

	end % methods

end % classdef
