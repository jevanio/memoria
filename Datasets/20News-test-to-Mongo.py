#!/usr/bin/env python
# -*- coding: utf-8 -*-
# El siguiente archivo almacena en MongoDB el Dataset 20-News-Bydate-Train
# Recorre por completo la raiz del directorio buscando archivos
# Para cada archivo:	
# 	- Filtrar texto, como siempre.
#	- Crear diccionario con Titulo, Corpus, Categoría y Hash
#	- Añade a una lista.
# Sigue hasta tener todos los documentos.
# Al tener todos los documentos, inserta en db.20-Train.
# Comando: python save_20News-train.py Directorio_Del_Dataset/

import string
import sys
import os
from os import walk
from collections import Counter

import pymongo
from pymongo import MongoClient

client = MongoClient()
db = client.Newsgroups
docs = []
i=1
for (path, ficheros, archivos) in walk(sys.argv[1]):
	if len(archivos)>0:
		for archivo in archivos:
			# Evita tomar el archivo de vocabulario ya existente
			if archivo=="vocab" or archivo=="word_count": continue

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
				"Categoria": categoria,
				"Hash": 0}
			
			docs.append(doc)
			i=i+1

db.test.insert_many(docs)
print 'Cantidad documentos: %d' %len(docs)