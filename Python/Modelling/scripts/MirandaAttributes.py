r"""
==================================================
Attribute extraction from Miranda's paper [1]

Implemented by Alberto García - intentodemusico

[1] Miranda, Julian & Parada, Diego. (2020). LSB Steganography Detection in Monochromatic Still Images using Artificial Neural Networks. 
==================================================
TODO documentation

"""


__author__ = 'intentodemusico'
#%% Libraries
import cv2
import numpy as np
import pandas as pd
import scipy.stats as sts
from pandas import DataFrame
import univariate as univariate
from scipy.stats.mstats import gmean

#%%
def hjorth_params(trace):
    return univariate.hjorth(trace)

def calculations(img,channel):
    #Preprocessing
    #If image is mono, 0 is passed as channel, else, every channel will be passed independently
    hist = cv2.calcHist([img],[channel],None,[256],[0,256])

    trace=hist.reshape(256)
    
    #Custom trace for avoiding zero log error
    gTrace=trace[trace>0]
    

    #Getting atributes
    attributes=np.zeros(8,dtype=np.longdouble)#.astype(object)
    
    #Kurtosis 
    attributes[0]=sts.kurtosis(trace)
    #Skewness
    attributes[1]=sts.skew(trace)
    #Std
    attributes[2]=np.std(trace)
    #Range
    attributes[3]=np.ptp(trace)
    #Median 
    attributes[4]=np.median(trace)
    #Geometric_Mean 
    attributes[5]=gmean(gTrace)
    #Hjorth
    a,mor, comp= hjorth_params(trace)
    #Mobility 
    attributes[6]=mor
    #Complexity
    attributes[7]=comp
    return attributes

def attributes(img,windowSize):
    if(img.shape(0)/windowSize%1!=0): 
        return False
    windowCount=img.shape(0)/windowSize
    channels=1 if len(img.shape)<2 else 3
    fullAttributes=np.zeros(0,dtype=np.longdouble)
    for channel in range(channels):
        for axe0 in range(windowCount):
            for axe1 in range(windowCount):
                np.append(fullAttributes,calculations(img[windowSize*axe0:windowSize*(axe0+1),windowSize*axe1:windowSize*(axe1+1)],channel))
    return fullAttributes