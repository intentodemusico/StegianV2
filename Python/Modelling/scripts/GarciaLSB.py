r"""
==================================================
Custom LSB, Mono by now

Implemented by Alberto García - intentodemusico

==================================================
TODO documentation

"""


__author__ = 'intentodemusico'
#%% Libraries
from itertools import product
from random import shuffle
from copy import copy
def LSB(pixel):
    pixelBin=bin(pixel)
    pixelBinList=pixelBin.split("b")
    newBit=str(abs(int(pixelBin[-1])-1))
    newValue=pixelBinList[-1][:-1]+newBit
    ret="b".join([pixelBinList[0],newValue])
    return int(ret,2)
def Stego(cover,payload,color=False,channel=-1,getChanges=False):
    steg=copy(cover)
    if(color or cover.shape[-1]==3):
        print("To-Do, sorry...")
        raise Exception('Only mono has been implemented, please be patient, sorry. In case your image is mono, try reading it with matplotlib.image.')
    pixCount=cover.shape[0]*cover.shape[1]
    changes=int(pixCount*payload)
    positionList=list(product(list(range(cover.shape[0])),list(range(cover.shape[1]))))
    if(changes>len(positionList)):
        raise Exception('Too big payload, for avoiding double write of LSB, max payload is 1')
    shuffle(positionList)
    for change in range(changes):
        posy,posx=positionList[change]
        steg[posy,posx]=LSB(cover[posy,posx])
    if(getChanges):
        return steg, changes
    return steg
def diff(cover,stego):
    ret=stego-cover
    ret[ret<1]=128
    return ret