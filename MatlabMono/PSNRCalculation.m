%% Common procedures avanzar de 0.5 en 0.5 con 100 img
clc; clear all;
%% Variables instantiating

imagesFolder="Dataset/Mono/MonoSamples/S-Uniward_5";
payloadList=(1:20) *0.05;
jpegFiles = dir(fullfile('..',imagesFolder)); 
jpegFiles=jpegFiles(3:19999);
jpegFiles(randperm(numel(jpegFiles)));
wowPSNR=0;
suniPSNR=0;
%% Processing
for imgIndex=1:200
    coverPath=fullfile('..',imagesFolder,jpegFiles(imgIndex).name);
    cover=double(imread(coverPath));
    for pay=1:numel(payloadList)
        payload=payloadList(pay);
        params.p = -1;
        [stegoWOW, distortion] = WOW(cover, payload, params);
        stegoSuni = S_UNIWARD(coverPath, payload);
        wowPSNR=wowPSNR+psnr(stegoWOW,cover);
        suniPSNR=suniPSNR+psnr(stegoSuni,cover);
    end
end
suniPSNR=suniPSNR/4000;
wowPSNR=wowPSNR/4000;

fprintf('\n The Peak-SNR value for S-UNIWARD is %0.3f', suniPSNR);
fprintf('\n The Peak-SNR value for S-UNIWARD is %0.3f', wowPSNR);
fprintf("Finished");