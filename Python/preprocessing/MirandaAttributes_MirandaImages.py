r"""
==================================================
#######################
DISCLAIMER:
Miranda images version, DO NOT USE THIS. This has been retrieved from the lousy stegonomono code, use standard instead.
######################

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
from scipy.stats.mstats import gmean
from scipy.spatial.distance import cdist, euclidean

#%% Custom Hjorth params
def hjorth_params(trace):
    first_deriv = np.diff(trace)
    second_deriv = np.diff(trace,2)

    var_zero = np.var(trace)
    var_d1 = np.var(first_deriv)
    var_d2 = np.var(second_deriv)

    activity = var_zero
    mobility = np.sqrt(var_d1 / var_zero)
    complexity = np.sqrt(var_d2 / var_d1) / mobility

    return activity, mobility, complexity

def calCustom(location,kind):
    #Preprocessing
    #If image is mono, 0 is passed as channel, else, every channel will be passed independently
    img = cv2.imread(location,0)
    hist = cv2.calcHist([img],[0],None,[256],[0,256])
    
    trace=hist.reshape(256)
    
    #Custom trace for avoiding zero log error CHECK THIS PLS
    gTrace=trace[trace!=0]
    

    #Getting atributes
    attributes=[0]*10
    
    #Kurtosis 
    attributes[0]=sts.kurtosis(hist,fisher=False)
    #Skewness
    attributes[1]=sts.skew(trace)
    #Std
    attributes[2]=np.std(trace)
    #Range
    attributes[3]=np.ptp(trace)
    #Median 
    attributes[4]=np.median(trace)
    #Garcia-Geometric_Mean 
    attributes[5]=gmean(gTrace)
    #Epsilon Geometric_Mean
    attributes[6]=gmean(trace+1)
    #Hjorth
    act,mob, comp= hjorth_params(trace)
    #Mobility 
    attributes[7]=mob
    #Complexity
    attributes[8]=comp
    
    attributes[9]=str(kind)
    return attributes