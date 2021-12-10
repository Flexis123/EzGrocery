NN_DATA_SIZE = 100;
PRODUCT_MATRIX_FNAME = 'pmatrix.csv';
NN_FNAME = "nngrocery.mat";
NN_DATA_FNAME = "nngrocerydata.csv";

product_matrix = readmatrix(PRODUCT_MATRIX_FNAME);
product_matrix_size = size(product_matrix);

if product_matrix_size(1) == 0
    biggest_label = 0;
else
   product_with_biggest_label = product_matrix(end);
   biggest_label = product_with_biggest_label(3); 
end

product_matrix_new_products = [];

want_to_register_new_product = 'y';
while want_to_register_new_product == 'y'
    product_name = input('Enter product name: ', 's');
    product_price = input('Enter product price: ', 's');
    
    biggest_label = biggest_label + 1;
    product_matrix_new_products(end) = [product_name, product_price, biggest_label];
    
    disp('\n');
    want_to_register_new_product = input('Do you want to register a new product? [y/n]: ');
    disp('\n');
end

i = 1;
nn_features_new = [];
nn_labels_new = [];

vid=videoinput('winvideo',1);

for product = product_matrix_new_products
    for i = (0: NN_DATA_SIZE)
        product_name = input('Enter product name: ','s');
        product_price = input('Enter product price: ', 's');

        inp = 'c';
        while inp ~= c
            inp = input('Enter "c" character to take image snapshot');
        end

        set(vid,'ReturnedColorSpace','rgb'); 
        start(vid); 
        im=getsnapshot(vid); 

        %transform imgae to binary image using Otsu threshold method
        im = rgb2gray(im);
        im = imbinarize(im);
        im = imcomplement(im);
        im = imclose(im, strel('rectangle', [5, 6]));

        imshow(im);

        is_product_good = input('Do you think the taken snapshot is good enough? [y/n]: ');
        if is_product_good == 'n'
            continue
        end

        [labels,numlabels]=bwlabel(im);
        props = regionprops(labels, 'all');

        nn_features_new(end) = extract_blob_features(props);
        nn_labels_new(end) = product(3);
    end
end

nn_data = readmatrix(NN_DATA_FNAME);
nn_features = nn_data(:, 1:5);
nn_labels = nn_data(:, 6);

nn_features = [nn_features; nn_features_new];
nn_labels = [nn_labels; nn_labels_new];

nn_labels_outputs = [];
for label = nn_labels
    labels_outputs = (0: biggest_label);
    labels_outputs(label) = 1;
    nn_labels_outputs(end) = labels_outputs;
end

if isFile(NN_FNAME)
    nngrocery = load(NN_FNAME);
else
    nngrocery = patternnet(10);
end

train(nngrocery, nn_features, nn_labels_outputs);

save(nngrocery, NN_FNAME);
writematrix([product_matrix; product_matrix_new_products], PRODUCT_MATRIX_FNAME);

nn_data(:, 1:5) = nn_features;
nn_data(:, 6) = nn_labels;
writematrix(nn_data, NN_DATA_FNAME);

