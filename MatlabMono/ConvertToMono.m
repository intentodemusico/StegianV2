%% Common procedures avanzar de 0.5 en 0.5 con 100 img
clc; clear all;
%% Variables instantiating
imagesFolder="MonoSamples";
jpegFiles = dir(fullfile('..',imagesFolder)); 
jpegFiles=jpegFiles(3:end);

%% Processing
for i=1:numel(jpegFiles)
    impath=fullfile('..',imagesFolder,jpegFiles(i).name);
    imwrite(rgb2gray(imread(impath)),fullfile('..',imagesFolder,jpegFiles(i).name));
end
fprintf("Finished");