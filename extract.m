%----------------Hybrid Image Creator---------------
%Author: Alexander Pinkerton
%Date: 9/17/2016
%-------------------------------------------------------
%This function will allow the creation of hybrid images via the cropping
%the DFT of an image. Lowpass, highpass, bandpass, and bandstop are all
%supported. Specify the type and the cutoff values.
%-------------------------------------------------------

% img1 = imread('withoutacnecrop.jpg');
% img2 = imread('withacnecrop.jpg');
img2 = imread('ladybugcrop.jpg');
img1 = imread('applecrop.jpg');
% img1 = imread('mjcrop1.jpg');10
% img2 = imread('mjcrop2.jpg');2 
% img2 = imread('bikehybrid.png');
% img1 = imread('bikehybrid2.png');
% img2 = rgb2gray(img2);


%Extract low frequency features.
lowfreq = fftfilter(img1, 20, 'lowpass');
%Extract high frequency features.
highfreq = fftfilter(img2, 3, 'highpass');

% %Extract band frequency features.
% bandfreq = fftfilter(img2, [10 30], 'bandpass');
% imshow(bandfreq);
% pause();


%If one image is in grayscale, grayscale the other image.
if size(lowfreq,3)==1 || size(highfreq,3)==1
    if size(lowfreq,3)~=1
        disp('resized low');
        lowfreq = rgb2gray(lowfreq);
    end
    if size(highfreq,3)~=1
        disp('resized high');
        highfreq = rgb2gray(highfreq);
    end
end

%Resize the images to be the same, Use smallest for max quality.  
outSize = min(size(lowfreq),size(highfreq));
lowfreq = imresize(lowfreq, [outSize(1) outSize(2)]);
highfreq = imresize(highfreq, [outSize(1) outSize(2)]);

%Add the two images together to produce the hybrid.
highboost = 2;
hybrid = lowfreq + highfreq*highboost;


%Show the resulting hybrid image.
imshow([lowfreq, highfreq*highboost, hybrid]);
pause();
close all;

imwrite(hybrid, 'hybrid.jpg');