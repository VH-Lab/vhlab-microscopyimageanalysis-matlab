function [b,d] = findalldirs(pathname)
% mia.test.utilities.findalldirs - 
%
% [B,D] = mia.test.utilities.findalldirs(PATHNAME)
%
% Given a PATHNAME, tries to find all directories that have 
% MIA data structures using mia.utilities.findalldirs().
%
% Returns B == 1 if it runs successfully, otherwise B == 0.
% D is the list of pathnames.
% 

b = 0;
try,
	d = mia.utilities.findalldirs(pathname);
	b = 1;
end;




