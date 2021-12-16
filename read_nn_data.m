function [nn_features,nn_labels] = read_nn_data(nnDataFname)
    try
        nn_data = readmatrix(nnDataFname);
        nn_features = nn_data(:, 1:5);
        nn_labels = nn_data(:, 6);
    catch e
        nn_features = [];
        nn_labels = [];
    end
end

