#!/bin/bash

######## IMPORTACIÓN DE READS A QIIME ########

## REQUISITOS PREVIOS ##
# Para que el siguiente script funcione correctamente es necesario tener creados
# previamente todos los directorios del proyecto utilizando el script
# workdir.sh. Tras ello, se deben importar los datos crudos en una carpeta
# llamada "/raw_data" que se debe colocar dentro de la carpeta "/03-data".
# Además, el formato de los FASTQ debe coincidir con el del protocolo EMP.

## PREPARACION DEL DIRECTORIO DE TRABAJO ##
# El nombre de la carpeta con los datos crudos se cambia para facilitar el acceso.
mv 03-data/raw_data 03-data/00raw_data
# Movemos los metadatos a la carpeta de documentacion
mv 03-data/00raw_data/sample-metadata.tsv 01-documentation
# Creamos una carpeta para PE y para SE, pues será necesaria para la función de importación de QIIME.
mkdir 03-data/00raw_data/01_PE 03-data/00raw_data/02_SE
mv 03-data/00raw_data/*fastq* 03-data/00raw_data/01_PE
cp 03-data/00raw_data/01_PE/barcodes.fastq.gz 03-data/00raw_data/02_SE
cp 03-data/00raw_data/01_PE/forward.fastq.gz 03-data/00raw_data/02_SE/sequences.fastq.gz

## EVALUACIÓN DE CALIDAD ## 
# Ejecutamos FASTQC y guardamos los resultados en una carpeta.
mkdir 04-results/01_PE 04-results/02_SE
mkdir 04-results/01_PE/fastqc/ 04-results/02_SE/fastqc/
fastqc 03-data/00raw_data/01_PE/forward.fastq.gz 03-data/00raw_data/01_PE/reverse.fastq.gz -o 04-results/01_PE/fastqc/
fastqc 03-data/00raw_data/02_SE/sequences.fastq.gz -o 04-results/02_SE/fastqc/
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
  --input-path 03-data/00raw_data/01_PE \
  --output-path 03-data/00raw_data/01_PE/import_EMP_muxed.qza
# Imported 03-data/00raw_data/01_PE as EMPPairedEndDirFmt to 04-results/01_PE/import_EMP_muxed.qza

# Además, como la calidad de los reverse reads era mala, vamos a importar
# también los forward reads solo, mediante una importación single end. Para
# ello, debemos crear otro directorio y hacer unos cuantos cambios.
qiime tools import \
  --type EMPSingleEndSequences  \
  --input-path 03-data/00raw_data/02_SE \
  --output-path 03-data/00raw_data/02_SE/import_EMP_muxed.qza
#Imported 03-data/00raw_data/02_SE as EMPSingleEndDirFmt to 04-results/02_SE/import_EMP_muxed.qza

# Por tanto, tenemos 2 directorios, uno con la importación PE y otro con la
# importación SE.