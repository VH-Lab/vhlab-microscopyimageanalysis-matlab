# at_itemeditlist_gui

```
  AT_ITEMLIST_GUI - Manage the view of a multi-frame image in a Matlab GUI
 
    AT_ITEMLIST_GUI
 
    Creates and manages a panel appropriate for examining a list of items
    in a Matlab GUI. 
 
    To create a item edit list panel, call AT_ITEMLIST_GUI(NAME,'command','init') where 
    NAME is a unique name on your figure (you can have more than one viewer per figure
    if you use different names).  You can pass additional name/value pairs that govern the
    behavior of the GUI.
 
    Commands and parameters are not case sensitive. Name IS case sensitive.
 
    Parameter (default value)    | Description
    --------------------------------------------------------------------------- 
    fig (gcf)                    | Figure number where the viewer is located
    Units ('pixels')             | The units we will use
    LowerLeftPoint ([0 0])       | The lower left point to use in drawing, in units of "units"
    UpperRightPoint ([400 300])  | The upper right point to use in drawing, in units of "units"
    itemtype ('images')          | The name of type of items to be managed (known to atdir)
    itemtype_singular ('image')  | The English name of type of items to be managed (singular)
    itemtype_plural ('images')   | The plural of the type
    itemstruct ([])              | If calling command='update_itemlist', an itemstruct should be
                                 |    passed.
    viewselectiononly (0)        | 0/1 Should we view the current selection only, ignoring the
                                 |    settings in 'visible'?
    usevisible (1)               | 0/1 Should we give the user the option to set the visibility
                                 |    and color of each item?
    visiblecbstring ('Visible')  | String. The name we should use for the 'Visible' checkbox.
    useedit (1)                  | 0/1 Should we keep the edit menu available?
    drawaction([])               | Name of a function for the draw action. It provides a structure
                                 |   as a name/value pair with name 'theinput', and value a structure with fields:
                                 |     itemname  - a string with the name of the item
                                 |     itemstruct_parameters - the viewing parameters (visible,etc)
   drawaction_userinputs ({})    | A list of user-provided inputs to the drawaction function.
                                 |   The function is called as DRAWACTION(DRAWACTION_USERINPUTS{:},'theinput',thestructabove)
   new_functions ({})            | Functions that can be called from the "New [item]" pull down menu
   new_items ('')                | The AT_ITEMLIST_GUI name to use for the item list for new functions. If empty,
                                 |   then the current AT_ITEMLIST_GUI is used.
   edit_functions ({})           | Functions that can be called from the "Edit [item]" pull down menu
   edit_items ('')               | The AT_ITEMLIST_GUI name to be used for the item list for edit functions. If empty,
                                 |   then the current AT_ITEMLIST_GUI is used.
   atd ([])                      | ATDIR that manages the data directory
   extracbstring (' ')           | String for the optional extra checkbox ui control
   useextracb (0)                | 0/1 Should we use the extra checkbox ui control?
   extracbcallsdrawaction (1)    | 0/1 Should the extra checkbox ui control call drawaction?
    
    
    One can also query the internal variables by calling
 
    AT_ITEMLIST_GUI(NAME, 'command', 'Get_Vars')
   
    Or obtain the uicontrol and axes handles by using:
 
    AT_ITEMLIST_GUI(NAME, 'command', 'Get_Handles')

```
