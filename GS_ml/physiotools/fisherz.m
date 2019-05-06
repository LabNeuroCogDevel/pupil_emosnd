function [zprime]=fisherz(r)
% computes z' from r using Fisher's z' transformation
% Useage: fisherz(r)

zprime=.5*(log(1+r)-log(1-r));

