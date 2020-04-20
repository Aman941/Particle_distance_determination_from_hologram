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
p = zeros(N,N);
for ii = 1:N; 
    for jj = 1:N
        alpha = lambda*(ii - N/2 -1)/area;
        beta = lambda*(jj - N/2 -1)/area;
        if ((alpha^2 + beta^2) <= 1)
        p(ii,jj) = exp(-2*pi*i*z*sqrt(1 - alpha^2 - beta^2)/lambda);
        end; % if
    end
end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%