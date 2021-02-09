function ImgPatchesEye = patches2eye(ImgPatches, parameters, sampleMask, scriptLibPath, PSF)
% function ImgPatchesEye = patches2eye(ImgPatches, parameters)
% Description: Takes an matrix that contains image patches. Each image in
% the matrix is blurred and downsampled by the optics of the eye and
% retinal sampling density.
%
% ImgPatches [n, n, m, 2]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% parameters.std             = [1/sqrt(120^2), 1/sqrt(120^2)];
% parameters.size            = 5;
% parameters.pixperdeg       = 120;
% parameters.downsampleCoeff = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% R. Calen Walshe (calen.walshe@utexas.edu) June 24th, 2016.

addpath(scriptLibPath);

inputParams = {'imageSz', 'std', 'size', 'pixperdeg', 'downsampleCoeff'};

if ~all(ismember(inputParams, fieldnames(parameters)))
    error('Check parameters and configure them correctly.');    
end

envelope = lib.gaussWindow2(parameters);

imageSz         = parameters.imageSz;

padVal    = zeros(2,1);
padVal(1) = floor((2^ceil(log2(parameters.imageSz)) - parameters.imageSz)/2);
padVal(2) = ceil((2^ceil(log2(parameters.imageSz)) - parameters.imageSz)/2);

ImgPatchesEye = zeros((imageSz + sum(padVal)), (imageSz + sum(padVal)), size(ImgPatches, 3), size(ImgPatches, 4));

imAbsent  = ImgPatches(:,:,1);
    
padVal = 2^ceil(log2(size(imAbsent,1)));
padDC  = mean(imAbsent(:));
bg     = zeros(padVal, padVal) + padDC;

tWinCenter  = true((size(imAbsent)));

imAbsent  = lib.embedImageinCenter(bg, imAbsent, 0, 14, 0,0, tWinCenter);

% 1. Optical blur
imAbsent  = im2optics(imAbsent, PSF);

downsampleCoeff = parameters.downsampleCoeff;

% Random shift to position of retinal image
if downsampleCoeff ~= 1
    shiftCoeff  = floor((downsampleCoeff/2));
    x_randshift = randi([-shiftCoeff, shiftCoeff - 1]);
    y_randshift = randi([-shiftCoeff, shiftCoeff - 1]);    
    imAbsent    = circshift(imAbsent,  [x_randshift, y_randshift]);
end

% 2. Retinal ganglion sampling blur
imAbsent  = lib.imblur(imAbsent, envelope);

% 3. Downsample according to midget cell density.

if downsampleCoeff ~= 0    
    
    gaborParams.std            = .2;
	gaborParams.sf         = 4;
	gaborParams.ori        = 90;
	gaborParams.phase      = 0;
	gaborParams.pixperdeg  = 1 + ceil(downsampleCoeff);
	gaborParams.odd_even   = 'odd';
	gaborParams.envelope   = 'coswin';
    [gabor, envelope] = lib.gabor2D(gaborParams, 0);
    
    envelope = envelope ./ sum(envelope(:));
    
    imAbsent  = reshape(imAbsent(sampleMask),[imageSz/downsampleCoeff,imageSz/downsampleCoeff]);
      
    imAbsent  = imresize(imAbsent, downsampleCoeff, 'nearest');
    
end   
ImgPatchesEye(:,:,1) = imAbsent;

end
