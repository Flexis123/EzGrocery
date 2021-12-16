
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
