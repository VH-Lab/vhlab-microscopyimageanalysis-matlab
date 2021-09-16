# at_colocalization_summary

```
  AT_COLOCALIZATION_SUMMARY - provide a summary of co-localizations
 
 
  [OUT, MSG] = AT_COLOCALIZATION_SUMMARY(THE_ATDIR, COLOCALIZATION)
 
  Returns a summary structure and string message describing the results
  of the triple colocalization analysis named COLOCALIZATION for the array tomography
  record THE_ATDIR.
 
  Example:
      the_atdir = atdir('/Users/vanhoosr/Downloads/2015-06-03');
      colname = 'SPINE_PSD_VGLUT_anyoverlap_2shift'; % example roi name
      [out,msg] = at_colocalization_summary(the_atdir, colname);
 
  See also: ATDIR

```
