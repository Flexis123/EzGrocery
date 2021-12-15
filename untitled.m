vid=videoinput('winvideo',1);
set(vid,'ReturnedColorSpace','rgb'); 
start(vid); 
rgbimorig=getsnapshot(vid); 

subplot(3, 1, 1);
rgbim = imcrop(rgbimorig, [95, 19, 869, 377]);
imshow(rgbim);


%transform imgae to binary image using Otsu threshold method
im = rgb2gray(rgbim);
im = imbinarize(im);
im = imclose(im, strel('rectangle', [5, 6]));

imshow(im);

[labels,numlabels]=bwlabel(im);
props = regionprops(labels, 'all');

disp(props.Area);

loadobj(nngrocery);
disp(extract_blob_features(props, rgbim, im)');
[certainty, label] = max(nngrocery(extract_blob_features(props, rgbim, im)'));
disp(label);
