clc; clear all;
format longg

folderList=["WOW_1", "WOW_2", "WOW_3", "WOW_4","WOW_5"];
imagesFolder=fullfile('..',"Dataset","Mono","readySamples",folderList(1));
jpegFiles = dir(imagesFolder); 
jpegFiles=jpegFiles(3:end);
jpegFiles=jpegFiles(randperm(numel(jpegFiles)));
coverPath=fullfile(imagesFolder,jpegFiles(1).name);

cover=imread("testImage.JPEG");
% set payload
payload = 0.40060288;

% set params
params.p = -1;  % holder norm parameter

fprintf('Embedding using matlab code');
MEXstart = tic;

%% Run embedding simulation
[stego, distortion] = WOW(cover, payload, params);
        
MEXend = toc(MEXstart);
fprintf(' - DONE');

figure;
subplot(1, 2, 1); imshow(cover); title('cover');
subplot(1, 2, 2); imshow(uint8(stego));%imshow((double(stego) - double(cover) + 1)/2); title('embedding changes: +1 = white, -1 = black');
fprintf('\n\nImage embedded in %.2f seconds, change rate: %.4f, distortion per pixel: %.6f\n', MEXend, sum(cover(:)~=stego(:))/numel(cover), distortion/numel(cover));