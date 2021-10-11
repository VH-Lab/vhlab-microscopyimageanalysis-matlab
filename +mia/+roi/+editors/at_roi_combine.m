function out = at_roi_combine(atd, input_itemname, output_itemname, parameters)
% AT_ROI_COMBINE - Filter ROIs by volume
% 
%  OUT = MIA.ROI.EDITORS.AT_ROI_COMBINE(ATD, INPUT_ITEMNAME, OUTPUT_ITEMNAME, PARAMETERS)
%
%  If the function is called with no arguments, then a description of the parameters
%  is returned in OUT. OUT{1}{n} is the name of the nth parameter, and OUT{2}{n} is a
%  human-readable description of the parameter. 
%  OUT{3} is a list of methods for user-guided selection of these parameters.
%
%  The PARAMETERS for this function can just be empty, there are no parameters. All ROIs are
%  combined into a single ROI.
% 

if nargin==0,
	out{1} = {};
	out{2} = {};
	out{3} = {'The Default'};
	return;
end;

if ischar(parameters),
	switch lower(parameters),
		case 'choose',
			out_choice = mia.roi.editors.at_roi_combine;
			choices = cat(2,out_choice{3},'Cancel');
			buttonname = questdlg('By which method should we choose parameters?',...
				'Which method?', choices{:},'Cancel');
			if ~strcmp(buttonname,'Cancel'),
				out = mia.roi.editors.at_roi_combine(atd,input_itemname,output_itemname,buttonname);
			else,
				out = [];
			end;
		case 'the default',
			parameters = [];
			out = mia.roi.editors.at_roi_combine(atd,input_itemname,output_itemname,parameters);

	end;
	return;
end;

 % edit this part

L_in_file = getlabeledroifilename(atd,input_itemname);
roi_in_file = getroifilename(atd,input_itemname);
load(roi_in_file,'CC','-mat');

oldobjects = CC.NumObjects;

CC.PixelIdxList = {cat(1,CC.PixelIdxList{:})};
CC.NumObjects = 1;

L = labelmatrix(CC);

L_out_file = [getpathname(atd) filesep 'ROIs' filesep output_itemname filesep output_itemname '_L' '.mat'];
roi_out_file = [getpathname(atd) filesep 'ROIs' filesep output_itemname filesep output_itemname '_ROI' '.mat'];

try, mkdir([getpathname(atd) filesep 'ROIs' filesep output_itemname]); end;
save(roi_out_file,'CC','-mat');
save(L_out_file,'L','-mat');

h = gethistory(atd,'ROIs',input_itemname),
h(end+1) = struct('parent',input_itemname,'operation','mia.roi.editors.at_roi_combine','parameters',parameters,...
	'description',['Combined ' int2str(oldobjects) ' ROIs into 1 from ' input_itemname '.']);
sethistory(atd,'ROIs',output_itemname,h);

str2text([getpathname(atd) filesep 'ROIs' filesep output_itemname filesep 'parent.txt'], input_itemname);


out = 1;

