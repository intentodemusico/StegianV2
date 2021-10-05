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

def recall_m(y_true, y_pred):
    true_positives = K.sum(K.round(K.clip(y_true * y_pred, 0, 1)))
    possible_positives = K.sum(K.round(K.clip(y_true, 0, 1)))
    recall = true_positives / (possible_positives + K.epsilon())
    return recall

def precision_m(y_true, y_pred):
    true_positives = K.sum(K.round(K.clip(y_true * y_pred, 0, 1)))
    predicted_positives = K.sum(K.round(K.clip(y_pred, 0, 1)))
    precision = true_positives / (predicted_positives + K.epsilon())
    return precision

def f1_m(y_true, y_pred):
    precision = precision_m(y_true, y_pred)
    recall = recall_m(y_true, y_pred)
    return 2*((precision*recall)/(precision+recall+K.epsilon()))

#%% Importing model
from tensorflow import keras
print("modelo importado")

model = tf.keras.models.load_model('../models/CNNvFinal.h5', custom_objects={"precision_m": precision_m, "f1_m":f1_m,"recall_m":recall_m})
model.summary()
model.compile(loss='binary_crossentropy', optimizer='adam', metrics=['accuracy', f1_m ,precision_m,recall_m])

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
             
        result= pred(imgLocation)
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