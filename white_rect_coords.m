function [boundingBox] = white_rect_coords()
    vid=videoinput('winvideo',1); 
    set(vid,'ReturnedColorSpace','rgb'); 
    start(vid); 
    im=getsnapshot(vid); 
    
    %transform imgae to binary image using Otsu threshold method
    level = graythresh(im);
    im = imbinarize(im, level);
    im = imcomplement(im);
    
    im = imclose(im, strel('rectangle', [5, 6]));
    
    [labels,numlabels]=bwlabel(im);
    props = regionprops(labels, 'all');
    
    %Check if rectangle lines are continous
    
    
    %Get inner rectangle coordinates 
    
    
    boundingBox = props(1).BoundingBox;
    
end

function [length]=get_rectangle_side_length(start, end, isWidth)
    for i
end



