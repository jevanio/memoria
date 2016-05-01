#!/usr/bin/env python
# -*- coding: utf-8 -*-
# El siguiente archivo genera el word-count vector para un dataset dado
# Recorre por completo la raiz del directorio buscando archivos
# Se toman las X palabras más frecuentes para el largo del TF.
# Para cada archivo:	
# 	- Elije una palabra del archivo vocab_freq.
#	- Contar la frecuencia de dicha palabra en el archivo.
#	- Elegir siguiente palabra.
# Al finalizar, añadir TF a fichero tf_%s.mat.
# Comando: python make_word_count.py Ruta_Dataset/ tipo_Dataset (test/train) Tamaño_tf

import string
import sys
import numpy as np
import scipy.io as sio
from os import walk
from collections import Counter

def error(message):
    sys.stderr.write("Error: %s\npython make_word_count.py Ruta_Dataset/ tipo_Dataset (test/train) Tamaño_tf\n  " % message)
    sys.exit(1)

if len(sys.argv) <> 4:
	error('Faltan parámetros')

if sys.argv[2] <> "test" and sys.argv[2] <> "train":
	error('Error, Segundo parámetro debe ser test o train')

if sys.argv[2] == "test":
	file_map = open("test.map",'w')
	file_label = open("test.label",'w')
else:
	file_map = open("train.map",'w')
	file_label = open("train.label",'w')


i=1
lab_num =1
# Crea el archivo word_count segun las palabras unicas encontradas.
vocab_freq = file("vocab", "rb").read().split()[-int(sys.argv[3]):]

#data_word_count = open(sys.argv[1] + "word_count", "w")
for (path, ficheros, archivos) in walk(sys.argv[1]):
	if len(archivos)>0:
		for archivo in archivos:
			print '%d) ' %i + path + '/' + archivo
			text = file(path + "/" + archivo, "r").read()
			
			# Elimina numeros del texto
			text = ''.join([j for j in text if not j.isdigit()])

			# Elimina elementos unicode no legibles
			text = "".join([x if 31 < ord(x) < 128 else '?' for x in text])

			# Elimina puntuacion del texto
			for c in string.punctuation:
				text= text.replace(c," ")

			# Elimina palabras de largo menor a 3
			text = ' '.join(word for word in text.split() if len(word)>3)

			# Convertir todo el texto en minusculas
			text = text.lower()

			if i>1:
				tf = np.append(tf,[[text.count(w) for w in vocab_freq]],axis=0)
			else:
				tf = np.matrix([text.count(w) for w in vocab_freq])

			i=i+1
			file_label.write(str(lab_num) + "\n")
		categoria=path.split('/')[-1]
		file_map.write(categoria + " " + str(lab_num)+ "\n")
		lab_num=lab_num+1
file_label.close()
file_map.close()

sio.savemat('../Matlab/tf_%s.mat' % sys.argv[2], {'tf':tf})