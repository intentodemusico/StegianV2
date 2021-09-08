%% Common procedures avanzar de 0.5 en 0.5 con 100 img
clc; clear all;
%% Variables instantiating

imagesFolder="Dataset/Mono/MonoSamples/S-Uniward_5";
payloadList=(1:20) *0.05;
jpegFiles = dir(fullfile('..',imagesFolder)); 
jpegFiles=jpegFiles(3:19999);
jpegFiles(randperm(numel(jpegFiles)));
wowTime=(1:20) *0;
suniTime=(1:20) *0;
mgTime=(1:20) *0;
mvgTime=(1:20) *0;
hugoTime=(1:20) *0;
mipodTime=(1:20) *0;

%% Processing
for imgIndex=1:100
    coverPath=fullfile('..',imagesFolder,jpegFiles(imgIndex).name);
    cover=double(imread(coverPath));
    for pay=1:numel(payloadList)
        payload=payloadList(pay);
        paramsWow.p = -1;
        params.gamma = 1;
        params.sigma = 1;
        tic
        [stegoWOW, distortion] = WOW(cover, payload, paramsWow);
        wowTime(pay)=wowTime(pay)+toc;
        tic
        stegoSuni = S_UNIWARD(coverPath, payload);
        suniTime(pay)=suniTime(pay)+toc;
        tic
        [stego, pChange, ChangeRate] = MG( cover, payload );
        mgTime(pay)=mgTime(pay)+toc;
        tic
        [stego, pChange_P, ChangeRate_P] = MVG( cover, payload );
        mvgTime(pay)=mvgTime(pay)+toc;
        tic            
        [stego, distortion] = HUGO_like(coverPath, payload, params);
        hugoTime(pay)=hugoTime(pay)+toc;
        tic
        [stego, pChange, ChangeRate] = MiPOD( cover, payload );
        mipodTime(pay)=mipodTime(pay)+toc;
    end
end

wowTime=wowTime/100;
suniTime=suniTime/100;
mgTime=mgTime/100;
mvgTime=mvgTime/100;
hugoTime=hugoTime/100;
mipodTime=mipodTime/100;

fprintf("Finished");

figure; hold on
a1 = plot(payloadList,wowTime); M1 = "WOW";
a2 = plot(payloadList,suniTime); M2 = "S-UNIWARD";
a3 = plot(payloadList,mgTime); M3 = "MG";
a4 = plot(payloadList,mvgTime); M4 = "MVG";
a5 = plot(payloadList,hugoTime); M5 = "HUGO";
a6 = plot(payloadList,mipodTime); M6 = "MiPod";
legend([a1,a2,a3,a4,a5,a6], [M1, M2, M3,M4,M5,M6]);
xlabel('Payload')
ylabel('Time')
title('Time complexity for stego algorithms')
hold off
shg