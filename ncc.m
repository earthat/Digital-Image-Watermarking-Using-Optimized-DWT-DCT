function [z] = ncc(x,y)
v = sum(sum(x.*y));
w = sum(sum(x.^2));
z = v./w;
