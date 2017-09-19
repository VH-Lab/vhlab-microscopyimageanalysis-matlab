# vhlab_mlapp_ArrayTomography
Matlab app for analysis of high density imaging data like that from Array Tomography

This can be used with directories that have the following subfolders:

    images/
        named_images/
            (either single image or individual images of channels)
    rois/
        named_rois/
            rois.mat - ROI data structure
            L.mat - Labeled image
            history.mat - list of actions that led to these rois
            labels - labels of these rois
    colocalization/

One needs to initially set up a subfolder called images/named_images

For example, if one has two TIF stacks named 'PSD-channel.tif' and 'YFP-channel.tif',
one would create the following directories:


myexperiment/
	images/
		PSD_raw/
			PSD-channel.tif
		YFP_raw/
			YFP-channel.tif
	





