clear all; close all;
I=imread('img4.bmp','bmp'); % 256256 pixels, 8bit image
I=double(I);
I = medfilt2(I);

% To find the size of Image:
sizeOfImage = size(I);
M = max(sizeOfImage(1),sizeOfImage(2));

% parameter setup
%M=1024;
deltax=0.001; % pixel pitch 0.001 cm (10 um)
w=633*10^-8; % wavelength 633 nm
z=25; % 25 cm, propagation distance


%Step 1: simulation of propagation using the ASM
r=1:sizeOfImage(1);
c=1:sizeOfImage(2);
[C, R]=meshgrid(c, r);
A0=fftshift(ifft2(fftshift(I)));
deltaf=1/M/deltax;
p=exp(-2i*pi*z.*((1/w)^2-((R-M/2- 1).*deltaf).^2-...
((C-M/2-1).*deltaf).^2).^0.5);
Az=A0.*p;
EO=fftshift(fft2(fftshift(Az)));

%Step 2: interference at the hologram plane
AV=4*(min(min(abs(EO)))+max(max(abs(EO))));
IH=(EO+AV).*conj(EO+AV);
figure; imshow(I);
title('Original object')
axis off
figure; imshow(mat2gray(IH));
title('Hologram')
axis off
SP=abs(fftshift(ifft2(fftshift(IH))));
figure; imshow(500.*mat2gray(SP));
title('Hologram spectrum')
axis off

% creating maps for further computation
sz = size(I);
intensity_map = zeros(sz);
intensity_dist_map = zeros(sz);
tenen_map = zeros(sz);
tenen_dist_map = zeros(sz);

[rows , cols] = size(I);

% initializing intensity_map matrix
for col = 1:cols
    for row = 1:rows
        intensity_map(row,col) = 2000;
    end
end

% initializing no. of frames to work upon
frame_no = 1000;
dist_frames = zeros(rows,cols,frame_no);

for n = 1:frame_no;
    i = (0.9*z + (0.2*z/frame_no)*n);  % to get frames between 0.9z & 1.1z
    p=exp(-2i*pi*i.*((1/w)^2-((R-M/2- 1).*deltaf).^2-...
    ((C-M/2-1).*deltaf).^2).^0.5);
    A1=fftshift(ifft2(fftshift(IH)));
    Az1=A1.*conj(p);
    EI=fftshift(fft2(fftshift(Az1)));
    EI=mat2gray(EI.*conj(EI));
    dist_frames(:,:,n) = EI;
end

% creating the maps

for n = 1:frame_no;
    tenen_img = sobel(dist_frames(:,:,n));
    intensity_img = dist_frames(:,:,n);
    for col = 1:cols
        for row = 1:rows
            if(intensity_map(row,col) > intensity_img(row,col))
                intensity_map(row,col) = intensity_img(row,col);
                intensity_dist_map(row,col) = (0.9*z+(0.2*z/frame_no)*n);
            end
            if(tenen_map(row,col) < tenen_img(row,col))
                tenen_map(row,col) = tenen_img(row,col);
                tenen_dist_map(row,col) = (0.9*z+(0.2*z/frame_no)*n);
            end
        end
    end
end

figure
imshow(tenen_map);
figure
imshow(intensity_map);

% applying threshold
intensity_thresh = 0.4;
tenen_thresh = 0.6;

% calculating distance using intensity_thresh (Method-1)
counter = 0;
dist_sum = 0;
for col = 1:cols
    for row = 1:rows
        if(intensity_map(row,col) < intensity_thresh)
            counter = counter +1;
            dist_sum = dist_sum + intensity_dist_map(row,col);
        end
    end
end
intensity_dist = dist_sum/counter;

% calculating distance using tenen_map (Method-2)
tenen_counter = 0;
tenen_dist_sum = 0;
for col = 1:cols
    for row = 1:rows
        if(tenen_map(row,col) > tenen_thresh)
            tenen_counter = tenen_counter +1;
            tenen_dist_sum = tenen_dist_sum + tenen_dist_map(row,col);
        end
    end
end
tenen_dist = tenen_dist_sum/tenen_counter;

% combining above 2 Methods for hybrid

% first converting intensity_map into binary matrix
for col = 1:cols
    for row = 1:rows
        if(intensity_map(row,col) < intensity_thresh)
            intensity_map(row,col) = 1;
        else
            intensity_map(row,col) = 0;
        end
    end
end

intensity_map = imdilate(intensity_map,ones(8));

figure 
imshow(intensity_map);

% Creating hybrid_map

hybrid_map = intensity_map.*tenen_map;
hybrid_counter = 0;
hybrid_dist_sum = 0;
hybrid_thresh = 0.7;


for col = 1:cols
    for row = 1:rows
        if(hybrid_map(row,col) > hybrid_thresh)
            hybrid_counter = hybrid_counter + 1;
            hybrid_dist_sum = hybrid_dist_sum + tenen_dist_map(row,col);
        end 
    end
end

hybrid_dist = (hybrid_dist_sum/hybrid_counter);

figure
imshow(hybrid_map);
