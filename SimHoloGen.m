% Hologram generation of point objects placed randomly at three different
% planes
clc
close all
clear all

N = 256;                   % number of pixels
lambda = 500*10^(-9);      % wavelength in meter
area = 0.002;              % area sidelength in meter
z = 0.08;                  % z in meter
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% CREATING OBJECT
nP = 10; % no. of point objects
r =  0.015*ones(nP,1); % radius of point objects
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SIMULATING HOLOGRAM
object = ones(N,N);
xc = -1+2*1*rand(nP,1); 
yc = -1+2*1*rand(nP,1);
%xc= 0; yc = 0; r = 0.01;
object = funcParticleSim(object,xc,yc,r);
object = (object - min(min(object)))/(max(max(object)) - min(min(object)));    
object = double(object); 
figure; imagesc(object); colormap gray;
z1 = 0.01;
prop = Propagator1(N, lambda, area, z1);
U = ifft2(ifftshift(fftshift(fft2(object)).*prop));

object = ones(N,N);
xc = -1+2*1*rand(nP,1); 
yc = -1+2*1*rand(nP,1);
object = funcParticleSim(object,xc,yc,r);
object = (object - min(min(object)))/(max(max(object)) - min(min(object)));    
object = double(object);
figure; imagesc(object); colormap gray;
z2 = 0.01;
prop = Propagator1(N, lambda, area, z2);
U = ifft2(ifftshift(fftshift(fft2(U.*object)).*prop));
object = ones(N,N);
xc = -1+2*1*rand(nP,1); 
yc = -1+2*1*rand(nP,1);
object = funcParticleSim(object,xc,yc,r);
object = (object - min(min(object)))/(max(max(object)) - min(min(object)));    
object = double(object); 
figure; imagesc(object); colormap gray;
z3 = 0.07;
prop = Propagator1(N, lambda, area, z3);
U = ifft2(ifftshift(fftshift(fft2(U.*object)).*prop));
hologram = abs(U).^2;
figure, imshow(hologram, []);
colormap(gray);

fid = fopen(strcat('Objholo.bin'), 'w');
fwrite(fid, hologram, 'real*4');
fclose(fid);