# at_findalldirs

```
  AT_FINDALLDIRS - find all array tomography directories from a starting path
 
  D = AT_FINDALLDIRS(STARTPATH, ...)
 
  Returns in D a cell array of full paths to AT directories; that is,
  those that have a subdirectory called 'images' that contains at least 1
  subdirectory.
 
  Once we find a directory that has 'images' inside it, we don't look farther
  inside those directories.

```
