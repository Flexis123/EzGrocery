NN_DATA_SIZE = 15;
PRODUCT_MATRIX_FNAME = 'pmatrix.csv';
NN_FNAME = 'nngrocery.mat';
NN_DATA_FNAME = "nngrocerydata.csv";
NN_FEATURES_AMOUNT = 5;

product_matrix = readmatrix(PRODUCT_MATRIX_FNAME);
product_matrix_size = size(product_matrix);

if product_matrix_size(1) == 0
    biggest_label = 0;
else
   biggest_label = product_matrix(end); 
end

product_matrix_new_products = [];

want_to_register_new_product = 'y';
while want_to_register_new_product == 'y'
    product_price = input('Enter product price: ');
    
    biggest_label = biggest_label + 1;
    product_matrix_new_products = [product_matrix_new_products; [product_price, biggest_label]];
    
    disp(' ');
    want_to_register_new_product = input('Do you want to register a new product? [y/n]: ', 's');
    disp(' ');
end

features_amount = size(product_matrix_new_products, 1) * NN_DATA_SIZE;
nn_features_new = zeros(features_amount, NN_FEATURES_AMOUNT);
nn_labels_new = zeros(features_amount, 1);

vid=videoinput('winvideo',1);
set(vid,'ReturnedColorSpace','rgb'); 
start(vid); 

n = 1;
disp(nn_features_new);
disp(nn_labels_new);
for i = (1: size(product_matrix_new_products, 1))
    disp(['starting nn data collection for label nr. : ', num2str(product_matrix_new_products(i, 2))]);
    for f = (1: NN_DATA_SIZE)    
        features = [];
        
        picture_not_good = 1;
        while picture_not_good
            inp = 'f';
            while inp ~= 'c'
                inp = input('Enter "c" character to take image snapshot', 's');
            end
            
            rgbim=getsnapshot(vid); 
            
            subplot(2, 1, 1);
            imshow(rgbim);

            %transform imgae to binary image using Otsu threshold method
            im = rgb2gray(rgbim);
            im = imbinarize(im);
            im = imclose(im, strel('rectangle', [5, 6]));
            
            subplot(2, 1, 2);
            imshow(im);

            [labels,numlabels]=bwlabel(im);
            props = regionprops(labels, 'all');

            if size(features, 1) > 1
                disp('second object detected! retake snapshot!');
                continue;
            end
            
            try
                features = extract_blob_features(props, rgbim, im);
                disp(features);
            catch e
                disp('Make sure the object is fully in frame!');
                continue;
            end

            is_product_good = input('Do you think the taken snapshot is good enough? [y/n]: ', 's');
            if is_product_good == 'n'
                continue;
            else
                break;
            end
            
        end
        
        nn_features_new(n, :) = features(1, :);
        nn_labels_new(n, :) = [product_matrix_new_products(i, 2)];
        
        n = n + 1;
    end
end

nn_data = readmatrix(NN_DATA_FNAME);
try
    nn_features = nn_data(:, 1:5);
    nn_labels = nn_data(:, 6);
catch e
    nn_features = [];
    nn_labels = [];
end

nn_features =[nn_features; nn_features_new];
nn_labels = [nn_labels; nn_labels_new];

disp(nn_features);


nn_labels_outputs = zeros(size(nn_labels, 1), biggest_label);
for x = (1: size(nn_labels, 1))
    labels_outputs = zeros(1, biggest_label);
    labels_outputs(nn_labels(x)) = 1;
    nn_labels_outputs(x, :) = labels_outputs;
end

nngrocery = patternnet(30);
nngrocery = train(nngrocery, nn_features', nn_labels_outputs');

save nngrocery;
writematrix([product_matrix; product_matrix_new_products], PRODUCT_MATRIX_FNAME);
writematrix(merge_matrices(nn_features, nn_labels), NN_DATA_FNAME);

