# gethistory

```
  GETHISTORY - Get the history of an item from ATDIR directory
   
   H = GETHISTORY(ATD, ITEMTYPE, ITEMNAME)
 
   Returns the history structure of item ITEMNAME that is
   of type ITEMTYPE in the directory managed by the ATDIR 
   object ATD.
  
   If there is no history, H is an empty structure.
 
   ITEMNAME and ITEMTYPE must be valid directory names.
 
   The history structure has the following fields, and is in
   chronological order of the operations performed on the ITEMTYPE:
 
   Fieldnames:    | Description: 
   ---------------------------------------------------------
   parent         | If the item has a parent, the item name corresponding
                  |   to the parent is listed here. Otherwise it is an empty
                  |   string ('').
   operation      | The text of the function call is described here
   parameters     | The parameters that were used
   description    | A human-readable description of the operation

```
