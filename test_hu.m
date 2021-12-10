vid=videoinput('winvideo',2);
set(vid,'ReturnedColorSpace','rgb'); 
start(vid); 
rgbim=getsnapshot(vid); 

subplot(2, 1, 1);
rgbim = imcrop(rgbim, [349, 115, 360, 360]);
imshow(rgbim);

%transform imgae to binary image using Otsu threshold method
im = rgb2gray(rgbim);
im = imbinarize(im);
im = imclose(im, strel('rectangle', [5, 6]));

[labels,numlabels]=bwlabel(im);
props = regionprops(labels, 'all');

subplot(2, 1, 2);
imshow(im);

disp(extract_blob_features(props, rgbim));
