classdef resegment < mia.creator

	properties
	end % properties

	methods
		function mia_roi_editors_resegment_obj = resegment(varargin)
			mia_roi_editors_resegment_obj = mia_roi_editors_resegment_obj@mia.creator(varargin{:}); % call superclass constructor
			mia_roi_editors_resegment_obj.input_types = {'ROIs'};
			mia_roi_editors_resegment_obj.output_types = {'ROIs'}; 
			mia_roi_editors_resegment_obj.iseditor = 1;
			mia_roi_editors_resegment_obj.default_parameters = struct('resegment_algorithm','watershed','connectivity',0,'values_outside_roi',0,'use_bwdist',0,'imagename','',assignborders',1); 
			mia_roi_editors_resegment_obj.parameter_list = {'resegment_algorithm','connectivity','values_outside_roi','use_bwdist','imagename','assignborders'};
			mia_roi_editors_resegment_obj.parameter_descriptions = {'Algorithm to be used','connectivity (0 for default)', 'use values outside roi? 0/1', ...
			'use thresholded image instead of raw (0/1)?',...
			'Image name to use (leave blank to use default in history',...
			'assign dividing pixels to border ROIs? (0/1)'};
			mia_roi_editors_resegment_obj.parameter_selection_methods = {'choose_inputdlg'};
		end % creator()

		function b = make(mia_roi_editors_resegment_obj, parameters)
			% MAKE - make the object requested from the parameters given
			%
			% B = mia.creator.make(MIA_CREATOR_OBJ, INPUT_NAME, OUTPUT_NAME, PARAMETERS)
			%
			% Make the new object from the parameters, input name, and output name.
			%
			% B is 1 if the action succeeds, and 0 otherwise.
			%
				input_itemname = mia_roi_editors_resegment_obj.input_name;
				output_itemname = mia_roi_editors_resegment_obj.output_name;

				 % edit this part
                
                L_in_file = mia_roi_editors_resegment_obj.mdir.getlabeledroifilename(input_itemname);
                roi_in_file = mia_roi_editors_resegment_obj.mdir.getroifilename(input_itemname);
                load(roi_in_file,'CC','-mat');
                load(L_in_file,'L','-mat');
                
                oldobjects = CC.NumObjects;
                
                if ischar(parameters.values_outside_roi),
                    parameters.values_outside_roi = eval(parameters.values_outside_roi);
                end; 
                if ischar(parameters.use_bwdist),
                    parameters.use_bwdist = eval(parameters.use_bwdist);
                end; 
                
                if ~isfield(parameters,'assignborders'),
                    parameters.assign_neighbors_to_roi = 1;
                else,
                    parameters.assign_neighbors_to_roi = parameters.assignborders;
                    parameters = rmfield(parameters,'assignborders');  % use the parameter name of ROI_resegment()
                end;
                
                nvp = struct2namevaluepair(rmfield(parameters,'imagename'));
                
                if isempty(parameters.imagename), % choose it 
                    h = mia_roi_editors_resegment_obj.mdir.gethistory('ROIs',input_itemname);
                    parameters.imagename = h(1).parent;
                elseif 0, % ask the user to choose it
                    itemliststruct = mia_roi_editors_resegment_obj.mdir.getitems('images');
                    if ~isempty(itemliststruct),
	                    itemlist_names = {itemliststruct.name};
                    else,
	                    itemlist_names = {};
                    end;
                    itemlist_names = setdiff(itemlist_names,input_itemname);
                    if isempty(itemlist_names),
	                    errordlg(['No image to choose for raw data.']);
	                    out = [];
	                    return;
                    end;
                    [selection,ok] = listdlg('PromptString','Select the raw image:',...
	                    'SelectionMode','single','ListString',itemlist_names);
                    if ok,
	                    parameters.imagename = itemlist_names{selection};
                    else,
	                    out = [];
	                    return;
                    end;
                end;
                
                im_in_file = mia_roi_editors_resegment_obj.mdir.getimagefilename(parameters.imagename);
                [dummy,image_raw_filename,ext]=fileparts(im_in_file);
                input_finfo = imfinfo(im_in_file);
                
                im = double([]);
                for i=1:length(input_finfo)
                        newim = double(imread(im_in_file,'index',i,'info',input_finfo));
                        im(:,:,i) = newim;
                end;
                
                [CC,L] = ROI_resegment_all(CC, L, im, 'resegment_namevaluepairs', nvp,'UseProgressBar',1);
                newobjects = CC.NumObjects;
                
                L_out_file = [mia_roi_editors_resegment_obj.mdir.getpathname() filesep 'ROIs' filesep output_itemname filesep output_itemname '_L' '.mat'];
                roi_out_file = [mia_roi_editors_resegment_obj.mdir.getpathname() filesep 'ROIs' filesep output_itemname filesep output_itemname '_ROI' '.mat'];
                
                try,
                    mkdir([mia_roi_editors_resegment_obj.mdir.getpathname() filesep 'ROIs' filesep output_itemname]);
                end;
                
                save(roi_out_file,'CC','-mat');
                save(L_out_file,'L','-mat');
                
                h = mia_roi_editors_resegment_obj.mdir.gethistory('ROIs',input_itemname);
                h(end+1) = struct('parent',input_itemname,'operation','mia.creator.roi.editors.resegment','parameters',parameters,...
                    'description',['Resegmented ' int2str(oldobjects) ' ROIs into ' int2str(newobjects) ' from ' input_itemname '.']);
                mia_roi_editors_resegment_obj.mdir.sethistory('ROIs',output_itemname,h);
                
                str2text([mia_roi_editors_resegment_obj.mdir.getpathname() filesep 'ROIs' filesep output_itemname filesep 'parent.txt'], input_itemname);
                
                mia.roi.functions.parameters(mia_roi_editors_resegment_obj.mdir,roi_out_file);
		end % make()

	end % methods

end % classdef
