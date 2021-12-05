classdef xysizefilter < mia.creator

	properties
	end % properties

	methods
		function mia_roi_editors_xysizefilter_obj = xysizefilter(varargin)
			mia_roi_editors_xysizefilter_obj = mia_roi_editors_xysizefilter_obj@mia.creator(varargin{:}); % call superclass constructor
			mia_roi_editors_xysizefilter_obj.input_types = {'ROIs'};
			mia_roi_editors_xysizefilter_obj.output_types = {'ROIs'}; 
			mia_roi_editors_xysizefilter_obj.iseditor = 1;
			mia_roi_editors_xysizefilter_obj.default_parameters = struct('size_minimum',1,'size_maximum',Inf); 
			mia_roi_editors_xysizefilter_obj.parameter_list = {'size_minimum','size_maximum'};
			mia_roi_editors_xysizefilter_obj.parameter_descriptions = {'Minimum max XY size of ROI to allow', 'Maximum value of max XY size to allow'};
			mia_roi_editors_xysizefilter_obj.parameter_selection_methods = {'choose_inputdlg','choose_graphical'};
		end % creator()

		function b = make(mia_roi_editors_xysizefilter_obj, parameters)
			% MAKE - make the object requested from the parameters given
			%
			% B = mia.creator.make(MIA_CREATOR_OBJ, INPUT_NAME, OUTPUT_NAME, PARAMETERS)
			%
			% Make the new object from the parameters, input name, and output name.
			%
			% B is 1 if the action succeeds, and 0 otherwise.
			%
				input_itemname = mia_roi_editors_xysizefilter_obj.input_name;
				output_itemname = mia_roi_editors_xysizefilter_obj.output_name;

				 % edit this part

                L_in_file = mia_roi_editors_xysizefilter_obj.mdir.getlabeledroifilename(input_itemname);
                roi_in_file = mia_roi_editors_xysizefilter_obj.mdir.getroifilename(input_itemname);
                load(roi_in_file,'CC','-mat');
                
                ROI_sizes = ROI_3d_max_xy_size(CC,'UseProgressBar',1);
                
                good_indexes = find( (ROI_sizes >= parameters.size_minimum) & (ROI_sizes <= parameters.size_maximum) );
                
                CC.NumObjects = length(good_indexes);
                CC.PixelIdxList = CC.PixelIdxList(good_indexes);
                L = labelmatrix(CC);
                
                L_out_file = [mia_roi_editors_xysizefilter_obj.mdir.getpathname() filesep 'ROIs' filesep output_itemname filesep output_itemname '_L' '.mat'];
                roi_out_file = [mia_roi_editors_xysizefilter_obj.mdir.getpathname() filesep 'ROIs' filesep output_itemname filesep output_itemname '_ROI' '.mat'];
                
                try, mkdir([mia_roi_editors_xysizefilter_obj.mdir.getpathname() filesep 'ROIs' filesep output_itemname]); end;
                save(roi_out_file,'CC','-mat');
                save(L_out_file,'L','-mat');
                
                h = mia_roi_editors_xysizefilter_obj.mdir.gethistory('ROIs',input_itemname),
                h(end+1) = struct('parent',input_itemname,'operation','mia.creator.roi.editors.xysizefilter','parameters',parameters,...
	                'description',['Filtered all but ' int2str(CC.NumObjects) ' ROIs with Max XY size between ' num2str(parameters.size_minimum) ' and ' num2str(parameters.size_maximum) ' of ROIS ' input_itemname '.']);
                mia_roi_editors_xysizefilter_obj.mdir.sethistory('ROIs',output_itemname,h);
                
                str2text([mia_roi_editors_xysizefilter_obj.mdir.getpathname() filesep 'ROIs' filesep output_itemname filesep 'parent.txt'], input_itemname);

		end % make()

		function f = build_gui_parameterwindow(mia_roi_editors_xysizefilter_obj)
				f = figure;
			    pos = get(f,'position');
			    set(f,'position',[pos([1 2]) 500 500]);
			    uidefs = basicuitools_defs;
			    uicontrol(uidefs.txt,'position',   [20 400 100 25],'string','Minimum Max XY size:');
			    uicontrol(uidefs.edit,'position',  [20 375 100 25],'string','1','tag','MinMaxXYSizeEdit','userdata',1,'callback',['set(gcbo,''userdata'',1); uiresume;']);
			    uicontrol(uidefs.txt,'position',   [20 350 100 25],'string','Maximum Volume:');
			    uicontrol(uidefs.edit,'position',  [20 325 100 25],'string','Inf','tag','MaxMaxXYSizeEdit','userdata',1,'callback',['set(gcbo,''userdata'',1); uiresume;']);
			    uicontrol(uidefs.button,'position',[20 300 100  25],'string','OK', 'tag','OKButton','callback',['set(gcbo,''userdata'',1); uiresume;']);
			    uicontrol(uidefs.button,'position',[20 270 100 25],'string','Cancel','tag','CancelButton','callback',['set(gcbo,''userdata'',1); uiresume;']);
    
			    handles.HistogramAxes = axes('units','pixels','position',[150 150 300 200],'tag','HistogramAxes');
    
			    % plot histogram
			    L_in_file = mia_roi_editors_xysizefilter_obj.mdir.getlabeledroifilename(input_itemname);
			    roi_in_file = mia_roi_editors_xysizefilter_obj.mdir.getroifilename(input_itemname);
			    load(roi_in_file,'CC','-mat');
    
			    ROI_sizes = ROI_3d_max_xy_size(CC, 'UseProgressBar', 1);
			    [counts,bin_centers,bin_edges,fullcounts]=autohistogram(ROI_sizes);
			    bar(bin_centers,counts,1);
			    hold on;
			    bin_dx = bin_centers(2) - bin_centers(1);
			    firstbin_start = bin_edges(1);
			    firstbin_stop = bin_centers(1)-bin_dx/2;
			    firstbin_center = mean([firstbin_start firstbin_stop]);
			    firstbin_width = firstbin_stop - firstbin_start;            
			    bar(firstbin_center, fullcounts(1), firstbin_width);
			    lastbin_start = bin_centers(end)+bin_dx/2;
			    lastbin_stop = bin_edges(end);
			    lastbin_center = mean([lastbin_start lastbin_stop]);
			    lastbin_width = lastbin_stop - lastbin_start;            
			    bar(lastbin_center, fullcounts(end-1), lastbin_width);
			    warning_state = warning;
			    warning off;
			    set(gca,'yscale','log','xscale','log');
			    a=axis;
			    axis([firstbin_start lastbin_stop 0.1 a(4)]);
			    box off;
			    ylabel('Counts');
			    xlabel('ROI size (pixels)');
                
			    oldaxes = gca;
			    axes(handles.HistogramAxes);
	    
			    axes(oldaxes);
		end % build_gui_parameterwindow()

        function success = process_gui_click(mia_roi_editors_xysizefilter_obj, f)
                success = 0;
    
                minvoledit = 1;
                maxvoledit = 1;
    
                cancel = get(findobj(gcf,'tag','CancelButton'),'userdata');
                ok = get(findobj(gcf,'tag','OKButton'),'userdata');
                minvoledit = get(findobj(gcf,'tag','MinMaxXYSizeEdit'),'userdata');
                maxvoledit = get(findobj(gcf,'tag','MaxMaxXYSizeEdit'),'userdata');
    
                if cancel,
                    success = -1;
                elseif minvoledit | maxvoledit | ok,
                    try,
                        p = gui2parameters(mia_roi_editors_xysizefilter_obj,f);
                    catch,
                        errordlg(['Error in setting minimum or maximum size constraint: ' lasterr]);
                        set(findobj(gcf,'tag','OKButton'),'userdata',0);
                        set(findobj(gcf,'tag','MinMaxXYSizeEdit'),'userdata',0);
                        set(findobj(gcf,'tag','MaxMaxXYSizeEdit'),'userdata',0);
                    end;
    
                    if minvoledit | maxvoledit,
                        h = findobj(handles.HistogramAxes,'tag','histline');
                        if ishandle(h), delete(h); end;
                        oldaxes = gca;
                        axes(handles.HistogramAxes);
                        hold on;
                        a = axis;
                        plot([minvol minvol],[a(3) a(4)],'g-','tag','histline');
                        plot([maxvol maxvol],[a(3) a(4)],'g-','tag','histline');
                        set(handles.HistogramAxes,'tag',['IMHistogramAxes']);
                        axes(oldaxes);
                        set(findobj(gcf,'tag','MinMaxXYSizeEdit'),'userdata',0);
                        set(findobj(gcf,'tag','MaxMaxXYSizeEdit'),'userdata',0);
                    elseif ok,
                        success = 1;
                    end;
                end;

        end % process_gui_click()
        
		function p = gui2parameters(mia_roi_editors_xysizefilter_obj,f)

            minvolstring = get(findobj(gcf,'tag','MinMaxXYSizeEdit'),'string');
			minvol = eval([minvolstring ';']);
			if isempty(minvol) | ~isnumeric(minvol),
				error(['Syntax error in minimum size: empty or not a number.']);
			end;
            p.size_minimum = minvol;
			maxvolstring = get(findobj(gcf,'tag','MaxMaxXYSizeEdit'),'string');
			maxvol = eval([maxvolstring ';']);
			if isempty(maxvol) | ~isnumeric(maxvol),
				error(['Syntax error in maximum size: empty or not a number.']);
			end;
            p.size_maximum = maxvol;
		end % gui2parameters()        
        
	end % methods

end % classdef
