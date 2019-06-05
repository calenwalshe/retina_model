function imOut = downsampleRetina(imIn, level)
%% function downsampleModelPatches(fpIn, fpOut, bin, pyramidLvl, downsampleCoeff, scriptLibPath)
%
% Description: Create an image on the retina at 6 levels of eccentricity
%
% R. Calen Walshe (June 24, 2016) calen.walshe@utexas.edu

load('./psf4mm')

scriptLibPath = './helper_fcns';

pyramidParams = [120.*((1/2).^(0:5))', 2.^(0:5)'];

parameters.std              = [1/(2*pyramidParams(level,1)), 1/(2*pyramidParams(level,1))];
parameters.downsampleCoeff  = pyramidParams(level,2);                

if size(imIn,1) ~= size(imIn,2) || any(mod(size(imIn),2) ~= 0)
    error('Not Square or not even')
end

patchSz              = size(imIn,1);
parameters.size      = 5;
parameters.pixperdeg = 120;
parameters.imageSz   = 2^ceil(log2(patchSz));
              
sampleMask = getSampleMask(2^ceil(log2(patchSz)), parameters.downsampleCoeff); % Sample pixels according to retinal eccentricity.
        
ImgPatches(:,:,1) = imIn;

ImgPatchesOut     = patches2eye(ImgPatches, parameters, sampleMask, scriptLibPath, psf4mm);

imOut = ImgPatchesOut(:,:,1);
             