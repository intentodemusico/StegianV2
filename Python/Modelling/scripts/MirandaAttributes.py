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
import pandas as pd
import scipy.stats as sts
import univariate as univariate
import numpy as np
from scipy.stats.mstats import gmean
from pandas import DataFrame

#%%
def hjorth_params(trace):
    return univariate.hjorth(trace)

def attributes(img):
    x,y,z = img.shape
    #Preprocessing
    #If image is monochromatic
    hist = cv2.calcHist([img],[0],None,[256],[0,256])
    #Else 
    #for channel in image, below processing, return 3 atr
    
    trace=hist.reshape(256)
    
    #gTrace=trace[trace>0]
    
    #Getting atributes
    attributes=np.zeros(8)#.astype(object)
    
    #Kurtosis 
    attributes[0]=str(sts.kurtosis(trace))
    #Skewness
    attributes[1]=str(sts.skew(trace))
    #Std
    attributes[2]=str(np.std(trace))
    #Range
    attributes[3]=str(np.ptp(trace))
    #Median 
    attributes[4]=str(np.median(trace))
    #Geometric_Mean 
    attributes[5]=str(gmean(trace))
    #Hjorth
    a,mor, comp= hjorth_params(trace)
    #Mobility 
    attributes[6]=str(mor)
    #Complexity
    attributes[7]=str(comp)
    return attributes