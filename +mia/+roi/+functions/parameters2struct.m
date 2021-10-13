function outstruct = parameters2struct(roiparams)
% PARAMETERS2STRUCT - return a structure with 1-D fields
%
% OUTSTRUCT = MIA.ROI.FUNCTIONS.PARAMETERS2STRUCT(ROIPARAMS)
%
%  

fn2d = fieldnames(roiparams.params2d);
fn3d = fieldnames(roiparams.params3d);

matches2d = [];
fn_out2d = {};
matches3d = [];
fn_out3d = {};

outstruct = [];

for j=1:numel(fn2d),
	if max(size(getfield(roiparams.params2d(1),fn2d{j})))==1,
		matches2d(end+1) = j;
		fn_out2d{end+1} = [fn2d{j} '_2d'];
	end;
end;
	
for j=1:numel(fn3d),
	if max(size(getfield(roiparams.params3d(1),fn3d{j})))==1,
		matches3d(end+1) = j;
		fn_out3d{end+1} = [fn3d{j} '_3d'];
	end;
end;

fn_outall = {fn_out2d{:} fn_out3d{:} };

outstruct = emptystruct(fn_outall);

for i=1:numel(roiparams.params2d),
	outhere = [];
	for j=1:numel(matches2d),
		v = getfield(roiparams.params2d(i),fn2d{matches2d(j)});
		eval(['outhere.' fn_out2d{j} ' = v;']);
	end;
	for j=1:numel(matches3d),
		v = getfield(roiparams.params3d(i),fn3d{matches3d(j)});
		eval(['outhere.' fn_out3d{j} ' = v;']);
	end;
	outstruct(end+1) = outhere;
end;
