function out = propertyfilter(atd, input_itemname, output_itemname, parameters)
% PROPERTYFILTER - Filter ROIs by volume
% 
%  OUT = MIA.ROI.EDITORS.PROPERTYFILTER(ATD, INPUT_ITEMNAME, OUTPUT_ITEMNAME, PARAMETERS)
%
%  If the function is called with no arguments, then a description of the parameters
%  is returned in OUT. OUT{1}{n} is the name of the nth parameter, and OUT{2}{n} is a
%  human-readable description of the parameter. 
%  OUT{3} is a list of methods for user-guided selection of these parameters.
% 
 
if nargin==0,
	out{1} = {'property_name','min_property','max_property'};
	out{2} = {'property name (can be solidity3, solidity2, area2, volume3, eccentricity2, MaxIntensity3)', 'Minimum value of property to allow', 'Maximum value to allow'};
	out{3} = {'choose_inputdlg'}; %,'choose_graphical'};
	return;
end;

if ischar(parameters),
	switch lower(parameters),
		case 'choose',
			out_choice = mia.roi.editors.propertyfilter;
			choices = cat(2,out_choice{3},'Cancel');
			buttonname = questdlg('By which method should we choose parameters?',...
				'Which method?', choices{:},'Cancel');
			if ~strcmp(buttonname,'Cancel'),
				out = mia.roi.editors.propertyfilter(atd,input_itemname,output_itemname,buttonname);
			else,
				out = [];
			end;
		case 'choose_inputdlg',
			out_p = mia.roi.editors.propertyfilter;
			default_parameters.min_property = -Inf;
			default_parameters.max_property  = Inf;
			parameters = dlg2struct('Choose parameters',out_p{1},out_p{2},default_parameters);
			if isempty(parameters),
				out = [];
			else,
				out = mia.roi.editors.propertyfilter(atd,input_itemname,output_itemname,parameters);
			end;
		case 'choose_graphical',
			% needs to be done
			
			f = figure;
			pos = get(f,'position');
			set(f,'position',[pos([1 2]) 500 500]);
			uidefs = basicuitools_defs;
			uicontrol(uidefs.txt,'position',   [20 400 100 25],'string','Minimum Param:');
			uicontrol(uidefs.edit,'position',  [20 375 100 25],'string','1','tag','MinEdit','userdata',1,'callback',['set(gcbo,''userdata'',1); uiresume;']);
			uicontrol(uidefs.txt,'position',   [20 350 100 25],'string','Maximum Param:');
			uicontrol(uidefs.edit,'position',  [20 325 100 25],'string','Inf','tag','MaxEdit','userdata',1,'callback',['set(gcbo,''userdata'',1); uiresume;']);
			uicontrol(uidefs.button,'position',[20 300 100  25],'string','OK', 'tag','OKButton','callback',['set(gcbo,''userdata'',1); uiresume;']);
			uicontrol(uidefs.button,'position',[20 270 100 25],'string','Cancel','tag','CancelButton','callback',['set(gcbo,''userdata'',1); uiresume;']);

			handles.HistogramAxes = axes('units','pixels','position',[150 150 300 200],'tag','HistogramAxes');

			% plot histogram
			L_in_file = getlabeledroifilename(atd,input_itemname);
			roi_in_file = getroifilename(atd,input_itemname);
			load(roi_in_file,'CC','-mat');

			[roi_parentdir,roi_filename,roi_ext] = fileparts(roi_in_file);

			if ~exist([roi_parentdir filesep roi_filename '_roiparameters.mat'],'file'),
				roiparams = at_roi_properties(roi_in_file);
			else,
				roiparams = load([roi_parentdir filesep roi_filename '_roiparameters.mat']);
				roiparams = roiparams.ROIparameters;
			end;

			% TODO: propertyname
			ROI_values = [];
			for i=1:length(CC.PixelIdxList),
				ROI_values(end+1) = getfield(roiparams,propertyname);
			end;
			[counts,bin_centers,bin_edges,fullcounts]=autohistogram(ROI_values);
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
			xlabel('values');
            
			oldaxes = gca;
			axes(handles.HistogramAxes);
	
			axes(oldaxes);

			success = 0;

			minedit = 1;
			maxedit = 1;

			while ~success,
				if ~(minedit | maxedit),
					%disp('calling uiwait.');
					uiwait;
				end;

				cancel = get(findobj(gcf,'tag','CancelButton'),'userdata');
				ok = get(findobj(gcf,'tag','OKButton'),'userdata');
				minedit = get(findobj(gcf,'tag','MinVolumeEdit'),'userdata');
				maxedit = get(findobj(gcf,'tag','MaxVolumeEdit'),'userdata');

				if cancel,
					success = 1;
					out = [];
				elseif minedit | maxedit | ok,
					try,
						minstring = get(findobj(gcf,'tag','MinVolumeEdit'),'string');
						min = eval([minstring ';']);
						if isempty(min) | ~isnumeric(min),
							error(['Syntax error in minimum volume: empty or not a number.']);
						end;
						maxstring = get(findobj(gcf,'tag','MaxVolumeEdit'),'string');
						max = eval([maxstring ';']);
						if isempty(max) | ~isnumeric(max),
							error(['Syntax error in maximum volume: empty or not a number.']);
						end;
					catch,
						errordlg(['Error in setting minimum or maximum volume constraint: ' lasterr]);
						set(findobj(gcf,'tag','OKButton'),'userdata',0);
						set(findobj(gcf,'tag','MinVolumeEdit'),'userdata',0);
						set(findobj(gcf,'tag','MaxVolumeEdit'),'userdata',0);
					end;

					if minedit | maxedit,
						h = findobj(handles.HistogramAxes,'tag','histline');
						if ishandle(h), delete(h); end;
						oldaxes = gca;
						axes(handles.HistogramAxes);
						hold on;
						a = axis;
						plot([min min],[a(3) a(4)],'g-','tag','histline');
						plot([max max],[a(3) a(4)],'g-','tag','histline');
						set(handles.HistogramAxes,'tag',['IMHistogramAxes']);
						axes(oldaxes);
						set(findobj(gcf,'tag','MinVolumeEdit'),'userdata',0);
						set(findobj(gcf,'tag','MaxVolumeEdit'),'userdata',0);
					elseif ok,
						%disp('here');
						parameters = struct('volume_minimum',min,'volume_maximum',max);
						out = mia.roi.editors.propertyfilter(atd,input_itemname,output_itemname,parameters);
						success = 1;
                                        end;
                                end;
				minedit = 0;
				maxedit = 0;
                        end;
			warning(warning_state); % return warning state
                        close(gcf);

	end;
	return;
end;

 % edit this part

roi_in_file = getroifilename(atd,input_itemname);
load(roi_in_file,'CC','-mat');
roi_properties_file = getroiparametersfilename(atd, input_itemname);
load(roi_properties_file,'-mat');

eval(['ROI_property = [ROIparameters.params' parameters.property_name(end) 'd.' parameters.property_name(1:end-1) '];']);
good_indexes = find( (ROI_property >= parameters.min_property) & (ROI_property <= parameters.max_property) );

h = mia.miadir.gethistory(atd,'ROIs',input_itemname);
h(end+1) = struct('parent',input_itemname,'operation','mia.roi.editors.propertyfilter','parameters',parameters,...
	'description',['Filtered all but ' int2str(numel(good_indexes)) ' ROIs with property ' parameters.property_name ' between ' num2str(parameters.min_property) ' and ' num2str(parameters.max_property) ' of ROIS ' input_itemname '.']);

mia.roi.functions.savesubset(atd,input_itemname, good_indexes, output_itemname, h);

out = 1;

