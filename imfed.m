function[z] = imfed(x,y)
% Id     = (x-y);
denmtr = sum(sum(x.^2));
numrtr = 1- sum(sum(y.^2));
z = numrtr./denmtr;
