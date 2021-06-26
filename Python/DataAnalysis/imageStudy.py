# -*- coding: utf-8 -*-
"""
Created on Thu Mar 25 17:47:05 2021

@author: INTENTODEMUSICO
"""
#% This script plots the images resolution distribution
import cv2,random,os,shutil
from matplotlib import pyplot as plt
import seaborn as sns
res=[]
siz=[]
#% Getting the list of images resolution
def resImg(path):
    img = cv2.imread(path)
    y,x,r=img.shape
    res.append(str(x)+"x"+str(y))
    siz.append(x*y)

files=os.listdir("./sample/full")
for f in files:
    resImg("./sample/full/"+f)

# An "interface" to matplotlib.axes.Axes.hist() method

sns.histplot(res)

# Set a clean upper y-axis limit.