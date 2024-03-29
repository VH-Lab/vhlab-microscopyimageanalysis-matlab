function deleteitem(atd,itemtype,itemname)
% DELETEITEM - Delete an item of a particular type from an ATDIR
%
%  DELETEITEM(ATD, ITEMTYPE, ITEMNAME)
%
%  Deletes the item ITEMNAME of type ITEMTYPE from the directory
%  managed by the ATDIR object ATD.
%
%  There is no turning back, the item is gone forever.

dirname = [getpathname(atd) filesep itemtype filesep itemname];

rmdir(dirname,'s');
