function display(atd)
% DISPLAY print info from an ATDIR object
%
%   DISPLAY(ATD)
%
%   Displays information about the ATDIR object ATD
%
%   See also: ATDIR

if isempty(inputname(1)),
	disp([inputname(1) '; manages directory ' getpathname(atd) ]);
else,
	disp([inputname(1) '; manages directory ' getpathname(atd) ]);
end;

