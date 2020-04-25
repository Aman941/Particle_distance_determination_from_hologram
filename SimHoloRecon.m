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
[iMap,tenMap,hybMap,iDis,tenDis,hybDis,tenDisMap,iDisMap] = funcHybrid(reconObj,z_start,z_end);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure;
imshow(iMap);
figure
imshow(tenMap);
figure;
imshow(hybMap);
% little tweaking hybMap

threshold = graythresh(hybMap);
hybMap_bw = im2bw(hybMap,threshold);

hold on
[B,L] = bwboundaries(hybMap_bw,'noholes');
%imshow(label2rgb(L, @jet, [.5 .5 .5]))
%figure
imshow(hybMap_bw);
hold on
for k = 1:length(B)
   boundary = B{k};
   plot(boundary(:,2), boundary(:,1), 'r', 'LineWidth', 1)
end
% obtaining x,y location of particles
centroids = regionprops(hybMap_bw,'centroid');
% obtaining 2d size of particles
Areas = regionprops(hybMap_bw,'Area');
% distance of particles in 3d
partiDist = zeros(length(B),1); % it will contain distances of different particles
tenDisMap = tenDisMap.*hybMap_bw;
for k = 1:length(B)
   boundary = B{k};
   col1 = boundary(:,1);
   col2 = boundary(:,2);
   r1 = min(col1);
   r2 = max(col1);
   c1 = min(col2);
   c2 = max(col2);
   counter = 0;
   for r = r1:r2
       for c = c1:c2
           partiDist(k,1) = partiDist(k,1)+tenDisMap(r,c);
           if(tenDisMap(r,c) ~= 0)
               counter = counter+1;
           end 
       end
   end
   partiDist(k,1) = partiDist(k,1)/counter;
end


