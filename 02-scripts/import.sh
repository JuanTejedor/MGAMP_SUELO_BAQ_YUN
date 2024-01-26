#!/bin/bash

# Las lecturas son de la región V4 y se han usado los cebadores 515F/806R.

NOMBRE_PROYECTO=$1
workdir.sh "$NOMBRE_PROYECTO"

mv 03-data/raw_data 03-data/00raw_data

## SUBMUESTREO ##
# Submuestreamos los reads originales, tomando sólo el 10%. Antes creamos
# carpeta donde guardarlo. 
mkdir 03-data/01muxed_pe
mv 03-data/00raw_data/sample-metadata.tsv 01-documentation
cp 03-data/00raw_data/barcodes.fastq.gz 03-data/01muxed_pe/
seqtk sample -s100 03-data/00raw_data/reverse.fastq.gz 0.1 > 03-data/01muxed_pe/reverse.fastq
seqtk sample -s100 03-data/00raw_data/forward.fastq.gz 0.1 > 03-data/01muxed_pe/forward.fastq
gzip 03-data/01muxed_pe/reverse.fastq
gzip 03-data/01muxed_pe/forward.fastq

## EVALUACIÓN DE CALIDAD ## 
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
# formato del "EMP protocol" paired reads. Por ello, para importarlos debemos usar el
# parámetro "EMPPairedEndSequences" y la siguiente función.
qiime tools import \
  --type EMPPairedEndSequences \
  --input-path 03-data/01muxed_pe \
  --output-path 03-data/01muxed_pe/EMP_muxed_pe.qza
