%----------------Fourier Transform Filter---------------
%Author: Alexander Pinkerton
%Date: 9/17/2016
%-------------------------------------------------------
%This function will allow the extraction of features in the frequency
%domain by cropping the image matrix in the frequency domain. The desired
%features and cutoff frequencies can be specified.
%-------------------------------------------------------
function [filtered] = fftfilter(image, cutoff, filter)
image = fftshift(image);

%Perform DFT on the image and shift it to center.
ff = fftshift(fft2(image));

%Perform one of four supported filter types.
if  strcmp(filter, 'highpass')
    cropped = circlecrop(ff, cutoff(1), 'outer');
elseif strcmp(filter, 'lowpass')
    cropped = circlecrop(ff, cutoff(1), 'inner');
elseif strcmp(filter, 'bandpass')
    cropped = ringcrop(ff, cutoff(1), cutoff(2), 'ring');
elseif strcmp(filter, 'bandstop')
    cropped = ringcrop(ff, cutoff(1), cutoff(2), 'ring-invert');
else
    disp('That crop type is unsupported');    
end

%Shift the cropped image matrix back from the frequency domain.
%It is needed to bring the complex numbers back into the reals.
%Convert to uint8 for proper image format.
filtered = uint8(real(ifftshift(ifft2(ifftshift(cropped)))));


% imshow(filtered);
% pause();

end


%-----------------------CircleCrop---------------------
%Author: Alexander Pinkerton
%Date: 9/17/2016
%------------------------------------------------------
%This function will perform multiple centered circular cropping 
% procedures on an image matrix. This function was written to be
% used with DFT highpass and lowpass feature extraction
%------------------------------------------------------
function [croppedImage] = circlecrop(image, radius, croptype)
imageSize = size(image);
%Create an vector that contains the circle center and radius.
ci = [imageSize(1)/2, imageSize(2)/2, radius];
%Create a centered grid the size of the image
[xx,yy] = ndgrid((1:imageSize(1))-ci(1),(1:imageSize(2))-ci(2));

%Generate a binary cropping mask based on procedure chosen
if  strcmp(croptype, 'inner')
    mask = double((xx.^2 + yy.^2)<ci(3)^2);
elseif strcmp(croptype, 'outer')
    mask = not(double((xx.^2 + yy.^2)<ci(3)^2));
else
    disp('That crop type is unsupported');    
end

%Get the number of channels in the image
channels = size(imageSize,2);

%Use the cropping mask to zero out everything in the image
% except which has a corresponding one in the mask.
croppedImage = double(zeros(size(image)));

%Account for grayscale and color images
croppedImage(:,:,1) = image(:,:,1).*mask;
if channels == 3
    croppedImage(:,:,2) = image(:,:,2).*mask;
    croppedImage(:,:,3) = image(:,:,3).*mask;
end

% imshow(croppedImage);
% pause();

end


%-----------------------RingCrop---------------------
%Author: Alexander Pinkerton
%Date: 9/17/2016
%------------------------------------------------------
%This function will perform multiple centered ring-based cropping 
% procedures on an image matrix. This function was written to be
% used with DFT bandpass and bandstop feature extraction
%------------------------------------------------------
function [croppedImage] = ringcrop(image, inner, outer, croptype)
imageSize = size(image);
%Create an vector that contains the circle center and the inner and outer
%circle radii
ci = [imageSize(1)/2, imageSize(2)/2, inner, outer];
%Create a centered grid the size of the image
[xx,yy] = ndgrid((1:imageSize(1))-ci(1),(1:imageSize(2))-ci(2));

%Generate a binary cropping mask based on procedure chosen
if  strcmp(croptype, 'ring')
    mask = double((xx.^2 + yy.^2)<ci(4)^2) - double((xx.^2 + yy.^2)<ci(3)^2);
elseif strcmp(croptype, 'ring-invert')
    mask = not(double((xx.^2 + yy.^2)<ci(4)^2) - double((xx.^2 + yy.^2)<ci(3)^2));
else
    disp('That crop type is unsupported');    
end

%Get the number of channels in the image
channels = size(imageSize,2);

%Use the cropping mask to zero out everything in the image
% except which has a corresponding one in the mask.
croppedImage = double(zeros(size(image)));

%Account for grayscale and color images
croppedImage(:,:,1) = image(:,:,1).*mask;
if channels == 3
    croppedImage(:,:,2) = image(:,:,2).*mask;
    croppedImage(:,:,3) = image(:,:,3).*mask;
end

% imshow(croppedImage);
% pause();

end


