# -*- coding: utf-8 -*-
"""
Created on Sun Feb 23 19:27:41 2020

Test atributes

@author: INTENTODEMUSICO
"""

import cv2
import os.path
from datetime import datetime
import numpy as np
import scipy.stats as sts
# importing library for plotting 
from matplotlib import pyplot as plt 
import univariate as univariate
from scipy.stats.mstats import gmean
from pandas import DataFrame
from tensorflow import keras
import pandas as pd
from sklearn.preprocessing import StandardScaler
model = keras.models.load_model('my_model.h5')

def hjorth_params(trace):
    return univariate.hjorth(trace)

predT=0
i=1
save_path='./csv'

for i in range(1,11):
    imgLocation="test_steg_0.5_"+str(i)+".bmp"
    img = cv2.imread(imgLocation,0)
      
    
    #Preprocessing
    #If image is monochromatic
    hist = cv2.calcHist([img],[0],None,[256],[0,256])
    #Else 
    #Gray scale
    
    trace=hist.reshape(256)
    gTrace=trace[trace!=0]
    
    #Getting atributes
    atributes=np.zeros(8)
    
    #Kurtosis 
    atributes[0]='%.7f'%sts.kurtosis(hist)
    #Skewness
    atributes[1]='%.7f'%sts.skew(hist)
    #Std
    atributes[2]='%.7f'%np.std(hist)
    #Range
    atributes[3]='%.7f'%np.ptp(hist)
    #Median 
    atributes[4]='%.7f'%np.median(hist)
    #Geometric_Mean 
    atributes[5]='%.7f'%gmean(gTrace)
    #Hjorth
    a,mor, comp= hjorth_params(trace)
    #Mobility 
    atributes[6]='%.7f'%mor
    #Complexity
    atributes[7]='%.7f'%comp

    ##Saving image atributes in csv -> guardo nombre con timestamp en csv/$csvName
    csvName=str(datetime.now()).split(" ")[0]+"_"+str(datetime.now()).split(" ")[1].split(".")[0]+".csv"
    
    #saveCsv="csv/"+str(csvName)
    csvName=imgLocation[:-4]+csvName.replace(":","-")
    completeName = os.path.join(save_path, csvName)         

    np.savetxt(completeName,atributes, delimiter=",")
    #result= pred(saveCsv)
    
    dataset = pd.read_csv(completeName)
    X = dataset.iloc[:, :].values
    sc = StandardScaler()
    X = np.transpose(sc.fit_transform(X))
    
    #print(X)
    pred=model.predict(X)
    print(pred[0][0])
    predT+=pred
    #print(pred)
print("Total verdaderos positivos:",predT)