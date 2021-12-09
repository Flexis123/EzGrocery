im = imread('vupfp.jpg');
%disp(getComponentModeFor(im, 1));
component = 1;
components = im(:, :, component);
disp(components(:));
 
