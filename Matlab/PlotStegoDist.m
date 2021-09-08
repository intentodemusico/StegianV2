%% WOW and S-UNIWARD VERSION

%% This script runs a series of embeddings for sampled colorful images
%% Common procedures
clc; clear all;

%% Listing the Payloads and Folders to use -> Folders makes reference to the different combination between Payload and the embedding Algorithm

format longg
%% Variables instantiating
suniwardPayload=1.19497944;
wowPayload=1.09163953;
folder="ColorSamples\VirginSample";
params.p = -1;

%% Processing
imagesFolder=fullfile('..',folder);
jpegFiles = dir(imagesFolder); 
jpegFiles=jpegFiles(3:end);

for imgIndex = 1:1%fix(numel(jpegFiles)/2)+1
    % Run default embedding
    coverPath=fullfile(imagesFolder,jpegFiles(imgIndex).name);
    cover=imread(coverPath);
    coverPath=fullfile(jpegFiles(imgIndex).name);
    % WOW EMBEDDING
    [stegoWow, distortion] = WOW(cover, wowPayload, params);

    % Embeding S-Uniward 
    stegoS_Uniward = S_UNIWARD(cover, suniwardPayload);

    % Saving
    figure;sgtitle("Stego distribution for WOW 0.3");
    subplot(1, 2, 1); imshow(cover); title('cover');
    dif=imdiff(stegoWow,cover);
    subplot(1, 2, 2); imshow(dif); title('Embedding changes');
    shg
    
    figure; sgtitle("Stego distribution for S-UNIWARD 0.3");
    subplot(1, 2, 1); imshow(cover); title('cover');
    dif=imdiff(stegoS_Uniward,cover);
    subplot(1, 2, 2); imshow(dif); title('Embedding changes');
    shg
end

function aPCount = alteredPixelCount(img)
    aPCount=sum(sum(sum(img>0)));
end

function cCount = changeCount(img)
    cCount=sum(sum(img));
end

function diff = imdiff(stego,cover)
    diff=abs(cover-stego)*256;
end