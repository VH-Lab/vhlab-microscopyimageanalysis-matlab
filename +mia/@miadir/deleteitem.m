function deleteitem(md,itemtype,itemname)
% DELETEITEM - Delete an item of a particular type from an MIADIR
%
%  DELETEITEM(MD, ITEMTYPE, ITEMNAME)
%
%  Deletes the item ITEMNAME of type ITEMTYPE from the directory
%  managed by the MIADIR object MD.
%
%  There is no turning back, the item is gone forever.

dirname = [getpathname(md) filesep itemtype filesep itemname];

rmdir(dirname,'s');
