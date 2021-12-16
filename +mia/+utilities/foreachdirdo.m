function foreachdirdo(dirlist, script2call)
% FOREACHDIRDO - for each at_directory in a list, call a script.
%
% mia.utilities.foreachdirdo(DIRLIST, SCRIPT2CALL)
%
% This function will loop over DIRLIST, a cell array of directory paths
% to MIA experiments. It will create a new object of type MIA.MIADIR called
% `mdir` (lowercase). Then, it will call SCRIPT2CALL.
%
% Example:
%   d = mia.utilities.findalldirs('/Volumes/van-hooser-lab/Users/Derek/');
%   mia.utilities.foreachdirdo(d, 'mdir,') % simply prints the path
%   

for i=1:numel(dirlist),
	mdir = mia.miadir(dirlist{i});
	disp(['>>> Working on directory ' int2str(i) ' of ' int2str(numel(dirlist)) '...']);
	if ~isempty(script2call),
		eval(script2call);
	end;
	disp(['>>> Finished directory ' int2str(i) ' of ' int2str(numel(dirlist)) '...']);
end;


 
