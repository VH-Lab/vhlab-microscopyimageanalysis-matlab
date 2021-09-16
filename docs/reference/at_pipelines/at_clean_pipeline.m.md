# at_clean_pipeline

```
  AT_CLEAN_PIPELINE - cleans pipeline files
 
  AT_CLEANPIPELINE(ATD, PIPELINEPREFIX)
  
  Deletes the ATD items that start with PIPELINEPREFIX. Use with caution, as
  this deletes many objects. You can test with 'donotdelete' set to 1 to see 
  what will be deleted.
  
  Several parameters can be altered by name/value pairs (see help NAMEVALUEPAIR).
  Parameter (default)       | Description
  --------------------------------------------------------------------
  donotdelete (0)           | 0/1 If 1, then don't actually do the deleting,
                            |    just report what would have been done
 
  Example:
     atd = at_dir([MYEXPERIMENTPATH]);
     at_clean_pipeline(atd, 'PSDsv1');

```
