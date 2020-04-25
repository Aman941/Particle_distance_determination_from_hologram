function bestThresh = findThreshold(iMap,tenMap)
   bestThresh = 0.32;
   thresh_start = 0.0001;
   thresh_end = 0.32;
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
      sharpness = sharp_num/sharp_den;
      if(isnan(sharpness))
          break
      end
%      disp(sharpness);
%      disp(thresh);
      if(sharpness > globalSharpness)
          bestThresh = thresh;
          globalSharpness = sharpness;
      end
   end