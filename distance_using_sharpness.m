clear all; close all;
I=imread('img.bmp','bmp'); % 256256 pixels, 8bit image
I=double(I);
I = medfilt2(I);


% To find the size of Image:
sizeOfImage = size(I);
M = max(sizeOfImage(1),sizeOfImage(2));
%%%%%N = min(sizeOfImage(1),sizeOfImage(2));


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
% amplitude of reference light
% the visibility can be controlled by modifying the amplitude
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
%z = z;
maxsharpness = 0;
distance = 0;
%%%
for i = 10:40
    i
    p=exp(-2i*pi*i.*((1/w)^2-((R-M/2- 1).*deltaf).^2-...
    ((C-M/2-1).*deltaf).^2).^0.5);
    A1=fftshift(ifft2(fftshift(IH)));
    Az1=A1.*conj(p);
    EI=fftshift(fft2(fftshift(Az1)));
    EI=mat2gray(EI.*conj(EI));
    currsharpness = fmeasure(EI,'ACMO');
    if(currsharpness > maxsharpness)
        distance = i;
        maxsharpness = currsharpness;
    end
end
%%%

axis off