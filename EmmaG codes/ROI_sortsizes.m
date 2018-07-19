function [list_of_sortedsizes] = ROI_sortsizes(CC)

num_cells = CC.NumObjects;
list_of_sizes = zeros(num_cells,2);

for i = 1:num_cells
    list_of_sizes(i,1) = i;
    list_of_sizes(i,2) = length(CC.PixelIdxList{i});
end

list_of_sortedsizes = sortrows(list_of_sizes,2);
