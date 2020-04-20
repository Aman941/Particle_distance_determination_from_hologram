clc
clear
a = imread('img6.png');
a_gray = rgb2gray(a);
level = 0.1;
threshold = graythresh(a_gray);
a_bw=im2bw(a_gray,threshold);
%a_bw = imbinarize(a_gray,level);
Icomp = imcomplement(a_bw);
hold on
[B,L] = bwboundaries(a_bw,'noholes');
imshow(label2rgb(L, @jet, [.5 .5 .5]))
figure
imshow(a_bw);
hold on
for k = 1:length(B)
   boundary = B{k};
   plot(boundary(:,2), boundary(:,1), 'r', 'LineWidth', 1)
end