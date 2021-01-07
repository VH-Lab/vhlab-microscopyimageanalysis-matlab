function [parameters] = at_clean_pipeline(atd, pipelineprefix, varargin)
% AT_CLEAN_PIPELINE - cleans pipeline files
%
% AT_CLEANPIPELINE(ATD, PIPELINEPREFIX)
% 
% Deletes the ATD items that start with PIPELINEPREFIX. Use with caution, as
% this deletes many objects. You can test with 'donotdelete' set to 1 to see 
% what will be deleted.
% 
% Several parameters can be altered by name/value pairs (see help NAMEVALUEPAIR).
% Parameter (default)       | Description
% --------------------------------------------------------------------
% donotdelete (0)           | 0/1 If 1, then don't actually do the deleting,
%                           |    just report what would have been done
%
% Example:
%    atd = at_dir([MYEXPERIMENTPATH]);
%    at_clean_pipeline(atd, 'PSDsv1');
%

donotdelete = 0;

vlt.data.assign(varargin{:});

objTypes = {'images','ROIs','CLAs'};

for i=1:numel(objTypes),
	deleteList = [];
	items = getitems(atd,objTypes{i});

	for j=1:numel(items),
		if startsWith(items(j).name,pipelineprefix),
			deleteList(end+1) = j;
		end;
	end;

	for j=1:numel(deleteList),
		if donotdelete,
			disp(['Would have deleted ' objTypes{i} ' named ' items(deleteList(j)).name '.']);
		else,
			deleteitem(atd,objTypes{i},items(deleteList(j)).name);
		end;
	end;
end;


