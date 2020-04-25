%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% WAVEFRONT PROPAGATION BY ANGULAR SPECTRUM METHOD
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Citation for this code/algorithm or any of its parts:
% Tatiana Latychevskaia and Hans-Werner Fink
% "Practical algorithms for simulation and reconstruction of digital in-line holograms",
% Appl. Optics 54, 2424 - 2434 (2015)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The code is written by Tatiana Latychevskaia, 2002
% The version of Matlab for this code is R2010b

function [p] = Propagator1(N, lambda, area, z)

x = 1:N;%linspace(1,N,N);
y = 1:N;%linspace(1,N,N);
[X,Y] = meshgrid(x,y);
alpha = lambda*(X- N/2 - 1)/area;
beta = lambda*(Y- N/2 - 1)/area;
p = zeros(N,N);
p((alpha.^2 + beta.^2) <= 1) = exp(2*pi*1i*z*sqrt(1 - alpha.^2 - beta.^2)/lambda);
% for ii = 1:N
%     for jj = 1:N
%         alpha = lambda*(ii - N/2 -1)/area;
%         beta = lambda*(jj - N/2 -1)/area;
%         if ((alpha^2 + beta^2) <= 1)
%         p(ii,jj) = exp(-2*pi*i*z*sqrt(1 - alpha^2 - beta^2)/lambda);
%         end % if
%     end
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%