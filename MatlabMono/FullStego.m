%% WOW VERSION

%% This script runs a series of embeddings for sampled grayscale images
%% Common procedures
clc; clear all;

%% Listing the Payloads and Folders to use -> Folders makes reference to the different combination between Payload and the embedding Algorithm

format longg
%% Variables instantiating
% [0.1 0.15 0.2 0.25 0.3] Lista de los peiloads
payloadList=[1.09163953];%[0.40060288 0.57336204 0.74612121 0.91888037 1.09163953];                                              %% List of selected payloads, which will be used by index-selection depending on the last two digits from the selected folder in folderList %%
% Para s uniward [0.45441143 0.63955343 0.82469543 1.00983744 1.19497944]

folderList=["WOW_5"];%["WOW_1", "WOW_2", "WOW_3", "WOW_4","WOW_5"];
    
%['S-Uniward_1','S-Uniward_2','S-Uniward_3','S-Uniward_4','S-Uniward_5'];

params.p = -1;

%% Processing
for folderIndex=1:numel(folderList)                                        %% Running over folderList
    imagesFolder=fullfile('..',"Dataset","Mono","MonoSamples",folderList(folderIndex));
    jpegFiles = dir(imagesFolder); 
    jpegFiles=jpegFiles(3:end);
    jpegFiles=jpegFiles(randperm(numel(jpegFiles)));
    
    folderName=folderList(folderIndex);
    payload = double(payloadList(folderIndex));
    %fprintf(folderName+" "+payload);
    
    for imgIndex = 1:1%fix(numel(jpegFiles)/2)+1
        % Run default embedding
        coverPath=fullfile(imagesFolder,jpegFiles(imgIndex).name);
        cover=imread(coverPath);
        coverPath=fullfile(jpegFiles(imgIndex).name);
        %imagesFolder
        stegoPath=fullfile("stego_"+jpegFiles(imgIndex).name); %Falta imagesFolder
        % WOW EMBEDDING
        [stego, distortion] = WOW(cover, payload, params);

        % Embeding S-Uniward stego = S_UNIWARD(coverPath, payload);
        
        % Saving
        %figure;
        %subplot(1, 2, 1); imshow(cover); title('cover');
        %subplot(1, 2, 2); imshow((double(stego) - double(cover) + 1)/2); title('embedding changes: +1 = white, -1 = black');
        imwrite(uint8(stego),stegoPath)
        imwrite(uint8(cover),coverPath)
        %delete(coverPath)

    end
    %fprintf("\n");
end

fprintf("\n\n\nFinished")