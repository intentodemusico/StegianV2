%% Common procedures avanzar de 0.5 en 0.5 con 100 img
clc; clear all;
%% Variables instantiating
payloadList=[0.22784372 0.40060288 0.57336204 0.74612121 0.91888037 1.09163953];                                              %% List of selected payloads, which will be used by index-selection depending on the last two digits from the selected folder in folderList %%

errorFlag=0;                                                               %% This flag keeps the error state of the code: 1 for error encountered, 0 for no bad news %%

windowSize=256;                                                            %% This variable is used to manually select the window size that will be used for the analysis %%

imagesFolder="MonoImages";

imgRes=256;                                                                %% This variable refers to the imgRes*imgRes*3 image resolution %%

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
%% Saving data
savingPath="Data_imageRes-"+imgRes+".csv";
writematrix(data,fullfile("..","DataAnalysis","Mono",dataFolderName,savingPath)); 

%% Functions
function result = pixDist(img,windowSize,imgRes,imageIndex,dataIndex,pay)
    result=zeros(1,imgRes/windowSize*2+6);
    result(end-2)=pay;
    result(1)=imageIndex;
    result(end)=dataIndex;
    windowIndex=2;
    start1=1;
    for axe1 = 1 :imgRes/windowSize %% Lo de imgres y eso arreglar con cantidad de windows y eso
        start2=1;
        end1=axe1*windowSize;
        for axe2 = 1:imgRes/windowSize
            end2=axe2*windowSize;
            imgCropped=img(start1:end1,start2:end2); %Now there's 1 channel
            count=alteredPixelCount(imgCropped); %Now there's 1 channel
            result(end-3)=changeCount(img);
            calculatedPayload=count/power(windowSize,2);
            
            % Plot line
            %subplot(1, 3, 3); imshow(img*127); title("count: "+count+" payload:"+calculatedPayload); % For keeping stegoCount
            % Plot line #######################################################################
            
            result(end-4)=count;
            start2=end2;
            result(windowIndex)=calculatedPayload;
            result(end-1)=result(end-1)+calculatedPayload;
            windowIndex=windowIndex+1;
        end
    start1=end1;
    end
    %disp(result);
end

function aPCount = alteredPixelCount(img)
    aPCount=sum(sum(img>0));
end

function cCount = changeCount(img)
    cCount=sum(sum(img));
end

function diff = imdiff(stego,cover)
    diff=abs(cover-stego);
end