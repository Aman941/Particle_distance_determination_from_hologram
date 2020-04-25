function [iMap,tenMap,tenDisMap,iDisMap,hybDist,B,centroids,Areas] = funcHybridSecond(dist_frames,zStart,zEnd)
dist_frames = mat2gray(dist_frames);
[rows,cols,nF] = size(dist_frames);
zVec = linspace(zStart,zEnd,nF);
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

bestThresh = findThreshold(iMap,tenMap);
disp('best threshold value is');
disp(bestThresh);

% applying threshold
intensity_thresh = bestThresh;
tenen_thresh = 0.5*tenenMaxVal;

iMap = im2bw(iMap,bestThresh);
iMap = ~iMap;
%SE = strel('disk',1);
iMapEdges = imdilate(iMap,ones(3)) - iMap;
[B] = bwboundaries(iMapEdges,'noholes');
figure 
imshow(iMapEdges);
hybDist = zeros(length(B),1);
tenDisMap = tenDisMap.*iMapEdges;
hybEdges = tenMap.*iMapEdges;
%disp(tenen_thresh);
hold on;
for k = 1:length(B)
   boundary = B{k};
   plot(boundary(:,2), boundary(:,1), 'r', 'LineWidth', 1)
   col1 = boundary(:,1);
   col2 = boundary(:,2);
   r1 = min(col1);
   r2 = max(col1);
   c1 = min(col2);
   c2 = max(col2);
   counter = 0;
   for r = r1:r2
       for c = c1:c2
           if(hybEdges(r,c) > tenen_thresh)
               hybDist(k,1) = hybDist(k,1)+tenDisMap(r,c);
               counter = counter+1;
           end
       end
   end
   %disp(hybDist(k,1));
   %disp(counter);
   hybDist(k,1) = hybDist(k,1)/counter;
end
% obtaining x,y location of particles
centroids = regionprops(iMap,'centroid');
% obtaining 2d size of particles
Areas = regionprops(iMap,'Area');


