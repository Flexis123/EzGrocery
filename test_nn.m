vid=videoinput('winvideo',1);
set(vid,'ReturnedColorSpace','rgb'); 
start(vid); 

[f, rgb, bin] = extract_blob_features(vid);
subplot(3, 1, 1);
imshow(rgb);

subplot(3, 1, 2);
imshow(bin);

disp(f);
load nngrocery;
disp(nngrocery(f'))

