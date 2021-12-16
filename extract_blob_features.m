function [features, rgbim, binim]=extract_blob_features(video)
    rgbim=getsnapshot(video); 
            
    subplot(2, 1, 1);
    imshow(rgbim);

    %transform imgae to binary image using Otsu threshold method
    binim = rgb2gray(rgbim);
    %imtool(binim);
    %binim = imcrop(binim, []);
    binim = imbinarize(binim);
    binim = imclose(binim, strel('rectangle', [5, 6]));

    subplot(2, 1, 2);
    imshow(binim);

    [labels,numlabels]=bwlabel(binim);
    props = regionprops(labels, 'all');
    
    features = [];
    
    for i = (1: size(props, 1))
        blob_props = props(i);
        
        area = blob_props.Area;
        if area > 200
            feature_vector = (1:5);
            
            blobim = blob_props.Image;
            n20 = normalizedCentralMoment(2, 0, blobim);
            n02 = normalizedCentralMoment(0, 2, blobim);
            n11 = normalizedCentralMoment(1, 1, blobim);
            
            feature_vector(1) = n20 + n02;
            feature_vector(2) = ((n20- n02) ^ 2) + (4 * (n11^2));
            
            feature_vector(1:2) = -sign(feature_vector(1:2)).*(log10(abs(feature_vector(1:2))));
            
            feature_vector(3) = getComponentModeFor(rgbim,binim, blob_props, 1);
            feature_vector(4) = getComponentModeFor(rgbim,binim, blob_props, 2);
            feature_vector(5) = getComponentModeFor(rgbim,binim, blob_props, 3);
            
            features = [features; feature_vector];
        end
    end
end

function [m]=getComponentModeFor(rgb, im, props, component)
    bbox = props.BoundingBox;
    binBoundingBox = imcrop(im, bbox);
    rgbBoundingBox = imcrop(rgb, bbox);
   
    
    components = [];
    i = 1;
    for x = (1:size(binBoundingBox, 1))
        for y = (1:size(binBoundingBox, 2))
            if binBoundingBox(x, y) == 1
                components(i) = rgbBoundingBox(x, y, component);
                i = i + 1;
            end
        end
    end
    m = mode(components);
end

function [moment]=calculateGeometricMoment(blobImg, xOrder, yOrder)
    moment = 0;
    for x = 1:size(blobImg, 1)
        for y = 1:size(blobImg, 2)
            moment = moment + (x ^ xOrder) * (y ^ yOrder) * blobImg(x,y);
        end
    end
end

function [moment]=centralMoment(blobImg, xOrder, yOrder)
    moment = 0;
    
    area = calculateGeometricMoment(blobImg, 0, 0);
    xCenter = calculateGeometricMoment(blobImg, 1, 0) / area;
    yCenter = calculateGeometricMoment(blobImg, 0, 1) / area;
    
    for x = 1:size(blobImg, 1)
        for y = 1:size(blobImg, 2)
            moment = moment + ((x - xCenter) ^ xOrder) * ((y - yCenter) ^ yOrder) * blobImg(x,y);
        end
    end
end

function [normalized_central_moment]=normalizedCentralMoment(xOrder, yOrder, blobImg)
    beta = ((xOrder + yOrder) / 2.0) + 1;
    
    uxOrderyOrder = centralMoment(blobImg, xOrder, yOrder);
    u00 = centralMoment(blobImg, 0, 0);
    
    normalized_central_moment = uxOrderyOrder / (u00 ^ beta);
end