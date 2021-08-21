%% S-UNIWARD VERSION

%% This script runs a series of embeddings for sampled grayscale images
%% Common procedures
clc; clear all;

%% Listing the Payloads and Folders to use -> Folders makes reference to the different combination between Payload and the embedding Algorithm

format longg
%% Variables instantiating
% [0.1 0.15 0.2 0.25 0.3] Lista de los peiloads
payloadList=[0.45441143 0.63955343 0.82469543 1.00983744 1.19497944]                                              %% List of selected payloads, which will be used by index-selection depending on the last two digits from the selected folder in folderList %%
% Para s uniward 

folderList=["S-Uniward_1","S-Uniward_2","S-Uniward_3","S-Uniward_4","S-Uniward_5"];
    
%['S-Uniward_1','S-Uniward_2','S-Uniward_3','S-Uniward_4','S-Uniward_5'];

params.p = -1;

%% Processing
for folderIndex=1:numel(folderList)                                        %% Running over folderList
    imagesFolder=fullfile('..',"Dataset","Mono","readySamples",folderList(folderIndex));
    jpegFiles = dir(imagesFolder); 
    jpegFiles=jpegFiles(3:end);
    jpegFiles=jpegFiles(randperm(numel(jpegFiles)));
    
    folderName=folderList(folderIndex);
    payload = double(payloadList(folderIndex));
    %fprintf(folderName+" "+payload);
    
    for imgIndex = 1:fix(numel(jpegFiles)/2)
        % Run default embedding
        coverPath=fullfile(imagesFolder,jpegFiles(imgIndex).name);
        cover=imread(coverPath);
        stegoPath=fullfile(imagesFolder,"stego_"+jpegFiles(imgIndex).name); %Falta imagesFolder
        stego = S_UNIWARD(coverPath, payload);

        % Embeding S-Uniward 
        
        % Saving
        %figure;
        %subplot(1, 3, 1); imshow(uint8(cover)); title('cover');
        %subplot(1, 3, 2); imshow(uint8(stego)); title('stego');
        %subplot(1, 3, 3); imshow((double(stego) - double(cover) + 1)/2); title('embedding changes: +1 = white, -1 = black');
        
%       shg
%       size(uint8(stego))
        imwrite(uint8(stego),stegoPath)
        delete(coverPath)

    end
    %fprintf("\n");
end

fprintf("\n\n\nFinished")