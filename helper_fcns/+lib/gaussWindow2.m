function win = gaussWindow2(Parameters)
%% envelope = gaussWindow2(params)
% Description: Returns a circularly symmetric 2D Gaussian with specified
% parameters.
%
% Author: R. Calen Walshe (calen.walshe@utexas.edu)
pixStd  = Parameters.pixperdeg * Parameters.std;
winSize = [122;122];%lfloor((Parameters.size .* pixStd)/2) * 2;
  
X        = (-winSize(1)/2 + 1):winSize(1)/2 - 1;
Y        = (-winSize(2)/2 + 1):winSize(2)/2 - 1;
[XX, YY] = meshgrid(X,Y);

win = (exp(-(XX.^2/(2*(pixStd(1))^2) + YY.^2/(2 * (pixStd(2))^2))));

win = win ./ sum(win(:));

end