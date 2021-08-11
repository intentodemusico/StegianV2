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



COSA


%% Common procedures
clc; clear all;
%% Variables instantiating
imagesFolder="MonoImages";
jpegFiles = dir(fullfile('..',imagesFolder)); 
jpegFiles=jpegFiles(3:end);

%% Processing
for i=1:numel(jpegFiles)
    impath=fullfile('..',imagesFolder,jpegFiles(i).name);
    imwrite(rgb2gray(imread(impath)),fullfile('..',imagesFolder,jpegFiles(i).name));
end
fprintf("Finished");

def cropImage(path):
    img = cv2.imread(path)
    y,x,r=img.shape
    if(x<128 or y<128):
        os.remove(path)
        return False
    h=random.randint(0,y-128)
    w=random.randint(0,x-128)
    crop_img = img[h:h+128, w:w+128]
    plt.imsave(path,cv2.cvtColor(crop_img, cv2.COLOR_BGR2RGB))
    return True