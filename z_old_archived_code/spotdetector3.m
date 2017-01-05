 function [rois3d, L, rois2d, BW] = spotdetector3(BI, connectivity, roiname, firstindex, labels)
% SPOTDETECTOR - identifies spots in a binary image
%
%   [ROIS3D, L, ROIS2D] = SPOTDETECTOR3(BI, CONNECTIVITY, ROINAME, ...
%               FIRSTINDEX, LABELS)
%
%  Inputs: BI - binary image in which to detect spots (can be 3d)
%          CONNECTIVITY - 4 or 8; should pixels only be considered
%               connected if they are immediately adjacent in x and y (4)
%               or should diagonals be considered adjacent (8)?
%          ROINAME - Name for the ROI series...maybe the same as a filename?
%          FIRSTINDEX - Index number to start with for labeling (maybe 0 or 1?)
%          LABELS - Any labels you might want to include (string or cell list)
%
%  Ouputs: ROIS3D a structure array with the following fields:
%          ROIS3D(i).name       The name of the roi (same as ROINAME)
%          ROIS3D(i).index      The index number
%          ROIS3D(i).xi         The xi coordinates of the contour
%          ROIS3D(i).yi         The yi coordinates of the contour
%          ROIS3D(i).pixelinds  Pixel index values (in image BW) of the ROI
%          ROIS3D(i).labels     Any labels for this ROI
%          ROIS3D(i).stats      All stats from matlab's regionprops func
%          L - the labeled 3D BW image; the numbers correspond to the ROIs (0
%          means no ROI was found at that location)
%          ROIS2D - a structure array with the 2d rois that were observed in the
%            individual images in the stack BI
%          
%          

BW = {};
L = {};
stats = {};
rois2d = {};

 % step 1: loop through all of the 2D images that comprise the 3D image,
 %    and find above threshold ROIs, and extract these ROIs and save them in a structure list

for i=1:size(BI,3), % loop over each 2d image in the 3d stack
	disp(['Finding ROIS in slice ' int2str(i) ' of ' int2str(size(BI,3))]);
	[BW{i}, L{i}] = bwboundaries(BI(:,:,i), connectivity,'noholes');
	stats{i} = regionprops(L{i},'all');
	rois2d{i}=struct('name','','index','','xi','','yi','',...
		'pixelinds','','labels','','stats','');
	rois2d{i} = rois2d{i}([]);

	% now, extract all rois from this location
	for j=1:length(BW{i}),
		clear newroi;
		newroi.name = roiname;
		newroi.index = firstindex -1 + j; 
		if length(BW{i}{j}(:,2))==1, 
			newroi.xi = BW{i}{j}(:,2) + [ -0.5 -0.5 0.5 0.5]';
			newroi.yi = BW{i}{j}(:,1) + [ -0.5 -0.5 0.5 0.5]';
		else,
			newroi.xi = BW{i}{j}(:,2);
			newroi.yi = BW{i}{j}(:,1);
		end; 
		newroi.pixelinds = stats{i}(j).PixelIdxList;
		newroi.labels = labels;
		newroi.stats = stats{i}(j); 
		rois2d{i}(end+1) = newroi;
	end;
end; 

 % now, for each 2D plane, you have a BW{i}, L{i}, stats{i}, and rois2d{i}
 
 % Step 2:  compute a 3D list of rois by combining across the adjacent planes 

rois3d =  rois2d{1};

for i=1:size(BI,3)-1,   % looping over new slices
    
	mergers = {};
	mergedalt = cell(1,length(rois2d{i+1}));
	disp(['Now merging slice ' int2str(i+1) '.']);
	rois3dtoremove = [];
    
	for j=1:length(rois3d),  % loop over rois that we know exist in the previous slice
        
	        % Step 2.1 
		% goal is to obtain a list of all the rois that do overlap with rois3d(j)
		% first step, identify the subset of pixels of rois3d(j) that are in
		% the next slice
		% pixels_in_this_ith_slice = % find subset of pixels that are in slice i and get their indexes
		% the 3d indexes are already in rois3d(j).pixelinds - these are 3d
        
		pixels_ith_slice = roi3d2dprojection(rois3d(j).pixelinds, size(BI), i);
		find_L = L{i+1}(pixels_ith_slice); % IDs rois2d{i+1}(find_L)
		% find_L is set of ROI numbers that overlap in the list rois2d{i+1}
	
		overlaps = unique(find_L(:)); % this is now an abbreviated list of the rois to merge
		overlaps = overlaps(find(overlaps>0));
        
		mergers{j} = [i+1 overlaps(:)']; % make a note of who we merged with the jth ROI
            
		for k=overlaps(:)',
			% job is to merge rois3d(i) with rois2d{i+1}(k)
			[i2d,j2d] = ind2sub([size(BI,1) size(BI,2)],rois2d{i+1}(k).pixelinds);
			[new3dindexes] = sub2ind(size(BI),i2d,j2d,repmat(i+1,length(i2d),1));
			rois3d(j).pixelinds = [rois3d(j).pixelinds(:);new3dindexes(:)];  
          
			mergedalt{k} = cat(2,mergedalt{k},j); % we merged rois3d(j) with local rois2d{i+1}(k)
		end;
	end; 
    
	% step 2.2, identify any rois2d{i+1} that were not merged with anyone;
	% these need to be added to rois3d as new rois
	for k=1:length(mergedalt),
		if isempty(mergedalt{k}), % we need to make a new roi3d
			% this is the same as ~foundOverlap in spotdectector2
			[i2d,j2d] = ind2sub([size(BI,1) size(BI,2)],rois2d{i+1}(k).pixelinds);
			[new3dindexes] = sub2ind(size(BI),i2d,j2d,repmat(i+1,length(i2d),1));
			rois3d(end+1) = rois2d{i+1}(k);
			rois3d(end).pixelinds = new3dindexes;
			mergedalt{k} = length(rois3d); % local roi k became global roi length(rois3d)
			mergers{length(rois3d)} = [i+1 k];
		end;
	end;
       
	% here, check for rois that were merged more than once, put them
	% together
    
	% step 2.3, merge the rois3d together
    
	for k=1:length(mergedalt),
		for n=1:length(mergedalt{k})-1,
			% merge rois3d(mergedalt{k}(1) and rois3d(mergedalt{k}(n+1)
			% this involves 2 steps: creating the union of the pixelindexes and
			% also renumbering the representation of rois3d in the mergedalt
			% list
			% first, merge the rois
			rois3d(mergedalt{k}(1)).pixelinds = union(rois3d(mergedalt{k}(1)).pixelinds,rois3d(mergedalt{k}(n+1)).pixelinds);
			% second, mark the merged roi for deletion
			rois3dtoremove(end+1) = mergedalt{k}(n+1);
                           
			% third, renumber all subsequent occurrences of
			% mergedalt{k}(n+1) so that it is mergedalt{k}(n)
			for k2 = k+1:length(mergedalt),
				anyk2indexes = find(mergedalt{k2}==mergedalt{k}(n+1));
				if ~isempty(anyk2indexes),
					mergedalt{k2}(anyk2indexes) = mergedalt{k}(1);
				end;
			end;
		end;
		mergedalt{k} = mergedalt{k}(1);
	end;     

	rois3d = rois3d( setdiff(1:length(rois3d), rois3dtoremove) );

	for k=1:length(mergedalt),
		if length(mergedalt{k})>0, 
			L{i+1}(rois2d{i+1}(k).pixelinds) = mergedalt{k}; 
		end;
	end;
    
	for k=1:length(rois3d),
		rois3d(k).index = k;
	end;
end;

L = cat(3,L{:});
