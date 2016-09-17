%----------------Hybrid Image Creator---------------
%Author: Alexander Pinkerton
%Date: 9/17/2016
%-------------------------------------------------------
%This function will allow the creation of hybrid images via the cropping
%the DFT of an image. Lowpass, highpass, bandpass, and bandstop are all
%supported. Specify the type and the cutoff values.
%-------------------------------------------------------

% img1 = imread('marilyncrop.jpg');10
% img2 = imread('einstiencrop.jpg');2
% img2 = imread('ladybugcrop.jpg');15
% img1 = imread('applecrop.jpg');2
% img1 = imread('mjcrop1.jpg');10
% img2 = imread('mjcrop2.jpg');2

%Extract low frequency features.
lowfreq = fftfilter(img1, 10, 'lowpass');
%Extract high frequency features.
highfreq = fftfilter(img2, 2, 'highpass');

% %Extract band frequency features.
% bandfreq = fftfilter(img1, [50 100], 'bandpass');

%Resize the images to be the same, Use smallest for max quality.
outSize = min(size(img1),size(img2));
lowfreq = imresize(lowfreq, [outSize(1) outSize(2)]);
highfreq = imresize(highfreq, [outSize(1) outSize(2)]);

%Add the two images together to produce the hybrid.
hybrid = lowfreq + highfreq;


%Show the resulting hybrid image.
imshow([lowfreq, highfreq, hybrid]);
pause();
close all;

imwrite(hybrid, 'hybrid.jpg');


