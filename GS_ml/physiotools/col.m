function [colvals]=col(mat,colnum)
% useage: [colvals]=col(mat,colnum)
% returns a column in the specified matrix
    colvals= mat(:,colnum);
