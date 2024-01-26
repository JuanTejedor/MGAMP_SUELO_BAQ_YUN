#!/bin/bash

## REQUISITOS PREVIOS ##
# Para que el siguiente script funcione correctamente es necesario tener creados
# previamente todos los directorios del proyecto utilizando el script
# workdir.sh. Tras ello, se deben importar los datos crudos en una carpeta
# llamada "/raw_data" que se debe colocar dentro de la carpeta "/03-data".

## PREPARACION DEL DIRECTORIO DE TRABAJO ##
# El nombre de la carpeta con los datos crudos se cambia para facilitar el acceso y seguir un orden
# cronologico.
mv 03-data/raw_data 03-data/00raw_data
# Movemos los metadatos a la carpeta de documentacion
mv 03-data/00raw_data/sample-metadata.tsv 01-documentation


## SUBMUESTREO ##
# Submuestreamos los reads originales, tomando sólo el 10%. Antes creamos
# carpeta donde guardarlos. 
mkdir 03-data/01muxed_pe
# Copiamos los barcodes a los datos submuestreados.
cp 03-data/00raw_data/barcodes.fastq.gz 03-data/01muxed_pe/
# Realizamos el submuestreo.
seqtk sample -s100 03-data/00raw_data/reverse.fastq.gz 0.1 > 03-data/01muxed_pe/reverse.fastq
seqtk sample -s100 03-data/00raw_data/forward.fastq.gz 0.1 > 03-data/01muxed_pe/forward.fastq
# Comprimimos ambos archivos (para que tengan el formato adecuado para QIIME)
gzip 03-data/01muxed_pe/reverse.fastq
gzip 03-data/01muxed_pe/forward.fastq


## EVALUACIÓN DE CALIDAD ## 
# Ejecutamos FASTQC y guardamos los resultados en una carpeta.
mkdir 04-results/01muxed_pe_fastqc
fastqc 03-data/01muxed_pe/forward.fastq.gz 03-data/01muxed_pe/reverse.fastq.gz -o 04-results/01muxed_pe_fastqc/
# Para forwards la calidad es muy buena (excepto en el último nucleotido),
# mientras que para reverse es muy mala (excepto del 9 al 100). Además, hay
# algunos forwards que en su extremo final tienen un poco de adaptador.


## IMPORTACIÓN ##
# Para importar los datos debemos conocer la naturaleza de estos. Para ello
# usamos la documentación de importación de QIIME
# (https://docs.qiime2.org/2023.9/tutorials/importing/#sequence-data-with-sequence-quality-information-i-e-fastq).
# En nuestro caso, tenemos archivos FASTQ. Seguimos las instrucciones de
# "Sequence data with sequence quality information (i.e. FASTQ)". Los datos que
# tenemos vienen dados en 3 archivos: forward.fastq.gz, reverse.fastq.gz y
# barcodes.fastq.gz. Además, estan multiplexados pues sólo tenemos 1 .fastq para
# cada tipo de read. De este modo, se observa que nuestros datos siguen el
# formato del "EMP protocol" paired reads. Por ello, para importarlos debemos
# usar el parámetro "EMPPairedEndSequences" y la siguiente función.
qiime tools import \
  --type EMPPairedEndSequences \
  --input-path 03-data/01muxed_pe \
  --output-path 03-data/01muxed_pe/EMP_muxed_pe.qza

# Además, como la calidad de los reverse reads era mala, vamos a importar
# también los forward reads solo, mediante una importanción single end. Para
# ello, debemos crear otro directorio y hacer unos cuantos cambios.
cp -r 03-data/01muxed_pe/ 03-data/01muxed_se/
rm 03-data/01muxed_se/reverse.fastq.gz 03-data/01muxed_se/*qza
mv 03-data/01muxed_se/forward.fastq.gz 03-data/01muxed_se/sequences.fastq.gz
qiime tools import \
  --type EMPSingleEndSequences \
  --input-path 03-data/01muxed_se \
  --output-path 03-data/01muxed_se/EMP_muxed_se.qza

# Por tanto, tenemos 2 directorios, uno con la importación PE y otro con la
# importación SE.