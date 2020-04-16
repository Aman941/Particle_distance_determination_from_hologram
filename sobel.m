%%my_img = imread('img.bmp','bmp');
function tenen_img = sobel(my_img)
    kx= [1 ,0 ,-1; 2,0,-2; 1, 0 ,-1];
    ky= [1,2,1; 0,0, 0; -1, -2 ,-1];
    H = conv2(im2double(my_img),kx,'same');
    V = conv2(im2double(my_img),ky,'same');
    tenen_img = sqrt(H.*H + V.*V);
    %imshow(tenen_img, [])
end