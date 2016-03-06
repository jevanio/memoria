#!/usr/bin/env python
# -*- coding: utf-8 -*-
# El siguiente archivo genera el vocabulario del dataset
# Recorre por completo la raiz del directorio buscando archivos, luego:
# 	- Elimina simbolos, numeros, puntuacion y palabras cortas.
#	- Traspasa todo el texto a minusculas, lo divide en sus palabras y agrega al listado existente.
#	- Elimina palabras repetidas del listado
#	- Repite para el siguiente texto
# Comando: python make_vocab.py Directorio_del_Dataset/

import string
import sys
from os import walk

words = []
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
			# Convertir todo el texto en minusculas, separa las palabras y agrega a la lista de palabras ya existente
			words = words + text.lower().split() 
			# Elimina palabras repetidas
			words = sorted(set(words))
			print 'Tamaño Diccionario: %d' %len(words)
			i=i+1			

# Crea el vocabulario segun las palabras unicas encontradas.
vocab = open(sys.argv[1] + "vocab", "w")
for word in words:
	vocab.write(word + "\n")
vocab.close()