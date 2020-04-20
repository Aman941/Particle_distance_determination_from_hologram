function object = funcParticleSim(object,xc,yc,r)
[M,N]=size(object);
x = linspace(-1,1,N);
y = linspace(-1,1,M);
[X,Y] = meshgrid(x,y);
K = numel(xc);
if numel(xc) ~= numel(yc)
   msg = 'x and y coordinate vector should be of same length';
   error(msg)
end
if numel(xc) ~= numel(r)
   msg = 'x,y coordinate vectors and r should be of same length';
   error(msg)
end
for k = 1:K
    object((X-xc(k)).^2+(Y-yc(k)).^2 < r(k)^2) = 0;
end

end