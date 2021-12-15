NN_DATA_FNAME = "nngrocerydata.csv";
nn_data = readmatrix(NN_DATA_FNAME);
try
    nn_features = nn_data(:, 1:5);
    nn_labels = nn_data(:, 6);
catch e
    nn_features = [];
    nn_labels = [];
end

biggest_label = 3;

nn_labels_outputs = zeros(size(nn_labels, 1), biggest_label);
for x = (1: size(nn_labels, 1))
    labels_outputs = zeros(1, biggest_label);
    labels_outputs(nn_labels(x)) = 1;
    nn_labels_outputs(x, :) = labels_outputs;
end

nngrocery = patternnet(30);
nngrocery = train(nngrocery, nn_features', nn_labels_outputs');

vid=videoinput('winvideo',1);
set(vid,'ReturnedColorSpace','rgb'); 
start(vid); 

saveobj(nngrocery);


