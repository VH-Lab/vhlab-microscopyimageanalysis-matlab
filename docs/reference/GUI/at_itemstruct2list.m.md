# at_itemstruct2list

```
  AT_ITEMSTRUCT2LIST - Convert an itemstruct to a set of strings that can be listed
 
    [LISTSTR, INFOSTR] = AT_ITEMSTRUCT2LIST(ITEMSTRUCT,...)
 
    Takes an ITEMSTRUCT (see ATDIR/GETITEMS) and produces a 
    cell array of strings LISTSTR that indicates the parental relationships among
    the data. Children are listed below their "parents" and are indented.
    Note that the order of LISTSTR need not match the list of items in ITEMSTRUCT.
  
    INFOSTR is a human readable information string for each item, based on the
    'history' field. INFOSTR{i} is a cell list of strings for the ITEMSTRUCT.
    The order of INFOSTR{:} WILL match the list of ITEMSTRUCTs.
 
    This function can take extra name/value pairs that modify its functionality:
    Parameter (default):        | Description:
    -------------------------------------------------------------------
    indent ('  ')               | The indentation of a child relative to its parent.

```
