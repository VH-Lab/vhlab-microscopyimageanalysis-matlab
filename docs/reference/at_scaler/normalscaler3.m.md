# normalscaler3

```
  AIRYSCALER3(FNAME) scales an image stack produced by AiryScan processing.
  AIRYSCALER finds an estimate of the signal from a frame of an image, then
  fits the change of this value over frames to an exponential decay fxn.
  The noise distribution of the image is centered around 0, and then each
  value is multiplied by the inverse of the exponential decay, causing the
  signal of each frame to better resemble the first frame.
  fname should be the name of a single-channel .tif image (the full name, incuding the
  file path) generated from the Airyscan microscope.
  adj_scale is an option to hone your scaling if you feel the application
  did a poor job. It will add an additional scaling factor to that derived
  from the exponential decay over depth.

```
