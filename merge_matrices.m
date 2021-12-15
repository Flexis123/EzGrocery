function [z]=merge_matrices(x, y)
    [i1,j1] = ndgrid(1:size(x,1),1:size(x,2));
    [i2,j2] = ndgrid(1:size(y,1),(1:size(y,2))+size(x,2));
    z = accumarray([i1(:),j1(:);i2(:),j2(:)],[x(:);y(:)]);
end

 