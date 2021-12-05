classdef volumefilter < mia.creator

	properties
	end % properties

	methods
		function mia_roi_editors_volumefilter_obj = volumefilter(varargin)
			mia_roi_editors_volumefilter_obj = mia_roi_editors_volumefilter_obj@mia.creator(varargin{:}); % call superclass constructor
			mia_roi_editors_volumefilter_obj.input_types = {'ROIs'};
			mia_roi_editors_volumefilter_obj.output_types = {'ROIs'}; 
			mia_roi_editors_volumefilter_obj.iseditor = 1;
			mia_roi_editors_volumefilter_obj.default_parameters = struct('volume_minimum',1,'volume_maximum',Inf); 
			mia_roi_editors_volumefilter_obj.parameter_list = {'volume_minimum','volume_maximum'};
			mia_roi_editors_volumefilter_obj.parameter_descriptions = {'Minimum volume of ROI to allow', 'Maximum value of ROI to allow'};
			mia_roi_editors_volumefilter_obj.parameter_selection_methods = {'choose_inputdlg','choose_graphical'};
		end % creator()

		function b = make(mia_roi_editors_volumefilter_obj, parameters)
			% MAKE - make the object requested from the parameters given
			%
			% B = mia.creator.make(MIA_CREATOR_OBJ, INPUT_NAME, OUTPUT_NAME, PARAMETERS)
			%
			% Make the new object from the parameters, input name, and output name.
			%
			% B is 1 if the action succeeds, and 0 otherwise.
			%
				input_itemname = mia_roi_editors_volumefilter_obj.input_name;
				output_itemname = mia_roi_editors_volumefilter_obj.output_name;

				% edit this part

                L_in_file = mia_roi_editors_volumefilter_obj.mdir.getlabeledroifilename(input_itemname);
                roi_in_file = mia_roi_editors_volumefilter_obj.mdir.getroifilename(input_itemname);
                load(roi_in_file,'CC','-mat');
                
                ROI_sizes = [];
                for i=1:length(CC.PixelIdxList),
	                ROI_sizes(end+1) = numel(CC.PixelIdxList{i});
                end;
                
                good_indexes = find( (ROI_sizes >= parameters.volume_minimum) & (ROI_sizes <= parameters.volume_maximum) );
                h = mia_roi_editors_volumefilter_obj.mdir.gethistory('ROIs',input_itemname);
                h(end+1) = struct('parent',input_itemname,'operation','mia.creator.roi.editors.volumefilter','parameters',parameters,...
	                'description',['Filtered all but ' int2str(numel(good_indexes)) ' ROIs between ' num2str(parameters.volume_minimum) ' and ' num2str(parameters.volume_maximum) ' of ROIS ' input_itemname '.']);
                
                mia.roi.functions.savesubset(mia_roi_editors_volumefilter_obj.mdir,input_itemname, good_indexes, output_itemname, h);

		end % make()

		function f = build_gui_parameterwindow(mia_roi_editors_volumefilter_obj)
				f = figure;
			    pos = get(f,'position');
			    set(f,'position',[pos([1 2]) 500 500]);
			    uidefs = basicuitools_defs;
			    uicontrol(uidefs.txt,'position',   [20 400 100 25],'string','Minimum Volume:');
			    uicontrol(uidefs.edit,'position',  [20 375 100 25],'string','1','tag','MinVolumeEdit','userdata',1,'callback',['set(gcbo,''userdata'',1); uiresume;']);
			    uicontrol(uidefs.txt,'position',   [20 350 100 25],'string','Maximum Volume:');
			    uicontrol(uidefs.edit,'position',  [20 325 100 25],'string','Inf','tag','MaxVolumeEdit','userdata',1,'callback',['set(gcbo,''userdata'',1); uiresume;']);
			    uicontrol(uidefs.button,'position',[20 300 100  25],'string','OK', 'tag','OKButton','callback',['set(gcbo,''userdata'',1); uiresume;']);
			    uicontrol(uidefs.button,'position',[20 270 100 25],'string','Cancel','tag','CancelButton','callback',['set(gcbo,''userdata'',1); uiresume;']);
    
			    handles.HistogramAxes = axes('units','pixels','position',[150 150 300 200],'tag','HistogramAxes');
    
			    % plot histogram
			    L_in_file = getlabeledroifilename(atd,input_itemname);
			    roi_in_file = mia.miadir.getroifilename(atd,input_itemname);
			    load(roi_in_file,'CC','-mat');
    
			    ROI_sizes = [];
			    for i=1:length(CC.PixelIdxList),
				    ROI_sizes(end+1) = numel(CC.PixelIdxList{i});
			    end;
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

		function success = process_gui_click(mia_roi_editors_volumefilter_obj, f)
                success = 0;

			    minvoledit = 1;
			    maxvoledit = 1;

                cancel = get(findobj(gcf,'tag','CancelButton'),'userdata');
				ok = get(findobj(gcf,'tag','OKButton'),'userdata');
				minvoledit = get(findobj(gcf,'tag','MinVolumeEdit'),'userdata');
				maxvoledit = get(findobj(gcf,'tag','MaxVolumeEdit'),'userdata');
                
                if cancel,
					success = -1;
				elseif minvoledit | maxvoledit | ok,
					try,
						p = gui2parameters(mia_roi_editors_volumefilter_obj,f);
					catch,
						errordlg(['Error in setting minimum or maximum volume constraint: ' lasterr]);
						set(findobj(gcf,'tag','OKButton'),'userdata',0);
						set(findobj(gcf,'tag','MinVolumeEdit'),'userdata',0);
						set(findobj(gcf,'tag','MaxVolumeEdit'),'userdata',0);
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
						set(findobj(gcf,'tag','MinVolumeEdit'),'userdata',0);
						set(findobj(gcf,'tag','MaxVolumeEdit'),'userdata',0);
					elseif ok,
						success = 1;
                    end;
                end;

		end % process_gui_click()
        
		function p = gui2parameters(mia_roi_editors_volumefilter_obj,f)
			minvolstring = get(findobj(gcf,'tag','MinVolumeEdit'),'string');
            minvol = eval([minvolstring ';']);
		    if isempty(minvol) | ~isnumeric(minvol),
			    error(['Syntax error in minimum volume: empty or not a number.']);
		    end;
		    maxvolstring = get(findobj(gcf,'tag','MaxVolumeEdit'),'string');
		    maxvol = eval([maxvolstring ';']);
		    if isempty(maxvol) | ~isnumeric(maxvol),
			    error(['Syntax error in maximum volume: empty or not a number.']);
		    end;
            p.volume_minimum = minvol;
            p.volume_maximum = maxvol;
		end % gui2parameters()        

	end % methods

end % classdef
