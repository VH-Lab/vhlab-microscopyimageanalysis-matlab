function [drug, time, animal] = wiseexpstr2info(str)
% WISEEXPSTR2INFO - extract information from wise et al experiment string
%
% [DRUG, TIME, ANIMAL] = WISEEXPSTR2INFO(STR)
%
%

i = strfind(upper(str),'CTRL');
if isempty(i),
	j = strfind(upper(str),'DTTX');
	time = uint8(str2num(str(1:j-1)));
	drug = 'TTX';
	animal = sscanf(str,[int2str(time) 'DTTX_%d']);
else,
	time = 0;
	animal = sscanf(str,'CTRL_%d');
	drug = upper('control');
end;


