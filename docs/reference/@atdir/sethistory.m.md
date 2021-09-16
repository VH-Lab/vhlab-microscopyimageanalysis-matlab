# sethistory

```
  SETHISTORY - Set the history of an item from ATDIR directory
   
   SETHISTORY(ATD, ITEMTYPE, ITEMNAME, H)
 
   Sets the history structure of item ITEMNAME that is
   of type ITEMTYPE in the directory managed by the ATDIR 
   object ATD.
  
   ITEMNAME and ITEMTYPE must be valid directory names.
 
   The history structure should have the following fields, and is in
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
