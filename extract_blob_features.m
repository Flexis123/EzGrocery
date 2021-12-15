function [features]=extract_blob_features(blobs, rgbim, binim)
    features = [];
    
    for blob_props = blobs
        area = blob_props.Area;
        disp(area);
        if area > 200
            feature_vector = (1:5);
            
            blobim = blob_props.Image;
            n20 = normalizedCentralMoment(2, 0, blobim);
            n02 = normalizedCentralMoment(0, 2, blobim);
            n11 = normalizedCentralMoment(1, 1, blobim);
            
            feature_vector(1) = n20 + n02;
            feature_vector(2) = ((n20- n02) ^ 2) + (4 * (n11^2));
            
            feature_vector(1:2) = -sign(feature_vector(1:2)).*(log10(abs(feature_vector(1:2))));
            
            pxList = blob_props.BoundingBox;
            feature_vector(3) = getComponentModeFor(rgbim,binim, pxList, 1);
            feature_vector(4) = getComponentModeFor(rgbim,binim, pxList, 2);
            feature_vector(5) = getComponentModeFor(rgbim,binim, pxList, 3);
            
            features = [features; feature_vector];
        end
    end
end

function [m]=getComponentModeFor(rgbim, binim, blobBoundingBox, component)
    components = [];
    i = 1;

    topLeftx = ceil(blobBoundingBox(1));
    topLefty = ceil(blobBoundingBox(2));

    for x = (topLeftx : ceil(topLeftx + blobBoundingBox(3)))
        for y = (topLefty : ceil(topLefty + blobBoundingBox(4)))
            %disp([y,x]);
            if binim(y, x) == 1
                components(i) = rgbim(y, x, component);
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