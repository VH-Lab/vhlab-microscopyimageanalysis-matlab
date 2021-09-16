# at_estimatethresholds

```
  AT_ESTIMATETHRESHOLDS - estimate thresholds for object detection
 
  [T,OUT] = AT_ESTIMATETHRESHOLDS(IM, ...)
 
  Estimate the thresholds for detecting objects in the array tomography
  (or sparse confocal image) IM.
 
  First, the signal is assumed to be present primarily in the top 
  75th percentile of the data. The noise is modeled as a skewed gauss-like
  process after removing the top 75th percentile of the data.
  (See vlt.fit.skewgauss)
 
 
  Outputs:
    t - Recommended thresholds to be 80% and 30% sure one is reading signal compared to noise
    out - A structure with fields:
       bin_centers - bin centers for automatic histogram used to examine data
       bin_edges - the edges used in the automatic histogram
       counts - count of data in each
       p_noise - parameters of the noise model for vlt.fit.skewgaussian
       noise_fit - fit of the noise distribution (bin_centers as x values)
       signal_y - [30 80 95 99 99.9 99.99]
       signal_x - conservative estimates of the values of IM that stand out
                    beyond the noise signal at the 30th, 80th, 95th 99th, 99.9th, 99.99th percentile
       detection_quality - [0:95], detection quality reference
       threshold_signal_to_noise - same size as detection_quality; the ith value indicates
                                   the value of IM that stands out beyond noise at the ith
                                   percentile; estimated linearly based on conservative estimates
                                   for the range 30-80
       detection_quality_better - [ 30:99 99.01:99.99 99.991:0.001:99.999 ]
       threshold_signal_to_noise_better - same size as detection_quality;_better the ith value indicates
                                   the value of IM that stands out beyond noise at the ith
                                   percentile; estimated based on conservative estimates
                                   for the range 30-99.9999

```
