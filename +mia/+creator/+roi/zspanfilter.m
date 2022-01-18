classdef zspanfilter < mia.creator

    properties
    end % properties

    methods
        function mia_roi_editors_zspanfilter_obj = zspanfilter(varargin)
            mia_roi_editors_zspanfilter_obj = mia_roi_editors_zspanfilter_obj@mia.creator(varargin{:}); % call superclass constructor
            mia_roi_editors_zspanfilter_obj.input_types = {'ROIs'};
            mia_roi_editors_zspanfilter_obj.output_types = {'ROIs'};
            mia_roi_editors_zspanfilter_obj.iseditor = 1;
            mia_roi_editors_zspanfilter_obj.default_parameters = struct('z_span_minimum',1,'z_span_maximum',Inf);
            mia_roi_editors_zspanfilter_obj.parameter_list = {'z_span_minimum','z_span_maximum'};
            mia_roi_editors_zspanfilter_obj.parameter_descriptions = {'Minimum span of Z to allow', 'Maximum span of Z to allow'};
            mia_roi_editors_zspanfilter_obj.parameter_selection_methods = {'choose_inputdlg','choose_graphical'};
        end % creator()

        function b = make(mia_roi_editors_zspanfilter_obj, parameters)
            % MAKE - make the object requested from the parameters given
            %
            % B = mia.creator.make(MIA_CREATOR_OBJ, INPUT_NAME, OUTPUT_NAME, PARAMETERS)
            %
            % Make the new object from the parameters, input name, and output name.
            %
            % B is 1 if the action succeeds, and 0 otherwise.
            %
            input_itemname = mia_roi_editors_zspanfilter_obj.input_name;
            output_itemname = mia_roi_editors_zspanfilter_obj.output_name;

            % edit this part

            L_in_file = mia_roi_editors_zspanfilter_obj.mdir.getlabeledroifilename(input_itemname);
            roi_in_file = mia_roi_editors_zspanfilter_obj.mdir.getroifilename(input_itemname);
            load(roi_in_file,'CC','-mat');

            ROI_zspans = [];
            for i=1:length(CC.PixelIdxList),
                [X,Y,Z] = ind2sub(CC.ImageSize, CC.PixelIdxList{i});
                Zspan = max(Z) - min(Z);
                ROI_zspans(end+1) = Zspan;
            end;

            good_indexes = find( (ROI_zspans >= parameters.z_span_minimum) & (ROI_zspans <= parameters.z_span_maximum) );

            CC.NumObjects = length(good_indexes);
            CC.PixelIdxList = CC.PixelIdxList(good_indexes);
            L = labelmatrix(CC);

            L_out_file = [mia_roi_editors_zspanfilter_obj.mdir.getpathname() filesep 'ROIs' filesep output_itemname filesep output_itemname '_L' '.mat'];
            roi_out_file = [mia_roi_editors_zspanfilter_obj.mdir.getpathname() filesep 'ROIs' filesep output_itemname filesep output_itemname '_ROI' '.mat'];

            try, mkdir([mia_roi_editors_zspanfilter_obj.mdir.getpathname() filesep 'ROIs' filesep output_itemname]); end;
            save(roi_out_file,'CC','-mat');
            save(L_out_file,'L','-mat');

            h = mia_roi_editors_zspanfilter_obj.mdir.gethistory('ROIs',input_itemname),
            h(end+1) = struct('parent',input_itemname,'operation','mia.creator.roi.editors.zspanfilter','parameters',parameters,...
                'description',['Filtered all but ' int2str(CC.NumObjects) ' ROIs with z spans between ' num2str(parameters.z_span_minimum) ' and ' num2str(parameters.z_span_maximum) ' of ROIS ' input_itemname '.']);
            mia_roi_editors_zspanfilter_obj.mdir.sethistory('ROIs',output_itemname,h);

            str2text([mia_roi_editors_zspanfilter_obj.mdir.getpathname() filesep 'ROIs' filesep output_itemname filesep 'parent.txt'], input_itemname);

        end % make()

        function f = build_gui_parameterwindow(mia_roi_editors_zspanfilter_obj)
            f = figure;
            pos = get(f,'position');
            set(f,'position',[pos([1 2]) 500 500]);
            uidefs = basicuitools_defs;
            uicontrol(uidefs.txt,'position',   [20 400 100 25],'string','Minimum Z Span:');
            uicontrol(uidefs.edit,'position',  [20 375 100 25],'string','1','tag','MinZSpanEdit','userdata',1,'callback',['set(gcbo,''userdata'',1); uiresume;']);
            uicontrol(uidefs.txt,'position',   [20 350 100 25],'string','Maximum Z Span:');
            uicontrol(uidefs.edit,'position',  [20 325 100 25],'string','Inf','tag','MaxZSpanEdit','userdata',1,'callback',['set(gcbo,''userdata'',1); uiresume;']);
            uicontrol(uidefs.button,'position',[20 300 100  25],'string','OK', 'tag','OKButton','callback',['set(gcbo,''userdata'',1); uiresume;']);
            uicontrol(uidefs.button,'position',[20 270 100 25],'string','Cancel','tag','CancelButton','callback',['set(gcbo,''userdata'',1); uiresume;']);

            handles.HistogramAxes = axes('units','pixels','position',[150 150 300 200],'tag','HistogramAxes');

            % plot histogram
            L_in_file = mia_roi_editors_zspanfilter_obj.mdir.getlabeledroifilename(input_itemname);
            roi_in_file = mia_roi_editors_zspanfilter_obj.mdir.getroifilename(input_itemname);
            load(roi_in_file,'CC','-mat');

            ROI_z_spans = [];
            for i=1:length(CC.PixelIdxList),
                [X,Y,Z] = ind2sub(CC.ImageSize, CC.PixelIdxList{i});
                Zspan = max(Z) - min(Z);
                ROI_z_spans(end+1) = Zspan;
            end;
            [counts,bin_centers]=autohistogram(ROI_z_spans);
            bar(bin_centers,counts,1);
            set(gca,'yscale','linear','xscale','linear');
            a=axis;
            axis([1 max(bin_centers) a(3) a(4)]);
            box off;
            ylabel('Counts');
            xlabel('ROI z span (pixels)');

            oldaxes = gca;
            axes(handles.HistogramAxes);

            axes(oldaxes);
        end % build_gui_parameterwindow()

        function success = process_gui_click(mia_roi_editors_zspanfilter_obj, f)
            success = 0;

            minzspanedit = 1;
            maxzspanedit = 1;

            cancel = get(findobj(gcf,'tag','CancelButton'),'userdata');
            ok = get(findobj(gcf,'tag','OKButton'),'userdata');
            minzspanedit = get(findobj(gcf,'tag','MinZSpanEdit'),'userdata');
            maxzspanedit = get(findobj(gcf,'tag','MaxZSpanEdit'),'userdata');

            if cancel,
                success = -1;
            elseif minzspanedit | maxzspanedit | ok,
                try,
                    p = gui2parameters(mia_roi_editors_zspanfilter_obj,f)
                catch,
                    errordlg(['Error in setting minimum or maximum volume constraint: ' lasterr]);
                    set(findobj(gcf,'tag','OKButton'),'userdata',0);
                    set(findobj(gcf,'tag','MinZSpanEdit'),'userdata',0);
                    set(findobj(gcf,'tag','MaxZSpanEdit'),'userdata',0);
                end;

                if minzspanedit | maxzspanedit,
                    h = findobj(handles.HistogramAxes,'tag','histline');
                    if ishandle(h), delete(h); end;
                    oldaxes = gca;
                    axes(handles.HistogramAxes);
                    hold on;
                    a = axis;
                    plot([minzspan minzspan],[a(3) a(4)],'g-','tag','histline');
                    plot([maxzspan maxzspan],[a(3) a(4)],'g-','tag','histline');
                    set(handles.HistogramAxes,'tag',['IMHistogramAxes']);
                    axes(oldaxes);
                    set(findobj(gcf,'tag','MinZSpanEdit'),'userdata',0);
                    set(findobj(gcf,'tag','MaxZSpanEdit'),'userdata',0);
                elseif ok,
                    success = 1;
                end;
            end;

        end % process_gui_click()

        function p = gui2parameters(mia_roi_editors_zspanfilter_obj,f)
            minzspanstring = get(findobj(gcf,'tag','MinZSpanEdit'),'string');
            minzspan = eval([minzspanstring ';']);
            if isempty(minzspan) | ~isnumeric(minzspan),
                error(['Syntax error in minimum Z span: empty or not a number.']);
            end;
            p.z_span_minimum = minzspan;
            maxzspanstring = get(findobj(gcf,'tag','MaxZSpanEdit'),'string');
            maxzspan = eval([maxzspanstring ';']);
            if isempty(maxzspan) | ~isnumeric(maxzspan),
                error(['Syntax error in maximum Z span: empty or not a number.']);
            end;
            p.z_span_maximum = maxzspan;
        end % gui2parameters()


    end % methods

    methods (Static) % static methods

        function im_out = process_threshold(im)
            image_viewer_name = 'IM_threshold';
            vars = image_viewer_gui(image_viewer_name,'command',[image_viewer_name 'get_vars']);

            fig = gcf;
            dummy = mia.creator.image.threshold();
            p = dummy.gui2parameters(fig);

            threshold = eval([get(findobj(fig,'tag','ThresholdEdit'),'string') ';']);

            threshold_channels = [];

            above_indexes = [];

            for i=1:size(im,3),
                threshold_channels(i) = rescale(threshold,...
                    [vars.ImageScaleParams.Min(i) vars.ImageScaleParams.Max(i)], ...
                    [vars.ImageDisplayScaleParams.Min(i) vars.ImageDisplayScaleParams.Max(i)]);
                above_indexes = cat(1,above_indexes,find(im(:,:,i)>threshold_channels(i)));
            end;

            if size(im,3)==1,
                im_downscale = rescale(im,[vars.ImageDisplayScaleParams.Min(i) vars.ImageDisplayScaleParams.Max(i)],[0 1]);
                im_abovedownscale = im_downscale;
                im_abovedownscale(above_indexes) = 1;
                im3 = cat(3,im_abovedownscale,im_abovedownscale,im_downscale);
            else,
                im3 = above;
            end;

            im_out = im3;
        end % process_threshold

    end % static methods

end % classdef
