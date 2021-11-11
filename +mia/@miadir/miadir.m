classdef miadir
% MIADIR - data directory management for Array Tomography data.
%
%  MD = MIA.MIADIR(PATHNAME)
%
%  Creates a data directory management object MD with full pathname
%  PATHNAME.
% 
%  The directory format is as follows. There is a directory
%  named PATHNAME that contains all the data. PATHNAME has subdirectories,
%  named 'images','rois', and 'colocalization', or other names, that contain
%  information relevant to the analysis of the data.
%
%  Graphically, the file organization looks like the following:
%  experiment/
%    images/
%        named_images/
%            (either single image or individual images of channels)
%    rois/
%        named_rois/
%            rois.mat - ROI data structure
%            L.mat - Labeled image
%            history.mat - list of actions that led to these rois
%            labels - labels of these rois
%    colocalization/
%
%
% See also: METHODS('MIA.MIADIR')
%
    properties 
        pathname
        S
    end

    methods
        function md = miadir(pathname);
                if nargin == 0,
                    md.pathname = '';
                else,
                    md.pathname = fixpath(pathname);
                    if exist(pathname)~=7, error([pathname ' does not exist.']); end;
                end;
                
                md.S = struct('pathname',pathname);
        end
    end
    methods
        function p = get.pathname(md)
            p = md.pathname;
        end
    end
    methods (Static)
        addtag(ds, dir, tagname, value)
        display(md)
        cfilename = getcolocalizationfilename(md, itemname)
        h = gethistory(md, itemtype, itemname)
        imfilename = getimagefilename(md, itemname)
        itemstruct = getitems(md, itemtype)
        labeledroifilename = getlabeledroifilename(md, itemname)
        p = getparent(md, itemtype, itemname)
        roifilename = getroifilename(md, itemname)
        roipfilename = getroiparametersfilename(md, itemname, showerror)
        tag = gettag(ds,dir)
        b = hastag(ds,dir,tagname)
        removetag(ds, dir, tagname)
        h = sethistory(md, itemtype, itemname, h)
    end
end




