clc; clear all;
payloadList=[0.1 0.2 0.3 0.4 0.5];
flag=0;
windowSize=128;
imgRes=256;
folderList=["S-Uniward_50-50_01","S-Uniward_50-50_02","S-Uniward_50-50_03","S-Uniward_50-50_04","S-Uniward_50-50_05","HUGO_50-50_01","HUGO_50-50_02","HUGO_50-50_03","HUGO_50-50_04","HUGO_50-50_05","MG_50-50_01","MG_50-50_02","MG_50-50_03","MG_50-50_04","MG_50-50_05","MiPOD_50-50_01","MiPOD_50-50_02","MiPOD_50-50_03","MiPOD_50-50_04","MiPOD_50-50_05","MVG_50-50_01","MVG_50-50_02","MVG_50-50_03","MVG_50-50_04","MVG_50-50_05","WOW_50-50_01","WOW_50-50_02","WOW_50-50_03","WOW_50-50_04","WOW_50-50_05"];
pixelDistribution = containers.Map(folderList,0.*(1:numel(folderList)));
data=strings(numel(folderList),imgRes/windowSize*2+1);
for fol=1:numel(folderList)
    if flag==1
        break
    end
    data(fol,1)=folderList(fol);
    folderName = convertStringsToChars(folderList(fol));
    fprintf(folderName+"\n");
    payload= single(payloadList(str2num(folderName(numel(folderName)))));
    jpegFiles = dir(fullfile('..','BaseImages')); 
    jpegFiles=jpegFiles(3:end);
    numfiles = numel(jpegFiles);
    %jpegFiles=jpegFiles(randperm(numfiles));
    for k = 1:fix(1) 
        %% Run default embedding
        coverPath=fullfile('..','BaseImages',jpegFiles(k).name);
        if folderName(1:3)=="MG_"
            [stego, pChange, ChangeRate] = MG( coverPath, payload );
        elseif folderName(1:4)=="MVG_"
            [stego, pChange_P, ChangeRate_P] = MVG( coverPath, payload );
        elseif folderName(1:4)=="WOW_"
            params.p = -1;
            [stego, distortion] = WOW(coverPath, payload, params);
        elseif folderName(1:5)=="HUGO_"
            params.gamma = 1;
            params.sigma = 1;
            [stego, distortion] = HUGO_like(coverPath, payload, params);
        elseif folderName(1:6)=="MiPOD_"
            [stego, pChange, ChangeRate] = MiPOD( coverPath, payload );
        elseif folderName(1:10)=="S-Uniward_"
            [stego, distortion]=S_UNIWARD(coverPath, payload);
        else
            fprintf("\n\n\n\n\n\nERROR\n\n\n\n\n\n")
            flag=1;
            break
            %Describir error
        end
        %Analysis(stego);
        cover=imread(coverPath);
        %figure; sgtitle("Stego distribution for "+folderName);
        img=imfuse(cover,stego,'diff');
        %subplot(1, 2, 2); imshow(img); title('embedding changes in white');
        %subplot(1, 2, 1); imshow(cover); title('cover');
        %subplot(1, 2, 2); imshow((double(stego) - double(cover) + 1)/2); title('embedding changes: +1 = white, -1 = black');
        %shg
        pix=pixDist(img,windowSize,imgRes,folderName);
        %figPath=fullfile('..','DataAnalysis',folderName+".png");
        %saveas(gcf,figPath)
    end
    for i=2:imgRes/windowSize*2+1
        data(fol,i)=pix(i-1);
    end
end
data
fprintf("\n\n\nFinished")
%% Saving data
savingPath="Data_windowSize-"+windowSize+".csv";
writematrix(data,fullfile("..","DataAnalysis",savingPath)); 

%% Functions
function result = pixDist(img,windowSize,imgRes,folderName)
    result=zeros(imgRes/windowSize);
    index=1;
    start1=1;
    for axe1 = 1 :imgRes/windowSize
        start2=1;
        end1=axe1*windowSize;
        for axe2 = 1:imgRes/windowSize
            end2=axe2*windowSize;
            imgCropped=img(start1:end1,start2:end2);
            %figure;title(folderName+"  Axe 1: "+axe1+". Axe 2: "+axe2);
            %imshow(imgCropped);title(" FALTA DOCUMENTAR ");
            %shg
            calculatedPayload=histcounts(imgCropped,255:256)/power(windowSize,2);
            start2=end2;
            result(index)=calculatedPayload;
            index=index+1;
        end
    start1=end1;
    end
end