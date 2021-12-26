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
        
        function deleteitem(md,itemtype,itemname)
        % DELETEITEM - Delete an item of a particular type from an MIADIR
            %
            %  DELETEITEM(MD, ITEMTYPE, ITEMNAME)
            %
            %  Deletes the item ITEMNAME of type ITEMTYPE from the directory
            %  managed by the MIADIR object MD.
            %
            %  There is no turning back, the item is gone forever.

                dirname = [md.pathname filesep itemtype filesep itemname];

                rmdir(dirname,'s');
        end % deleteitem
        
        function display(md)
        % DISPLAY print info from an MIADIR object
            %
            %   DISPLAY(MD)
            %
            %   Displays information about the MIADIR object MD
            %
            %   See also: MIADIR
            
            if isempty(inputname(1)),
	            disp([inputname(1) '; manages directory ' md.pathname ]);
            else,
	            disp([inputname(1) '; manages directory ' md.pathname ]);
            end;
        end % display

        function cfilename = getcolocalizationfilename(md, itemname)
        % GETCOLOCALIZATIONFILENAME - get the image file from an MIADIR
            %
            %  CFILENAME = GETCOLOCALIZATIONFILENAME(MD, ITEMNAME)
            %
            %  Returns the colocalization filename associated with the item name
            %  ITEMNAME.
            %
            %  Returns empty string ('') if none.
            %
            
            cfilename = '';
            
            extensions = {'.mat'};
            
            dnames = {};
            for i=1:length(extensions),
	            d = dir([md.pathname 'CLAs' filesep itemname filesep '*_CLA' extensions{i}]);
	            dnames = cat(1,dnames,d.name);
	            if ~isempty(dnames), break; end; % if we have a match it is good
            end;
            
            if ~isempty(dnames),
	            dnames = sort(dnames);
	            cfilename = [md.pathname 'CLAs' filesep itemname filesep dnames{1}];
            end;
        end % getcolocalizationfilename

        function h = gethistory(md, itemtype, itemname)
        % GETHISTORY - Get the history of an item from MIADIR directory
            %  
            %  H = GETHISTORY(MD, ITEMTYPE, ITEMNAME)
            %
            %  Returns the history structure of item ITEMNAME that is
            %  of type ITEMTYPE in the directory managed by the MIADIR 
            %  object MD.
            % 
            %  If there is no history, H is an empty structure.
            %
            %  ITEMNAME and ITEMTYPE must be valid directory names.
            %
            %  The history structure has the following fields, and is in
            %  chronological order of the operations performed on the ITEMTYPE:
            %
            %  Fieldnames:    | Description: 
            %  ---------------------------------------------------------
            %  parent         | If the item has a parent, the item name corresponding
            %                 |   to the parent is listed here. Otherwise it is an empty
            %                 |   string ('').
            %  operation      | The text of the function call is described here
            %  parameters     | The parameters that were used
            %  description    | A human-readable description of the operation
            
            h = emptystruct('parent','operation','parameters','description');
            
            try,
	            h = load([md.pathname filesep itemtype filesep ...
			            itemname filesep 'history.mat']);
	            h = h.history;
            catch,
	            % warning(['History loading error: ' lasterr]);
            end;
        end % gethistory

        function imfilename = getimagefilename(md, itemname)
        % GETIMAGEFILENAME - get the image file from an MIADIR
            %
            %  IMFILENAME = GETIMAGEFILENAME(MD, ITEMNAME)
            %
            %  Returns the image filename associated with the item name
            %  ITEMNAME.
            %
            %  It will examine the directory and return the first image file
            %  encountered (searches .tiff, .tif, .gif, .jpg, .jpeg).
            %  Returns empty string ('') if none.
            % 
            
            imfilename = '';
            
            extensions = {'.tiff','.tif','.gif','.jpg','.jpeg'};

            dnames = {};
            for i=1:length(extensions),
	            d = dir([md.pathname 'images' filesep itemname filesep '*' extensions{i}]);
	            dnames = cat(1,dnames,d.name);
	            if ~isempty(dnames), break; end; % if we have a match it is good
            end;
            
            if ~isempty(dnames),
	            dnames = sort(dnames);
	            imfilename = [md.pathname 'images' filesep itemname filesep dnames{1}];
            end;
        end % getimagefilename

        function itemstruct = getitems(md, itemtype)
        % GETITEMS - Get items of a particular type in an MIADIR experiment directory
            %  
            %   ITEMSTRUCT = GETITEMS(MD, ITEMTYPE)
            %
            %  Returns an item struct array with all items of ITEMTYPE
            %  in the MIADIR director MD.
            %
            %  Examples of ITEMTYPE could be 'images', 'ROIs', etc...
            %
            %  The item struct is the following:
            %  Fieldname:   |   Description
            %  -------------------------------------------------------
            %  name         |   The item name
            %  parent       |   The item's parent's name, if any
            %  history      |   A structure with the item's history
            
            itemstruct = emptystruct('name','parent','history');
            
            d = dir([md.pathname filesep itemtype]);
            dirnumbers = find([d.isdir]);
            dirlist = {d(dirnumbers).name};
            dirlist = dirlist_trimdots(dirlist);
            
            for i=1:length(dirlist),
	            n.name = dirlist{i};
	            n.parent = md.getparent(itemtype,n.name);
	            n.history = md.gethistory(itemtype,n.name);
	            itemstruct(i) = n;
            end;
        end % getitems

	function b = isitem(md, itemtype, itemname)
		% ISITEM - is there an item with a particular name?
		%
		% B = ISITEM(MD, ITEMTYPE, ITEMNAME)

			i = md.getitems(itemtype);
			b = any(strcmp(itemname,{i.name}));
			
	end; % isitem()
		

        function labeledroifilename = getlabeledroifilename(md, itemname)
        % GETLABELEDROIFILENAME - get the image file from an MIADIR
            %
            %  ROIFILENAME = GETLABELEDROIFILENAME(MD, ITEMNAME)
            %
            %  Returns the labeled ROI filename associated with the ROI item name
            %  ITEMNAME.
            %
            
            labeledroifilename = '';
            
            dnames = {};
            d = dir([md.pathname 'ROIs' filesep itemname filesep '*L.mat']);
            dnames = cat(1,dnames,d.name);
            
            if ~isempty(dnames),
	            labeledroifilename = [md.pathname 'ROIs' filesep itemname filesep dnames{1}];
            end;
        end % getlabeledroifilename

        function p = getparent(md, itemtype, itemname)
        % GETPARENT - Get the parent of an item from MIADIR directory
            %  
            %  P = GETPARENT(MD, ITEMTYPE, ITEMNAME)
            %
            %  Returns the parent name of item ITEMNAME that is
            %  of type ITEMTYPE in the directory managed by the MIADIR 
            %  object MD.
            % 
            %  If there is no parent, P is an empty string.
            %
            %  ITEMNAME and ITEMTYPE must be valid directory names.
            %
            
            p = '';
            
            try,
	            p = text2cellstr([md.pathname filesep itemtype filesep ...
			            itemname filesep 'parent.txt']);
	            p = p{1};
            end;
        end % getparent

        function p = getpathname(md)
        % GETPATHNAME - Get the pathname of an MIADIR
            %
            %  P = GETPATHNAME(MD)
            %
            %  Returns the pathname associated with the MIADIR directory
            %  MD.
            %
            %  See also: MIADIR
            %
            
            p = md.pathname;
        end % getpathname
        
        function roifilename = getroifilename(md, itemname)
        % GETROIFILENAME - get the image file from an MIADIR
            %
            %  ROIFILENAME = GETROIFILENAME(MD, ITEMNAME)
            %
            %  Returns the filename associated with the ROI item name
            %  ITEMNAME.
            %
            
            roifilename = '';
            
            dnames = {};
            d = dir([md.pathname 'ROIs' filesep itemname filesep '*ROI.mat']);
            dnames = cat(1,dnames,d.name);
            
            if ~isempty(dnames),
	            roifilename = [md.pathname 'ROIs' filesep itemname filesep dnames{1}];
            end;
            
            if isempty(roifilename),
	            errordlg(['Could not locate the ROI file in ' [md.pathname 'ROIs' filesep itemname filesep] '; this directory should be deleted.']);
            end
        end % getroifilename

        function roipfilename = getroiparametersfilename(md, itemname, showerror)
        % GETROIPARAMETERSFILENAME - get the image file from an MIADIR
            %
            %  ROIPFILENAME = GETROIFILENAME(MD, ITEMNAME, SHOWERROR)
            %
            %  Returns the filename associated with the ROI parameters for item name
            %  ITEMNAME.
            %
            
            if nargin<3,
	            showerror = 0;
            end;
            
            roipfilename = '';
            
            dnames = {};
            d = dir([md.pathname 'ROIs' filesep itemname filesep '*ROI_roiparameters.mat']);
            dnames = cat(1,dnames,d.name);
            
            if ~isempty(dnames),
	            roipfilename = [md.pathname 'ROIs' filesep itemname filesep dnames{1}];
            end;
            
            if isempty(roipfilename),
	            if showerror,
		            errordlg(['Could not locate the ROI parameter file in ' [md.pathname 'ROIs' filesep itemname filesep] '; this directory should be deleted.']);
	            end;
            end;
        end % getroiparametersfilename

        function h = sethistory(md, itemtype, itemname, h)
        % SETHISTORY - Set the history of an item from MIADIR directory
            %  
            %  SETHISTORY(MD, ITEMTYPE, ITEMNAME, H)
            %
            %  Sets the history structure of item ITEMNAME that is
            %  of type ITEMTYPE in the directory managed by the MIADIR 
            %  object MD.
            % 
            %  ITEMNAME and ITEMTYPE must be valid directory names.
            %
            %  The history structure should have the following fields, and is in
            %  chronological order of the operations performed on the ITEMTYPE:
            %
            %  Fieldnames:    | Description: 
            %  ---------------------------------------------------------
            %  parent         | If the item has a parent, the item name corresponding
            %                 |   to the parent is listed here. Otherwise it is an empty
            %                 |   string ('').
            %  operation      | The text of the function call is described here
            %  parameters     | The parameters that were used
            %  description    | A human-readable description of the operation
            
            history = h;
            
            save([md.pathname itemtype filesep ...
		            itemname filesep 'history.mat'],'history');
        end % sethistory
    end % methods
end




