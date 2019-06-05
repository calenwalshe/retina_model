function im = imblur(im, envelope)
%% function im = imblur(im, envelope)
% Description: Blur an image with specified envelope.
%
%   R. Calen Walshe June 9, 2016. R. Calen Walshe
%   (calen.walshe@utexas.edu)
    
    im = lib.fftconv2(im, envelope);
end