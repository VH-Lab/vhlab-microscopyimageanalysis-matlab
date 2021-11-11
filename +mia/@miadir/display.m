function display(md)
% DISPLAY print info from an MIADIR object
%
%   DISPLAY(MD)
%
%   Displays information about the MIADIR object MD
%
%   See also: MIADIR

if isempty(inputname(1)),
	disp([inputname(1) '; manages directory ' md.pathname ]);
else,
	disp([inputname(1) '; manages directory ' md.pathname ]);
end;

