function img_warp = img_warping(img, corners, n)
% Implement the image warping to transform the target A4 paper into the
% standard A4-size paper
% Input parameter:
% .    img - original input image
% .    corners - the 4 corners of the target A4 paper detected by the Hough transform
% .    (You can add other input parameters if you need. If you have added
% .    other input parameters, please state for what reasons in the PDF file)
% .    n - determine the size of the result image
% Output parameter:
% .    img_warp - the standard A4-size target paper obtained by image warping
    
    %define output array.
    img_warp = zeros(n*297,n*210);
    
    %need to order the corners into the correct order, or else the image
    %mapping will be weird
    
    
    %A = [corners(1,1)*corners(1,2) corners(1,1) corners(1,2) 1 0 0 0 0; corners(2,1)*corners(2,2) corners(2,1) corners(2,2) 1 0 0 0 0; corners(3,1)*corners(3,2) corners(3,1) corners(3,2) 1 0 0 0 0; corners(4,1)*corners(4,2) corners(4,1) corners(4,2) 1 0 0 0 0;0 0 0 0 corners(1,1)*corners(1,2) corners(1,1) corners(1,2) 1;0 0 0 0 corners(2,1)*corners(2,2) corners(2,1) corners(2,2) 1;0 0 0 0 corners(3,1)*corners(3,2) corners(3,1) corners(3,2) 1;0 0 0 0 corners(4,1)*corners(4,2) corners(4,1) corners(4,2) 1;]
    A = [1 1 1 1 0 0 0 0; 210*n 1 210*n 1 0 0 0 0; 210*n*297*n 297*n 210*n 1 0 0 0 0; 297*n 297*n 1 1 0 0 0 0; 0 0 0 0 1 1 1 1; 0 0 0 0 10*n 1 210*n 1; 0 0 0 0 210*n*297*n 297*n 210*n 1; 0 0 0 0 297*n 297*n 1 1;]
    %coefficients = A\[ 1 n*297 n*297 1 n*210 n*210 1].'
    coefficients = A\[corners(1,1); corners(2,1); corners(3,1); corners(4,1); corners(1,2); corners(2,2); corners(3,2); corners(4,2)]
    coefficients = double(coefficients.')
    
    for x = 1:size(img_warp,1)
        for y = 1:size(img_warp,2)
            u = x*y*coefficients(1)+x*coefficients(2)+y*coefficients(3)+coefficients(4);
            v = x*y*coefficients(5)+x*coefficients(6)+y*coefficients(7)+coefficients(8);
            
            %k nearest neighbor
            %u = abs(round(u));
            %v = abs(round(v));
            
            %img_warp(x,y) = img(u,v);
            
            %bilinear interpolation
            fy1 = (ceil(u)-u)*img(floor(u),floor(v))+(u-floor(u))*img(ceil(u),floor(v));
            fy2 = (ceil(u)-u)*img(floor(u),ceil(v))+(u-floor(u))*img(ceil(u),ceil(v));
            fxy = (ceil(v)-v)*fy1+(v-floor(v))*fy2;
            img_warp(x,y) = fxy;
            
           
            %img_warp(x,y) = [ceil(u)-u u-floor(u)]*[img(floor(u),floor(v)) img(ceil(u),floor(v)); img(floor(u),ceil(v)) img(ceil(u), ceil(v))]*[ceil(v)-v v-floor(v)].';
        end
    end
    
    img_warp = uint8(img_warp);
    
                
    