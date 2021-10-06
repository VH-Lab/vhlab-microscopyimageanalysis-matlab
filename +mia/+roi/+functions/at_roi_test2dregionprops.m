function [myprops2d_all, myprops2d_indiv] = at_roi_test2dregionprops(CC2)


disp('Doing full regionprops2d...');
myprops2d_all = regionprops(CC2,'all');
myprops2d_indiv = [];

CC2_2 = CC2;
CC2_2.NumObjects = 1;

for n=1:CC2.NumObjects,
	if mod(n,1000)==0, n, end;
	CC2_2.PixelIdxList = CC2.PixelIdxList(n);
	myprops2d_indiv = cat(1,myprops2d_indiv(:),regionprops(CC2_2,'all'));
end;

disp(['Testing for equality:']);

eqlen(myprops2d_all,myprops2d_indiv)

 % wow, they are equal
