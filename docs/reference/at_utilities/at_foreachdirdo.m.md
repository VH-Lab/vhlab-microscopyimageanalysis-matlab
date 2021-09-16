# at_foreachdirdo

```
  AT_FOREACHDIRDO - for each at_directory in a list, call a script.
 
  AT_FOREACHDIRDO(DIRLIST, SCRIPT2CALL)
 
  This function will loop over DIRLIST, a cell array of directory paths
  to AT experiments. It will create a new object of type ATDIR called
  `atd` (lowercase). Then, it will call SCRIPT2CALL.
 
  Example:
    d = at_findalldirs('/Volumes/van-hooser-lab/Users/Derek/');
    at_foreachdirdo(d, 'atd,') % simply prints the path

```
