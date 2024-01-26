#!/bin/bash

# Las lecturas son de la región V4 y se han usado los cebadores 515F/806R.

NOMBRE_PROYECTO=$1
workdir.sh "$NOMBRE_PROYECTO"

mv 03-data/raw_data 03-data/00raw_data

## SUBMUESTREO ##
# Submuestreamos los reads originales, tomando sólo el 10%. Antes creamos carpeta donde guardarlo. 
mkdir 03-data/01muxed_pe
mv 03-data/00raw_data/sample-metadata.tsv 03-data/01muxed_pe/
cp 03-data/raw_data/barcodes.fastq.gz 03-data/muxed_pe/
seqtk sample -s100 03-data/00raw_data/reverse.fastq.gz 0.1 > 03-data/01muxed_pe/reverse_sub.fastq
seqtk sample -s100 03-data/00raw_data/forward.fastq.gz 0.1 > 03-data/01muxed_pe/forward_sub.fastq

## IMPORTACIÓN ##
# Para importar los datos debemos conocer la naturaleza de estos: sabemos que
# son PE (2 fastq), multiplexed (están incluidas todas las muestras) y no tiene
# un formato específico (debemos crear manifest.tsv). Falta determinar la
# calidad, para lo que usamos:
vsearch --fastq_chars 03-data/01muxed_pe/forward_sub.fastq
# Indica que la calidad está en formato phred+33. 

# Luego, tenemos datos: PE, multiplexed, phred 33 y necesitamos manifest.tsv. Es
# decir: "Multiplexed paired-end FASTQ with barcodes in sequence" que se
# corresponde con el parámetro "MultiplexedPairedEndBarcodeInSequence" 

