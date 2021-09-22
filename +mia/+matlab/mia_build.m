function mia_build


dirname = ['/Users/vanhoosr/Documents/matlab/tools/vhlab-ArrayTomography-matlab'];

m=vlt.matlab.mfiledirinfo(dirname);

rt = vlt.matlab.packagenamereplacementtable(m,dirname,'mia');

search_replace = { ...
%	'.datastructures.' '.data.' ...
;

for i=1:numel(rt),
	for j=1:2:numel(search_replace),
		rt(i).replacement = strrep(rt(i).replacement,search_replace{j},search_replace{j+1});
	end;
end;

fuse = vlt.matlab.findfunctionusedir([dirname filesep '+mia'],m);

status = vlt.matlab.replacefunction(fuse,rt);

