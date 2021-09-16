# getitems

```
  GETITEMS - Get items of a particular type in an ATDIR experiment directory
   
    ITEMSTRUCT = GETITEMS(ATD, ITEMTYPE)
 
   Returns an item struct array with all items of ITEMTYPE
   in the ATDIR director ATD.
 
   Examples of ITEMTYPE could be 'images', 'ROIs', etc...
 
   The item struct is the following:
   Fieldname:   |   Description
   -------------------------------------------------------
   name         |   The item name
   parent       |   The item's parent's name, if any
   history      |   A structure with the item's history

```
