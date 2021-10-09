function at_foreachdirdo(dirlist, script2call)
% AT_FOREACHDIRDO - for each at_directory in a list, call a script.
%
% mia.utilities.at_foreachdirdo(DIRLIST, SCRIPT2CALL)
%
% This function will loop over DIRLIST, a cell array of directory paths
% to AT experiments. It will create a new object of type ATDIR called
% `atd` (lowercase). Then, it will call SCRIPT2CALL.
%
% Example:
%   d = mia.utilities.at_findalldirs('/Volumes/van-hooser-lab/Users/Derek/');
%   mia.utilities.at_foreachdirdo(d, 'atd,') % simply prints the path
%   

for i=1:numel(dirlist),
	atd = atdir(dirlist{i});
	disp(['>>> Working on directory ' int2str(i) ' of ' int2str(numel(dirlist)) '...']);
	if ~isempty(script2call),
		eval(script2call);
	end;
	disp(['>>> Finished directory ' int2str(i) ' of ' int2str(numel(dirlist)) '...']);
end;


 
