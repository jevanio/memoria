#!/usr/bin/env python
# -*- coding: utf-8 -*-
# El siguiente archivo almacena en MongoDB el Dataset de test y train
# Recorre por completo la raiz del directorio buscando archivos
# Para cada archivo:
# 	- Filtrar texto, como siempre.
#	- Crear diccionario con Titulo, Corpus, Categoría y Hash
#	- Añade a una lista.
# Sigue hasta tener todos los documentos.
# Al tener todos los documentos, inserta en db.rain.
# Comando: python 20News-to-Mongo.py

import string
import sys
import os
from os import walk
from collections import Counter

import pymongo
from pymongo import MongoClient

client = MongoClient()
db = client.Newsgroups
db.test.drop()
db.train.drop()
test_docs = []
train_docs = []
i=1

for (path, ficheros, archivos) in walk("../../Datasets/20news-bydate/20news-bydate-test/"):
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
			
			categoria=path.split('/')
			doc = { "Titulo": archivo,
				"Texto": text,
				"Categoria": categoria[-1],
				"Hash": 0}
			
			test_docs.append(doc)
			i=i+1

for (path, ficheros, archivos) in walk("../../Datasets/20news-bydate/20news-bydate-train/"):
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
			
			categoria=path.split('/')
			doc = { "Titulo": archivo,
				"Texto": text,
				"Categoria": categoria[-1],
				"Hash": 0}
			
			train_docs.append(doc)
			i=i+1

db.test.insert_many(test_docs)
db.train.insert_many(train_docs)

print 'Cantidad documentos test: %d' %db.test.count()
print 'Cantidad documentos training: %d' %db.train.count()