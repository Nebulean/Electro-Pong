% This will create a background numerically.
% An RGB image is a NxMx3 uint8 matrix. (no alpha)

N = 480;
M = 620;

imgR = zeros(N,M);
imgG = zeros(N,M);
imgB = zeros(N,M);

normrnd(0,1);
[dmax, pmax] = dist_phase(0,0,N,M);
[dmin, pmin] = dist_phase(480/2,0,N,M);
for i=1:N
    for j=1:M
        [d,p] = dist_phase(i,j,N,M);
        
        if d < dmin/5
            imgR(i,j) = floor(map(d, 0, dmin/5, 180, 130) + normrnd(0,2));
            imgG(i,j) = floor(map(d, 0, dmin/5, 180, 130) + normrnd(0,2));
            imgB(i,j) = floor(map(d, 0, dmin/5, 180, 130) + normrnd(0,2));
        elseif d >= dmin/5 && d < 3*dmin/5
            imgR(i,j) = floor(map(d, dmin/5, 3*dmin/5, 130, 50+80) + normrnd(0,2));
            imgG(i,j) = floor(map(d, dmin/5, 3*dmin/5, 130, 0+80) + normrnd(0,2));
            imgB(i,j) = floor(map(d, dmin/5, 3*dmin/5, 130, 100+80) + normrnd(0,2));
        elseif d >= 3*dmin/5
            imgR(i,j) = floor(map(d, 3*dmin/5, dmax, 50+80, 100) + normrnd(0,2));
            imgG(i,j) = floor(map(d, 3*dmin/5, dmax, 0+80, 100) + normrnd(0,2));
            imgB(i,j) = floor(map(d, 3*dmin/5, dmax, 100+80, 100) + normrnd(0,2));
        end
    end
end

img = zeros(N,M,3);
img(:,:,1) = imgR;
img(:,:,2) = imgG;
img(:,:,3) = imgB;

imshow(uint8(img))
imwrite(uint8(img),"background.png","png")

function [d, p] = dist_phase(i,j,N,M)    
    d = sqrt( (i - N/2)^2 + (j - M/2)^2 );
    p = atan2(i-M/2,j-N/2);
end



% source: https://www.arduino.cc/reference/en/language/functions/math/map/
function val = map(x, in_min, in_max, out_min, out_max)
    val = (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
end