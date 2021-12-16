vid=videoinput('winvideo',1);
set(vid,'ReturnedColorSpace','rgb'); 
start(vid);

[product_matrix, biggest_label] = read_product_matrix_and_biggest_label('pmatrix.csv');
load nngrocery;

cart = [];
prompt = 'Enter key: ';
scanningProcess = false;

while true
    key = input(prompt, 's');
    if scanningProcess == false && key == 's'
        disp('Started scanning state');
        scanningProcess = true;

    elseif scanningProcess == true && key == 'f'
        [features, rgbim, binim] = extract_blob_features(vid);
        
        disp('Scanned the following products:');
        
        for f = (1: size(features, 1))
           [certainty, label] = max(nngrocery(features(f, :)'));
           price = product_matrix(label, 1);

           disp(['price: ', num2str(product_matrix(label, 1)), ' label: ', num2str(product_matrix(label, 2))]);

           cart = [cart, price];
           i = i + 1;
        end
    elseif scanningProcess == true && key == 'h'
        disp(['Total price of products: ', num2str(sum(cart))]);
        scanningProcess = false;
        cart = [];
    elseif scanningProcess == true && key == 'c'
        disp('Cancelled scanning');
        scanningProcess = false;
        cart = [];
    else
        disp('Invalid key!Key either is not a recognizable key or isnt accepted for the current state');
    end   
end