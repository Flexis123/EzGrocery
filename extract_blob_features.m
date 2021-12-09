function [feature_vector]=extract_blob_features(blob_props)
    feature_vector = (1:5);
    
    %1st invariant moment of hu
    n20 = calculateNormalizedCentralMoment(blob_props.Image, 2, 0);
    n02 = calculateNormalizedCentralMoment(blob_props.Image, 0, 2);
    feature_vector(1) = n20 + n02;
    
    %2nd invariant moment of hu
    n11 = calculateNormalizedCentralMoment(blob_props.Image, 1, 1);
    feature_vector(2) = ((n20 - n02) ^ 2) + 4*(n11^2);
    
    feature_vector(3) = getComponentModeFor(blob_props.PixelList, 1);
    feature_vector(4) = getComponentModeFor(blob_props.PixelList, 2);
    feature_vector(5) = getComponentModeFor(blob_props.PixelList, 3);
end


function [m]=getComponentModeFor(im, component)
    components = im(:, :, component);
    %%todo get corresponding rgb pixel
    m = mode(components(:));
end

function [moment]=calculateGeometricMoment(blobImg,xOrder, yOrder)
    moment = 0;
    for x = size(blobImg, 1)
        for y = size(blobImg, 2)
            pixelRow = blobImg(x);
            pixelValue = pixelRow(y);
            
            moment = (x ^ xOrder) * (y ^ yOrder) * pixelValue;
        end
    end
end

function [normalized_central_moment]=calculateNormalizedCentralMoment(blobImg,xOrder, yOrder)
    beta = (xOrder + yOrder) / 2;
    
    MxOrderyOrder = calculateGeometricMoment(blobImg, xOrder, yOrder);
    M00 = calculateGeometricMoment(blobImg, 0, 0);
    
    normalized_central_moment = MxOrderyOrder / (M00 ^ beta);
end