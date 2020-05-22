% This will create a background numerically.
% An RGB image is a NxMx3 uint8 matrix. (no alpha)

N = 720/2;
M = 1280/2;

imgR = zeros(N,M);
imgG = zeros(N,M);
imgB = zeros(N,M);

normrnd(0,1);
[dmax, pmax] = dist_phase(0,0,N,M);
[dmin, pmin] = dist_phase(480/2,0,N,M);
for i=1:N
    for j=1:M
        [d,p] = dist_phase(i,j,N,M);
        
        if d < 2*dmin/5
            imgR(i,j) = floor(map(d, 0, 2*dmin/5, 180, 140) + normrnd(0,2));
            imgG(i,j) = floor(map(d, 0, 2*dmin/5, 180, 140) + normrnd(0,2));
            imgB(i,j) = floor(map(d, 0, 2*dmin/5, 180, 140) + normrnd(0,2));
        elseif d >= 2*dmin/5 && d < 4*dmin/5
            imgR(i,j) = floor(map(d, 2*dmin/5, 4*dmin/5, 140, 120) + normrnd(0,2)); % 50+80
            imgG(i,j) = floor(map(d, 2*dmin/5, 4*dmin/5, 140, 120) + normrnd(0,2)); % 0+80
            imgB(i,j) = floor(map(d, 2*dmin/5, 4*dmin/5, 140, 120) + normrnd(0,2)); % 100+80
        elseif d >= 4*dmin/5
            imgR(i,j) = floor(map(d, 4*dmin/5, dmax, 120, 110) + normrnd(0,2));
            imgG(i,j) = floor(map(d, 4*dmin/5, dmax, 120, 110) + normrnd(0,2));
            imgB(i,j) = floor(map(d, 4*dmin/5, dmax, 120, 110) + normrnd(0,2));
        end
    end
end

img = zeros(N,M,3);
img(:,:,1) = imgR;
img(:,:,2) = imgG;
img(:,:,3) = imgB;

figure
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