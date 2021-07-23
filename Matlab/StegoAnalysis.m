%% Common procedures
clc; clear all;
%% Variables instantiating
payloadList=[0.8 0.99 1 2 3];                                              %% List of selected payloads, which will be used by index-selection depending on the last two digits from the selected folder in folderList %%

errorFlag=0;                                                               %% This flag keeps the error state of the code: 1 for error encountered, 0 for no bad news %%

windowSize=256;                                                            %% This variable is used to manually select the window size that will be used for the analysis %%

imgRes=256;                                                                %% This variable refers to the imgRes*imgRes*3 image resolution %%

imgCount=1; %5K img                                                        %% This is the number of images to be analyzed %%

dataFolderName="Stego-Cover_Comparison_imageRes-"+imgRes+"_windowSize-"+windowSize+"_"+imgCount+"-images"; 

folderList=["S-Uniward_01","S-Uniward_02","S-Uniward_03","S-Uniward_04", ...
    "S-Uniward_05","HUGO_01","HUGO_02","HUGO_03","HUGO_04","HUGO_05", ...
    "MG_01","MG_02","MG_03","MG_04","MG_05","MiPOD_01","MiPOD_02", ...
    "MiPOD_03","MiPOD_04","MiPOD_05","MVG_01","MVG_02","MVG_03", ...
    "MVG_04","MVG_05","WOW_01","WOW_02","WOW_03","WOW_04","WOW_05"];

pixelDistribution = containers.Map(folderList,0.*(1:numel(folderList)));
data=strings(numel(folderList)*imgCount+1,imgRes/windowSize*2+5);
jpegFiles = dir(fullfile('..','BaseImages')); 
jpegFiles=jpegFiles(3:end);
numfiles = numel(jpegFiles);
%jpegFiles=jpegFiles(randperm(numfiles));
dataIndex=0;
%% Running over folderList
for folderIndex=1:numel(folderList)
    if errorFlag==1
        break
    end
    folderName = convertStringsToChars(folderList(mod(folderIndex-1,30)+1));
    
    fprintf(folderName);
    
    payload= single(payloadList(str2double(folderName(numel(folderName)))));

    folderName = convertStringsToChars(strrep(strrep(strrep(strrep(strrep(strrep( ...
        folderName,"01","08"), "02","99"),"03","10"),"04","20"),"05","30"),"_"," "));

    fprintf(" "+payload+" ");
    for imgIndex = 1:fix(imgCount)
        dataIndex=dataIndex+1;
        data(dataIndex,1)=folderList(mod(folderIndex-1,30)+1);
        fprintf(" Index: "+dataIndex+" Img: "+imgIndex+".");
        %% Run default embedding
        coverPath=fullfile('..','BaseImages',jpegFiles(imgIndex).name);
        if folderName(1:2)=="MG"
            [stego, pChange, ChangeRate] = MG( coverPath, payload );
        elseif folderName(1:3)=="MVG"
            [stego, pChange_P, ChangeRate_P] = MVG( coverPath, payload );
        elseif folderName(1:3)=="WOW"
            params.p = -1;
            [stego, distortion] = WOW(coverPath, payload, params);
        elseif folderName(1:4)=="HUGO"
            params.gamma = 1;
            params.sigma = 1;
            [stego, distortion] = HUGO_like(coverPath, payload, params);
        elseif folderName(1:5)=="MiPOD"
            [stego, pChange, ChangeRate] = MiPOD( coverPath, payload );
        elseif folderName(1:9)=="S-Uniward"
            [stego, distortion]=S_UNIWARD(coverPath, payload);
        else
            fprintf("\n\n\n\n\n\nERROR: Got "+folderName+" as a folder name, it doesn't fit in the requirements. Try checking string/chars errors.\n\n\n\n\n\n")
            errorFlag=1;
            break
        end
        cover=imread(coverPath);
        figure; sgtitle("Stego distribution for "+strrep(folderName,"_"," ")+ " image "+imgIndex);
        img=imfuse(cover,stego,'diff');
        subplot(1, 3, 1); imshow(cover); title('cover');
        subplot(1, 3, 2); imshow(stego); title('stego');
        pix=pixDist(img,windowSize,imgRes,imgIndex,dataIndex,payload,folderName);
        figPath=fullfile('..','DataAnalysis',dataFolderName,"fullComparison_"+folderName+".png");
        shg
        saveas(gcf,figPath)
        for i=2:imgRes/windowSize*2+5
            data(dataIndex,i)=pix(i-1);
        end
    end
    fprintf("\n");
end
data(end,1)="Algorithm-payload tuple";
data(end,2)="Image index";
data(end,end-1)="Calculated payload";
data(end,end-2)="Payload";
data(end,end)="Data index";
for i = 1:imgRes/windowSize*2
    data(end,i+2)="Window #"+i;
end
data
fprintf("\n\n\nFinished")
%% Saving data
savingPath="Data_imageRes-"+imgRes+"_windowSize-"+windowSize+".csv";
writematrix(data,fullfile("..","DataAnalysis",dataFolderName,savingPath)); 

%% Functions
function result = pixDist(img,windowSize,imgRes,imageIndex,dataIndex,pay,folderName)
    result=zeros(1,imgRes/windowSize*2+4);
    result(end-2)=pay;
    result(1)=imageIndex;
    result(end)=dataIndex;
    windowIndex=2;
    start1=1;
    for axe1 = 1 :imgRes/windowSize
        start2=1;
        end1=axe1*windowSize;
        for axe2 = 1:imgRes/windowSize
            end2=axe2*windowSize;
            imgCropped=img(start1:end1,start2:end2);
            disp("Vainas TEST: start1,end1,start2,end2,sum img normal, sum img cropped, sum count con histcounts");
            disp(start1); disp(end1); disp(start2); disp(end2); disp(sum(sum(img==255))); disp(sum(sum(imgCropped==255)));
            count=histcounts(imgCropped,255:256);
            disp(count);
            
%            disp(count);
%            disp(sum(sum(img==255))/(sum(sum(img==255))+sum(sum(img==0))));
%            disp((sum(sum(img==255))+sum(sum(img==0))));
            calculatedPayload=count/power(windowSize,2);
            subplot(1, 3, 3); imshow(img); title("embedding count: "+count); % For keeping stegoCount
            start2=end2;
            result(windowIndex)=calculatedPayload;
            result(end-1)=result(end-1)+calculatedPayload;
            windowIndex=windowIndex+1;
        end
    start1=end1;
    end
    %disp(result);
end