% Hologram reconstruction 
clc
clear all
close all
%% PARAMETERS
N = 256;                   % number of pixels
lambda = 500*10^(-9);      % wavelength in meter
area = 0.002;              % area size in meter
z_start = 0.06;            % z start in meter
z_end = 0.1;              % z end in meter
z_step = 0.001;            % z step in meter
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% READING HOLOGRAM OBJECT
    fid = fopen('objholo.bin', 'r');
    hologramO = fread(fid, [N, N], 'real*4');
    hologramO = hologramO - 0;
    fclose(fid);      
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OBJECT RECONSTRUCTED AT DIFFERENT Z-DISTANCES
S = round((z_end - z_start)/z_step);
reconstructionO = zeros(N,N,S);
%z = [0.07,0.08,0.09];
%S = 3;
for ii=1:S 
z = z_start + ii*z_step;
prop = Propagator1(N, lambda, area, z);
recO = (ifft2(ifftshift(fftshift(fft2(hologramO)).*prop)));
reconObj(:,:,ii) = abs(recO);
end
[iMap,tenMap,tenDisMap,iDisMaps,hybDist,B,centroids,Area] = funcHybridSecond(reconObj,z_start,z_end);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%hybDist contains particles position in z direction ie particle depth info.


