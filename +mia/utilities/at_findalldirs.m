function d = at_findalldirs(startpath, varargin)
% AT_FINDALLDIRS - find all array tomography directories from a starting path
%
% D = AT_FINDALLDIRS(STARTPATH, ...)
%
% Returns in D a cell array of full paths to AT directories; that is,
% those that have a subdirectory called 'images' that contains at least 1
% subdirectory.
%
% Once we find a directory that has 'images' inside it, we don't look farther
% inside those directories.
%

d = {};

dirlist = vlt.file.dirlist_trimdots(dir(startpath));

startpath_is_a_match = 0;

 % answer this question: do we have a subdirectory named 'images' ?
index = find(strcmpi('images',dirlist));

if ~isempty(index),
	% answer this question: does it also have at least one folder in it?
	d_sub = vlt.file.dirlist_trimdots(dir([startpath filesep 'images']));
	if ~isempty(d_sub),
		startpath_is_a_match = 1;
		% because we will search no farther, we can safetly return startpath and exit
		d{1} = startpath;
		return;
	end;
end;

 % we haven't found a match yet, so let's search all of our subdirectories

for i=1:numel(dirlist),
	d_ = at_findalldirs([startpath filesep dirlist{i}]);
	d = cat(1,d,d_);
end;


