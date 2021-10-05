#!/usr/bin/python
#%% Libraries
from __future__ import absolute_import, division, print_function, unicode_literals
import os, cv2
from datetime import datetime
import pandas as pd
import tensorflow as tf
import scipy.stats as sts
import univariate as univariate
from sklearn.preprocessing import StandardScaler
import numpy as np
from scipy.stats.mstats import gmean
from pandas import DataFrame
print("TensorFlow version: {}".format(tf.__version__))
print("Eager execution: {}".format(tf.executing_eagerly()))

#%%
from flask import request, url_for, jsonify
from flask_api import FlaskAPI, status, exceptions
from flask_cors import CORS, cross_origin

#%% Importing model
from tensorflow import keras
model = keras.models.load_model('my_model.h5')
print("modelo importado")


#%%
def pred(csvName):
    dataset = pd.read_csv(csvName, header=None)
    X = dataset.iloc[:].values
    sc = StandardScaler()
    X = np.transpose(sc.fit_transform(X))
    #%%
    res=model.predict(X)
    print("Resultado obtenido")
    print(res,res>0.1)
    return res
    

#%%
def hjorth_params(trace):
    return univariate.hjorth(trace)

def attributes(location):
    img = cv2.imread(location,0)
      
    #Preprocessing
    #If image is monochromatic
    hist = cv2.calcHist([img],[0],None,[256],[0,256])
    #Else 
    #Gray scale
    
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

save_path='./csv'
#%%
app = FlaskAPI(__name__)
cors = CORS(app)


UPLOAD_FOLDER = 'uploads/'
ALLOWED_EXTENSIONS = set(['bmp', 'png', 'jpg', 'jpeg', 'gif'])
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER


app.config['CORS_HEADERS'] = 'Content-Type'

@app.route("/")
def index():
    return "If you're using this API through the 80 port, you're on testing -> /API/image/ para subir mediante un post -> el resultado se entregará en la cabecera de respuesta"

@app.route("/API/image/", methods=['GET', 'POST'])
@cross_origin()
def result():
    if request.method == "POST":        
        #Get image from request
        if not 'file' in request.files:
            return jsonify({'error': 'no file'}), 400
        
        # Image info
        img_file = request.files.get('file')
        img_name = img_file.filename
        mimetype = img_file.content_type
        # Return an error if not a valid mimetype
        #if not mimetype in valid_mimetypes:
        #    return jsonify({'error': 'bad-type'}),406
        # Write image to static directory
        imgLocation=os.path.join("./UPLOAD_FOLDER", img_name)
        img_file.save(imgLocation)
        
        attr=attributes(imgLocation)
        
        ##Saving image atributes in csv -> guardo nombre con timestamp en csv/$csvName
        csvName=str(datetime.now()).split(" ")[0]+"_"+str(datetime.now()).split(" ")[1].split(".")[0]+".csv"
        
        #saveCsv="csv/"+str(csvName)
        csvName=img_name[:-4]+csvName.replace(":","-")
        completeName = os.path.join(save_path, csvName)        
        np.savetxt(completeName,attr, delimiter=",")
        result= pred(completeName)
        #result=random.uniform(0,1) 
        data={'result': str(result)} 
        
        # Delete image when done with analysis
        os.remove(imgLocation)
       
        return jsonify(data), 200 #if no hay error, else jaja
    return("ERROR: Hola, debe utilizar POST con su imagen y leer la respuesta","400")

#%%
#OJO, SOLO PARA PRUEBAS ES EL PUERTO 80
#app.run(host="0.0.0.0", port=2012)
app.run(host="0.0.0.0", port=2012)