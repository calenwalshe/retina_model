function im = im2optics(imIn, PSF)
%% IM2OPTICS    
    im = lib.fftconv2(imIn, PSF);           
end
