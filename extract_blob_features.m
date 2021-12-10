function [feature_vector]=extract_blob_features(blob_props, rgbImg)
    feature_vector = (1:5);
    
    %1st invariant moment of hu
    img = blob_props.Image;
    n20 = calculateNormalizedCentralMoment( 2, 0, img);
    n02 = calculateNormalizedCentralMoment(0, 2, img);
    feature_vector(1) = log_transform(n20 + n02);
    
    %2nd invariant moment of hu
    n11 = calculateNormalizedCentralMoment(1, 1, img);
    feature_vector(2) = log_transform(((n20 - n02) ^ 2) + 4*(n11^2));
    
    pxList = blob_props.PixelList;
    feature_vector(3) = getComponentModeFor(rgbImg, pxList, 1);
    feature_vector(4) = getComponentModeFor(rgbImg, pxList, 2);
    feature_vector(5) = getComponentModeFor(rgbImg, pxList, 3);
end

function [num]=log_transform(normalizedCentralMoment)
    num = -1 * (1.0 * normalizedCentralMoment) * log10(abs(normalizedCentralMoment));
end

function [m]=getComponentModeFor(rgbImg, blobPixels, component)
    components = (1:size(blobPixels, 1));
    i=1;
    for pixel = blobPixels
        c = rgbImg(pixel(1));
        pixel_rgb_val = c(pixel(2));
        components(i) = pixel_rgb_val(component);
        i = i + 1;
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

function [normalized_central_moment]=calculateNormalizedCentralMoment(xOrder, yOrder, blobImg)
    beta = ((xOrder + yOrder) / 2) + 1;
    
    MxOrderyOrder = calculateGeometricMoment(blobImg, xOrder, yOrder);
    M00 = calculateGeometricMoment(blobImg, 0, 0);
    
    normalized_central_moment = MxOrderyOrder / (M00 ^ beta);
end