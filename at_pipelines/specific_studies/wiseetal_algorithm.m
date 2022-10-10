function [a,number_coloc,volume_roi1,volume_roi2] = wiseetal_algorithm(fullpath, roi1, roi2, exper_type)

a = [];

number_coloc= [];

volume_roi1 = [];

volume_roi2 = [];

atd = atdir(fullpath);

rois_here = getitems(atd,'ROIs');

 % first, determine if we need a spacer
spacer = 0;
for i=1:numel(rois_here),
	b1 = ~isempty(strfind(rois_here(i).name,[roi1 'DECsv']));
	b2 = ~isempty(strfind(rois_here(i).name,[roi1 '_DECsv']));

	if b1 | b2,
		if b1,
			spacer = '';
		elseif b2,
			spacer = '_';
		end;
		break;
	end;
end;

 % do we have algorithms 0 or 101..111 ?

for i=[0 101:111],
	spacer_here = spacer;
	if i==0, 
		postfix = '_auto_vf';
		if any(strcmp(exper_type,{'irrev_inh','structure'})),
			spacer_here = '';
		end;
		roi1name = [roi1 spacer_here 'DEC' postfix];
		roi2name = [roi2 spacer_here 'DEC' postfix];
	else,
		postfix = ['sv' int2str(i-100) '_roiresbfvf'];
		roi1name = [roi1 spacer 'DEC' postfix];
		roi2name = [roi2 spacer 'DEC' postfix];
	end;
	I1 = find(strcmp(roi1name,{rois_here.name}));
	I2 = find(strcmp(roi2name,{rois_here.name}));

	if ~isempty(I1) & ~isempty(I2),
		a(end+1) = i;

		if i==0,
			% necessary for inhib_exc
			roi1name = [roi1 spacer_here 'DEC'];
			roi2name = [roi2 spacer_here 'DEC'];
		end;
        try,
		[number_coloc(end+1),volume_roi1(end+1),volume_roi2(end+1)] = ...
			wiseetal_algocalcs(atd,i,roi1name,roi2name);
        catch, keyboard;
        end;
	end;
end;


