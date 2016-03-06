#!/usr/bin/env python
# -*- coding: utf-8 -*-
# El siguiente archivo genera el word-count vector para un dataset dado
# Recorre por completo la raiz del directorio buscando archivos
# Para cada archivo:	
# 	- Elije una palabra del archivo vocab.
#	- Cuenta la ocurrencia de dicha palabra en el archivo.
#	- Añade la ocurrencia a una lista.
#	- Elije siguiente palabra del vocab.
#	- Cuando termine el vocab, añadir lista a nueva línea de fichero word_count.
# Repetir para el siguiente texto.
# Comando: python make_word_count.py Directorio_Del_Dataset/

import string
import sys
from os import walk
from collections import Counter

i=1

# Crea el archivo word_count segun las palabras unicas encontradas.
vocab = file(sys.argv[1] + "vocab", "rb").read().split()

data_word_count = open(sys.argv[1] + "word_count", "w")
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
			word_count = [text.count(w) for w in vocab]
			for idx2, word in enumerate(word_count):
				if word > 0:
					print "%d" %i + " %d " %idx2 + " %d \n" %word
					data_word_count.write("%d" %i + " %d " %idx2 + " %d \n" %word)
			data_word_count.write("\n")
			i=i+1
data_word_count.write("%d" %len(vocab))
data_word_count.close()