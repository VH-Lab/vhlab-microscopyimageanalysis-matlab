function properties = roi_properties(rois3d, D)

D = double(D);

rows = size(D,1);
columns = size(D,2);
zdim = size(D,3);

properties = struct('area',0,'totalbrightness',0,'averagebrightness',0,'centreofmass',0,'firstmomentofarea',0,'indexes3d',0);
properties = properties([]);

for i=1:length(rois3d)
    myarea = length(rois3d(i).pixelinds);
    mytotalbrightness = sum(D(rois3d(i).pixelinds));
    myaveragebrightness = mean(D(rois3d(i).pixelinds));
    [d1, d2, d3] = ind2sub(size(D), rois3d(i).pixelinds);
    mycentreofmass =(((D(rois3d(i).pixelinds))')*[d1, d2, d3])/mytotalbrightness;
    
    % For loop
    % for j=1:length(rois3d(i).pixelinds)
    %    [d1, d2, d3] = ind2sub(size(D), rois3d(i).pixelinds(j));
    %    mycentreofmass =((D(rois3d(i).pixelinds(j))*[d1, d2, d3]))/mytotalbrightness;
    % end
    
    myfirstmomentofarea = ((D(rois3d(i).pixelinds))')*(([d1, d2, d3]).^2);
    
    myindexes = rois3d(i).pixelinds;
    
    myproperties = struct('area',myarea,...
            'totalbrightness',mytotalbrightness,...
            'averagebrightness',myaveragebrightness,...
            'centreofmass',mycentreofmass,...
            'firstmomentofarea',myfirstmomentofarea,...
            'indexes3d',myindexes);
        
    properties(end+1) = myproperties;
end

