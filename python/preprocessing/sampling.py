import os, shutil,random
dirs= [x[0] for x in os.walk(".\\train")]
#print("dirs",dirs)
i=0
for y in dirs:
    if(y!=dirs[0]):
        files=os.listdir(y)
        #print("files",files)
        for a in range(130):
            index=random.randint(0,len(files)-1)
            f=files.pop(index)
            while(f=="Test.py" or '.\\'+f in dirs):
                f=files.pop(index)
            #print(i,f)
            shutil.copy(y+'\\'+f,'.\\sample\\full\\'+str(i)+'_'+f)
            #print(i,f)
        i+=1
        
