function out = xysizefilter(atd, input_itemname, output_itemname, parameters)
% XYSIZEFILTER - Filter ROIs by size
% 
%  OUT = MIA.ROI.EDITORS.XYSIZEFILTER(ATD, INPUT_ITEMNAME, OUTPUT_ITEMNAME, PARAMETERS)
%
%  If the function is called with no arguments, then a description of the parameters
%  is returned in OUT. OUT{1}{n} is the name of the nth parameter, and OUT{2}{n} is a
%  human-readable description of the parameter. 
%  OUT{3} is a list of methods for user-guided selection of these parameters.
% 
 
if nargin==0,
	out{1} = {'size_minimum','size_maximum'};
	out{2} = {'Minimum max XY size of ROI to allow', 'Maximum value of max XY size to allow'};
	out{3} = {'choose_inputdlg','choose_graphical'};
	return;
end;

if ischar(parameters),
	switch lower(parameters),
		case 'choose',
			out_choice = mia.roi.editors.xysizefilter;
			choices = cat(2,out_choice{3},'Cancel');
			buttonname = questdlg('By which method should we choose parameters?',...
				'Which method?', choices{:},'Cancel');
			if ~strcmp(buttonname,'Cancel'),
				out = mia.roi.editors.xysizefilter(atd,input_itemname,output_itemname,buttonname);
			else,
				out = [];
			end;
		case 'choose_inputdlg',
			out_p = mia.roi.editors.xysizefilter;
			default_parameters.size_minimum = 1;
			default_parameters.size_maximum = Inf;
			parameters = dlg2struct('Choose parameters',out_p{1},out_p{2},default_parameters);
			if isempty(parameters),
				out = [];
			else,
				out = mia.roi.editors.xysizefilter(atd,input_itemname,output_itemname,parameters);
			end;
		case 'choose_graphical',
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
			L_in_file = getlabeledroifilename(atd,input_itemname);
			roi_in_file = getroifilename(atd,input_itemname);
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

			success = 0;

			minvoledit = 1;
			maxvoledit = 1;

			while ~success,
				if ~(minvoledit | maxvoledit),
					%disp('calling uiwait.');
					uiwait;
				end;

				cancel = get(findobj(gcf,'tag','CancelButton'),'userdata');
				ok = get(findobj(gcf,'tag','OKButton'),'userdata');
				minvoledit = get(findobj(gcf,'tag','MinMaxXYSizeEdit'),'userdata');
				maxvoledit = get(findobj(gcf,'tag','MaxMaxXYSizeEdit'),'userdata');

				if cancel,
					success = 1;
					out = [];
				elseif minvoledit | maxvoledit | ok,
					try,
						minvolstring = get(findobj(gcf,'tag','MinMaxXYSizeEdit'),'string');
						minvol = eval([minvolstring ';']);
						if isempty(minvol) | ~isnumeric(minvol),
							error(['Syntax error in minimum size: empty or not a number.']);
						end;
						maxvolstring = get(findobj(gcf,'tag','MaxMaxXYSizeEdit'),'string');
						maxvol = eval([maxvolstring ';']);
						if isempty(maxvol) | ~isnumeric(maxvol),
							error(['Syntax error in maximum size: empty or not a number.']);
						end;
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
						%disp('here');
						parameters = struct('size_minimum',minvol,'size_maximum',maxvol);
						out = mia.roi.editors.xysizefilter(atd,input_itemname,output_itemname,parameters);
						success = 1;
                                        end;
                                end;
				minvoledit = 0;
				maxvoledit = 0;
                        end;
			warning(warning_state); % return warning state
                        close(gcf);

	end;
	return;
end;

 % edit this part

L_in_file = getlabeledroifilename(atd,input_itemname);
roi_in_file = getroifilename(atd,input_itemname);
load(roi_in_file,'CC','-mat');

ROI_sizes = ROI_3d_max_xy_size(CC,'UseProgressBar',1);

good_indexes = find( (ROI_sizes >= parameters.size_minimum) & (ROI_sizes <= parameters.size_maximum) );

CC.NumObjects = length(good_indexes);
CC.PixelIdxList = CC.PixelIdxList(good_indexes);
L = labelmatrix(CC);

L_out_file = [getpathname(atd) filesep 'ROIs' filesep output_itemname filesep output_itemname '_L' '.mat'];
roi_out_file = [getpathname(atd) filesep 'ROIs' filesep output_itemname filesep output_itemname '_ROI' '.mat'];

try, mkdir([getpathname(atd) filesep 'ROIs' filesep output_itemname]); end;
save(roi_out_file,'CC','-mat');
save(L_out_file,'L','-mat');

h = mia.miadir.gethistory(atd,'ROIs',input_itemname),
h(end+1) = struct('parent',input_itemname,'operation','mia.roi.editors.xysizefilter','parameters',parameters,...
	'description',['Filtered all but ' int2str(CC.NumObjects) ' ROIs with Max XY size between ' num2str(parameters.size_minimum) ' and ' num2str(parameters.size_maximum) ' of ROIS ' input_itemname '.']);
sethistory(atd,'ROIs',output_itemname,h);

str2text([getpathname(atd) filesep 'ROIs' filesep output_itemname filesep 'parent.txt'], input_itemname);

out = 1;

