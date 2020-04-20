function [iMap,tenMap,hybMap,iDis,tenDis,hybDis,tenDisMap] = funcHybrid(dist_frames,zStart,zEnd)
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

% applying threshold
intensity_thresh = 0.2;
tenen_thresh = 0.2;
% calculating distance using intensity_thresh (Method-1)
counter = 0;
dist_sum = 0;
for col = 1:cols
    for row = 1:rows
        if(iMap(row,col) < intensity_thresh)
            counter = counter +1;
            dist_sum = dist_sum + iDisMap(row,col);
        end
    end
end
iDis = dist_sum/counter;
% calculating distance using tenMap (Method-2)
tenen_counter = 0;
tenDis_sum = 0;
for col = 1:cols
    for row = 1:rows
        if(tenMap(row,col) > tenen_thresh)
            tenen_counter = tenen_counter +1;
            tenDis_sum = tenDis_sum + tenDisMap(row,col);
        end
    end
end
tenDis = tenDis_sum/tenen_counter;
% combining above 2 Methods for hybrid
% first converting iMap into binary matrix
for col = 1:cols
    for row = 1:rows
        if(iMap(row,col) < intensity_thresh)
            iMap(row,col) = 1;
        else
            iMap(row,col) = 0;
        end
    end
end
iMap = imdilate(iMap,ones(8));
% Creating hybMap
hybMap = iMap.*tenMap;
hybrid_counter = 0;
hybDis_sum = 0;
hybrid_thresh = 0.7;
for col = 1:cols
    for row = 1:rows
        if(hybMap(row,col) > hybrid_thresh)
            hybrid_counter = hybrid_counter + 1;
            hybDis_sum = hybDis_sum + tenDisMap(row,col);
        end 
    end
end
hybDis = (hybDis_sum/hybrid_counter);

