%% Common procedures avanzar de 0.5 en 0.5 con 100 img
clc; clear all;
%% Variables instantiating
imagesFolder="Test";
jpegFiles = dir(fullfile(imagesFolder)); 
jpegFiles=jpegFiles(3:end);

impath=fullfile(imagesFolder,jpegFiles(1).name);
%% Processing
for i=1:9
    disp(i)
    figure()
    name=i+".jpeg";
    img=imread(impath)+1;
    imwrite(img,"D:\StegianV2\StegianV2\MatlabMono\Test\"+name);
    shg
end
fprintf("Finished");