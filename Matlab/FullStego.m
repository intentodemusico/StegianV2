%% This script runs a series of customized embeddings for random single-channel selection
%% Listing the Payloads and Folders to use -> Folders makes reference to the different combination between Payload and the embedding Algorithm
clc; clear all;
payloadList=[0.1 0.2 0.3 0.4 0.5];
flag=0;                                                                     % Flag for breaking the loop in case of error
folderList=['S-Uniward_50-50_01','S-Uniward_50-50_02','S-Uniward_50-50_03','S-Uniward_50-50_04','S-Uniward_50-50_05','HUGO_50-50_01','HUGO_50-50_02','HUGO_50-50_03','HUGO_50-50_04','HUGO_50-50_05','MG_50-50_01','MG_50-50_02','MG_50-50_03','MG_50-50_04','MG_50-50_05','MiPOD_50-50_01','MiPOD_50-50_02','MiPOD_50-50_03','MiPOD_50-50_04','MiPOD_50-50_05','MVG_50-50_01','MVG_50-50_02','MVG_50-50_03','MVG_50-50_04','MVG_50-50_05','WOW_50-50_01','WOW_50-50_02','WOW_50-50_03','WOW_50-50_04','WOW_50-50_05'];
%% Loop embedding the selected Payload with the selected Algorithm 
for fol=1:numel(folderList)                                                
    if flag==1
        break
    end
    foldername= folderList(fol)
    payload= single(payloadList(str2num(foldername(numel(foldername)))));   % Needed data conversion for the embedding to work
    jpegFiles = dir(fullfile('..',folderName));                             % Listing images within folder
    jpegFiles=jpegFiles(3:end);                                             % Selecting images without the main path
    numfiles = numel(jpegFiles);
    jpegFiles=jpegFiles(randperm(numfiles));
    for k = 1:fix(numfiles/2) 
%% Run default embedding                                                    % Every embedding algorithm has it's own parameters
        coverPath=fullfile('..',folderName,jpegFiles(k).name);              
        if folderName(1:3)=="MG_"                                           % Selecting embedding algorithm depending on the folder name
            [stego, pChange, ChangeRate] = MG( coverPath, Payload );
        elseif folderName(1:4)=="MVG_"
            [stego, pChange_P, ChangeRate_P] = MVG( coverPath, Payload );
        elseif folderName(1:4)=="WOW_"
            params.p = -1;
            [stego, distortion] = WOW(coverPath, payload, params);
        elseif folderName(1:5)=="HUGO_"
            params.gamma = 1;
            params.sigma = 1;
            [stego, distortion] = HUGO_like(coverPath, payload, params);
        elseif folderName(1:6)=="MiPOD_"
            [stego, pChange, ChangeRate] = MiPOD( coverPath, Payload );
        elseif folderName(1:10)=="S-Uniward_"
            [stego, distortion]=S_UNIWARD(coverPath, payload);
        else                                                                % Breaking loop if any error ocurs
            fprintf("\n\n\n\n\n\nERROR\n\n\n\n\n\n")
            flag=1;
            break
        end
%% Saving files
        stegoPath=strcat('stego_',jpegFiles(k).name);                       % Selecting name and path for processed images
        stegoPath=fullfile('..',folderName,stegoPath);
        imwrite(stego,stegoPath);
        delete(coverPath);                                                  % Avoiding errors
    end
end
fprintf("\n\n\nFinished")