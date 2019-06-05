function [normX, normY] = getNormalVector(winSz, envelope, ganglionSampR, PPD)
% Description: Compute a vector that is normal to the edge of the target.
% 
% if nargin < 1
%     winSz = 255;
% end
% [XX, YY] = meshgrid([-winSz:1:0,0,1:winSz], [-winSz:1:0,0,1:winSz]);
% 
% len = sqrt(XX.^2 + YY.^2);
% X = XX./len;
% Y = YY./len;
% 
% normX = X;
% normY = Y;

if nargin < 1
    winSz = 256;
    ganglionSampR = 120;
    PPD           = 60;
end

edgeG    = lib.getGaussianDerivative(ganglionSampR, PPD);
edgeX    = edgeG(:,:,1);
edgeY    = edgeG(:,:,2);

im = lib.embedImageinCenter(zeros(winSz, winSz), envelope, 1, (2^14-1), 0, 0, envelope);

boundary = occluding_model.lib.envelope2boundary(envelope);
boundary = lib.embedImageinCenter(zeros(winSz, winSz), boundary, 1, 8, 0, 0, envelope);

im_x = conv2(im(:,:,1), edgeX, 'same');
im_y = conv2(im(:,:,1), edgeY, 'same');    

gradLen = sqrt(im_x.^2 + im_y.^2);    

gradX = (im_x ./ gradLen);
gradY = (im_y ./ gradLen);

gradX(~boundary) = 0;
gradY(~boundary) = 0;    

normX = gradX;
normY = gradY;

end