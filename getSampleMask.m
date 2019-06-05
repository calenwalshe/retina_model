function mask = getSampleMask(bgSz, sampleF)
% function mask = getSampleMask(bgSz, sampleF)
%
% Description: Generate a mask for sampling from blurred and downsampled
% retinal images.
%
% Author: R. Calen Walshe (calen.walshe@utexas.edu).
if sampleF ~= 1 && mod(sampleF,2) ~= 0
    error('Sample fraction is not a power of 2.');
end

mask = zeros(sampleF, sampleF);

mask(ceil(sampleF/2), ceil(sampleF/2))   = 1;
%mask(end) = 1;

mask = repmat(mask, bgSz/sampleF, bgSz/sampleF); 

mask = logical(mask);
end