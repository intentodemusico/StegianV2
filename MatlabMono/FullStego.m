%% This script runs a series of embeddings for sampled grayscale images
%% Common procedures
clc; clear all;

%% Listing the Payloads and Folders to use -> Folders makes reference to the different combination between Payload and the embedding Algorithm

clc; clear all;
%% Variables instantiating
payloadList=[0.22784372 0.40060288 0.57336204 0.74612121 0.91888037 1.09163953];                                              %% List of selected payloads, which will be used by index-selection depending on the last two digits from the selected folder in folderList %%

errorFlag=0;                                                               %% This flag keeps the error state of the code: 1 for error encountered, 0 for no bad news %%

imagesFolder="MonoImagesCropped";

imgRes=128;                                                                %% This variable refers to the imgRes*imgRes*3 image resolution %%

imgCount=100; %5K img                                                       %% This is the number of images to be analyzed %%

dataFolderName="PresumablePayloads_WOW"+imgRes+"_"+imgCount+"-images"; 
mkdir(fullfile("..","DataAnalysis","Mono",dataFolderName));

folderList=["WOW_01"];%"HUGO_01", ...%"HUGO_02","HUGO_03","HUGO_04","HUGO_05", ...
    %"MG_01", %"MiPOD_01","MVG_01","MVG_02", ...
    

%folderList=["MG_01","MG_02","MG_03","MG_04","MG_05"];

pixelDistribution = containers.Map(folderList,0.*(1:numel(folderList)));
data=strings((numel(folderList)*imgCount)*numel(payloadList)+1,imgRes /windowSize*2+7); % cantidad de windows por imagen
jpegFiles = dir(fullfile('..',imagesFolder)); 
jpegFiles=jpegFiles(3:end);
numfiles = numel(jpegFiles);
%jpegFiles=jpegFiles(randperm(numfiles));
dataIndex=0;

%% Processing
for folderIndex=1:numel(folderList)                                        %% Running over folderList
    if errorFlag==1
        break
    end
    folderName = convertStringsToChars(folderList(mod(folderIndex-1,30)+1));
    
    fprintf(folderName+" ");
    for payloadIndex=1:numel(payloadList)
        payload = single(payloadList(payloadIndex));
    %payload = single(payloadList(str2double(folderName(numel(folderName)))));
    
    % Replacing folder index with the corresponding payload in payloadList
    folderName = convertStringsToChars(strrep(strrep(strrep(strrep(strrep(strrep( ...    
        folderName,"01",num2str(payloadList(1))), "02",num2str(payloadList(2))),"03", ...
        num2str(payloadList(3))),"04",num2str(payloadList(4))),"05",num2str(payloadList(5))),"_"," "));

    %fprintf(" "+payload+" ");
    for imgIndex = 1:fix(imgCount)
        dataIndex=dataIndex+1;
        data(dataIndex,1)=folderList(mod(folderIndex-1,30)+1)+dataIndex;
        %fprintf(" Index: "+dataIndex+" Img: "+imgIndex+".");
        
        % Run default embedding
        coverPath=fullfile('..',imagesFolder,jpegFiles(imgIndex).name);
        cover=double(imread(coverPath));
        %tic
        if folderName(1:2)=="MG"
            [stego, pChange, ChangeRate] = MG( coverPath, payload );
        elseif folderName(1:3)=="MVG"
            [stego, pChange_P, ChangeRate_P] = MVG( coverPath, payload );
        elseif folderName(1:3)=="WOW"
            params.p = -1;
            [stego, distortion] = WOW(cover, payload, params);
        elseif folderName(1:4)=="HUGO"
            params.gamma = 1;
            params.sigma = 1;
            [stego, distortion] = HUGO_like(coverPath, payload, params);
        elseif folderName(1:5)=="MiPOD"
            [stego, pChange, ChangeRate] = MiPOD( coverPath, payload );
        elseif folderName(1:9)=="S-Uniward"
             stego = S_UNIWARD(coverPath, payload);
        else
            fprintf("\n\n\n\n\n\nERROR: Got "+folderName+" as a folder name, it doesn't fit in the requirements. Try checking string/chars errors.\n\n\n\n\n\n")
            errorFlag=1;
            break
        end
        %toc
        img=imdiff(cover,stego);%imfuse(cover,stego,'diff');
        
        % Plot lines ############################################################################
        %figure; sgtitle("Stego distribution for "+strrep(folderName,"_"," ")+ " image "+imgIndex);
       % subplot(1, 3, 1); imshow(cover); title('cover');
       % subplot(1, 3, 2); imshow(stego); title('stego');
        % ########################################################################################
        
        pix=pixDist(img,windowSize,imgRes,imgIndex,dataIndex,payload);
        
        % Plot lines #############################################################################
        %figPath=fullfile('..','DataAnalysis',dataFolderName,"fullComparison_"+folderName+"_img-"+imgIndex+".png");
        %shg
        %saveas(gcf,figPath)
        %#########################################################################################
        
        for i=2:imgRes/windowSize*2+7
            data(dataIndex,i)=pix(i-1);
        end
    end
    end
    %fprintf("\n");
end

% Data
data(end,1)="Algorithm";
data(end,2)="Image index";
data(end,end-1)="Calculated payload";
data(end,end-2)="Payload";
data(end,end-3)="Changes count";
data(end,end-4)="Altered pixel count";
data(end,end)="Data index";

for i = 1:imgRes/windowSize*2
    data(end,i+2)="Window #"+i;
end

data
fprintf("\n\n\nFinished")


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
%% Running default embedding                                                % Every embedding algorithm has it's own parameters
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