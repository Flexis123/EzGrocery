function [product_matrix,biggest_label] = read_product_matrix_and_biggest_label(productMatrixFname)
    product_matrix = readmatrix(productMatrixFname);
    product_matrix_size = size(product_matrix);

    if product_matrix_size(1) == 0
        biggest_label = 0;
    else
       biggest_label = product_matrix(end); 
    end

end

