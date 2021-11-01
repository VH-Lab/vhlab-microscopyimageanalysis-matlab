function out = zspanfilter(atd, input_itemname, output_itemname, parameters)
% ZSPANFILTER - Filter ROIs by Z span
% 
%  OUT = MIA.ROI.EDITORS.ZSPANFILTER(ATD, INPUT_ITEMNAME, OUTPUT_ITEMNAME, PARAMETERS)
%
%  If the function is called with no arguments, then a description of the parameters
%  is returned in OUT. OUT{1}{n} is the name of the nth parameter, and OUT{2}{n} is a
%  human-readable description of the parameter. 
%  OUT{3} is a list of methods for user-guided selection of these parameters.
% 

if nargin==0,
	out{1} = {'z_span_minimum','z_span_maximum'};
	out{2} = {'Minimum span of Z to allow', 'Maximum span of Z to allow'};
	out{3} = {'choose_inputdlg','choose_graphical'};
	return;
end;

if ischar(parameters),
	switch lower(parameters),
		case 'choose',
			out_choice = mia.roi.editors.zspanfilter;
			choices = cat(2,out_choice{3},'Cancel');
			buttonname = questdlg('By which method should we choose parameters?',...
				'Which method?', choices{:},'Cancel');
			if ~strcmp(buttonname,'Cancel'),
				out = mia.roi.editors.zspanfilter(atd,input_itemname,output_itemname,buttonname);
			else,
				out = [];
			end;
		case 'choose_inputdlg',
			out_p = mia.roi.editors.zspanfilter;
			default_parameters.z_span_minimum = 1;
			default_parameters.z_span_maximum = Inf;
			parameters = dlg2struct('Choose parameters',out_p{1},out_p{2},default_parameters);
			if isempty(parameters),
				out = [];
			else,
				out = mia.roi.editors.zspanfilter(atd,input_itemname,output_itemname,parameters);
			end;
		case 'choose_graphical',
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
			L_in_file = getlabeledroifilename(atd,input_itemname);
			roi_in_file = getroifilename(atd,input_itemname);
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

			success = 0;

			minzspanedit = 1;
			maxzspanedit = 1;

			while ~success,
				if ~(minzspanedit | maxzspanedit),
					%disp('calling uiwait.');
					uiwait;
				end;

				cancel = get(findobj(gcf,'tag','CancelButton'),'userdata');
				ok = get(findobj(gcf,'tag','OKButton'),'userdata');
				minzspanedit = get(findobj(gcf,'tag','MinZSpanEdit'),'userdata');
				maxzspanedit = get(findobj(gcf,'tag','MaxZSpanEdit'),'userdata');

				if cancel,
					success = 1;
					out = [];
				elseif minzspanedit | maxzspanedit | ok,
					try,
						minzspanstring = get(findobj(gcf,'tag','MinZSpanEdit'),'string');
						minzspan = eval([minzspanstring ';']);
						if isempty(minzspan) | ~isnumeric(minzspan),
							error(['Syntax error in minimum Z span: empty or not a number.']);
						end;
						maxzspanstring = get(findobj(gcf,'tag','MaxZSpanEdit'),'string');
						maxzspan = eval([maxzspanstring ';']);
						if isempty(maxzspan) | ~isnumeric(maxzspan),
							error(['Syntax error in maximum Z span: empty or not a number.']);
						end;
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
						%disp('here');
						parameters = struct('z_span_minimum',minzspan,'z_span_maximum',maxzspan);
						out = mia.roi.editors.zspanfilter(atd,input_itemname,output_itemname,parameters);
						success = 1;
                                        end;
                                end;
				minzspanedit = 0;
				maxzspanedit = 0;
                        end;
                        close(gcf);

	end;
	return;
end;

 % edit this part

L_in_file = getlabeledroifilename(atd,input_itemname);
roi_in_file = getroifilename(atd,input_itemname);
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

L_out_file = [getpathname(atd) filesep 'ROIs' filesep output_itemname filesep output_itemname '_L' '.mat'];
roi_out_file = [getpathname(atd) filesep 'ROIs' filesep output_itemname filesep output_itemname '_ROI' '.mat'];

try, mkdir([getpathname(atd) filesep 'ROIs' filesep output_itemname]); end;
save(roi_out_file,'CC','-mat');
save(L_out_file,'L','-mat');

h = mia.miadir.gethistory(atd,'ROIs',input_itemname),
h(end+1) = struct('parent',input_itemname,'operation','mia.roi.editors.zspanfilter','parameters',parameters,...
	'description',['Filtered all but ' int2str(CC.NumObjects) ' ROIs with z spans between ' num2str(parameters.z_span_minimum) ' and ' num2str(parameters.z_span_maximum) ' of ROIS ' input_itemname '.']);
sethistory(atd,'ROIs',output_itemname,h);

str2text([getpathname(atd) filesep 'ROIs' filesep output_itemname filesep 'parent.txt'], input_itemname);


out = 1;

