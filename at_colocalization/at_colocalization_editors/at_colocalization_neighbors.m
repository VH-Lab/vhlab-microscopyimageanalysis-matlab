function out = at_colocalization_neighbors(atd, input_itemname, output_itemname, parameters)
% AT_COLOCALIZATION_NEIGHBORS - Eliminate colocalizations that don't have at least N neighbors
% 
%  OUT = AT_COLOCALIZATION_NEIGHBORS(ATD, INPUT_ITEMNAME, OUTPUT_ITEMNAME, PARAMETERS)
%
%  If the function is called with no arguments, then a description of the parameters
%  is returned in OUT. OUT{1}{n} is the name of the nth parameter, and OUT{2}{n} is a
%  human-readable description of the parameter. 
%  OUT{3} is a list of methods for user-guided selection of these parameters.
%          

if nargin==0,
	out{1} = {'number_neighbors'};
	out{2} = {'Number of neighbors a colocalization must have to remain'}
	out{3} = {'choose_inputdlg'};
	return;
end;

if ischar(parameters),
	switch lower(parameters),
		case 'choose',
			out_choice = at_colocalization_neighbors;
			choices = cat(2,out_choice{3},'Cancel');
			buttonname = questdlg('By which method should we choose parameters?',...
				'Which method?', choices{:},'Cancel');
			if ~strcmp(buttonname,'Cancel'),
				out = at_colocalization_neighbors(atd,input_itemname,output_itemname,buttonname);
			else,
				out = [];
			end;
		case 'choose_inputdlg',
			out_p = at_colocalization_neighbors;
			default_parameters.number_neighbors= 2;
			parameters = dlg2struct('Choose parameters',out_p{1},out_p{2},default_parameters);
			if isempty(parameters),
				out = [];
			else,
				out = at_colocalization_neighbors(atd,input_itemname,output_itemname,parameters);
			end;

	end;
	return;
end;

 % edit this part

cfile = getcolocalizationfilename(atd,input_itemname);

load(cfile,'colocalization_data','-mat');

parent = getparent(atd, 'CLAs', input_itemname);
allrois = getitems(atd, 'ROIs');



if ~isfield(colocalization_data.parameters,'roi_set_1') & ~isempty(intersect(parent,{allrois.name})),
	colocalization_data.parameters.roi_set_1 = parent;
end;

[I,J] = find(colocalization_data.overlap_thresh>0);
multi_count = [];

all_cla = [I,J];
no_neighbors = [];
multi_neighbors = [];
unique_I = unique(I);
for z = 1:length(unique_I)
    neighbors_here = numel(find(I == unique_I(z)));
    
    if neighbors_here >= parameters.number_neighbors
        multi_count = [multi_count neighbors_here]; 
    else
        colocalization_data.overlap_thresh(unique_I(z),:) = 0;
    end
end
figure
histogram(multi_count)


overlapped_objects = numel(multi_count);

colocalization_out_file = [getpathname(atd) filesep 'CLAs' filesep output_itemname filesep output_itemname '_CLA' '.mat'];

try, mkdir([getpathname(atd) filesep 'CLAs' filesep output_itemname]); end;
save(colocalization_out_file,'colocalization_data','-mat');

h = gethistory(atd,'CLAs',input_itemname),
h(end+1) = struct('parent',input_itemname,'operation','at_colocalization_neighbors','parameters',parameters,...
	'description',['Found number of neighbors at least ' num2str(parameters.number_neighbors) '. Found ' int2str(overlapped_objects) ' CLs.' ]);
sethistory(atd,'CLAs',output_itemname,h);

str2text([getpathname(atd) filesep 'CLAs' filesep output_itemname filesep 'parent.txt'], input_itemname);

out = 1;
