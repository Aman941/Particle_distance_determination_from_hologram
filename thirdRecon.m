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

dist_frames = reconObj;
dist_frames = mat2gray(dist_frames);
[rows,cols,nF] = size(dist_frames);
zVec = linspace(z_start,z_end,nF);
iMap = 2000*ones(rows,cols); 
iDisMap = zeros(rows,cols);
tenMap = zeros(rows,cols);
tenDisMap = zeros(rows,cols);
for n = 1:nF
tenen_img = sobel(dist_frames(:,:,n));
intensity_img = dist_frames(:,:,n);
    for col = 1:cols
        for row = 1:rows
            if(iMap(row,col) > intensity_img(row,col))
                iMap(row,col) = intensity_img(row,col);
                iDisMap(row,col) = zVec(n);
            end
            if(tenMap(row,col) < tenen_img(row,col))
                tenMap(row,col) = tenen_img(row,col);
                tenDisMap(row,col) = zVec(n);
            end
        end
    end
end
% [iMap,iDisMap] = min(dist_frames,[],3);
% for n = 1:nF
%     tenen_img(:,:,n) = sobel(dist_frames(:,:,n));
% end
% [tenMap,tenDisMap] = max(tenen_img,[],3);
tenenMaxVal = max(max(tenMap));
% find required threshold for each particle


bestThresh = 0.32;
   thresh_start = 0.0001;
   thresh_end = 0.49;
   thresh_step = 0.01;
   globalSharpness = 0;
   %itterating to find best threshold
   S = round((thresh_end - thresh_start)/thresh_step);
   for ii=1:S 
      thresh = thresh_start + ii*thresh_step;
      iTestMap = iMap;
      iTestMap = im2bw(iTestMap,thresh);
      iTestMap = ~iTestMap;
      iTestMap = imdilate(iTestMap,ones(3)) - iTestMap; %identified edges
      tenTestMap = iTestMap.*tenMap;
      tenTestMap = tenTestMap.*iMap;
      iMap = iTestMap.*iMap;
      sharp_num = sum(sum(tenTestMap));
      sharp_den = sum(sum(iMap));
      sharpness = double(double(sharp_num)/double(sharp_den));
      if(isnan(sharpness))
          break
      end
      disp(sharpness);
      disp(thresh);
      if(sharpness > globalSharpness)
          bestThresh = thresh;
          globalSharpness = sharpness;
      end
   end
   disp(bestThresh);