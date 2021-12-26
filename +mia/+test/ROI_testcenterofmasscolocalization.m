function diffhere = ROI_testcenterofmasscolocalization(colocalization_data)

I = find(colocalization_data.distances);

diffhere = [];

for i=1:numel(I),

	d_here = colocalization_data.distances(I(i));

	[r,c] = ind2sub(size(colocalization_data.distances),I(i));

	d_actual = L2_distance(colocalization_data.com_a(r,:)',colocalization_data.com_b(c,:)');

	diffhere(i) = d_here - d_actual;
end;


