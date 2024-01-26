#!/bin/bash

######## DEMULTIPLEXADO DE READS ########


# Creamos carpetas para almacenar el resultado del demultiplexado.
mkdir 04-results/01muxed_pe/demuxed_pe
mkdir 04-results/01muxed_pe/demuxed_pe/errors
mkdir 04-results/02muxed_se/demuxed_se
mkdir 04-results/02muxed_se/demuxed_se/errors

# Como nuestros reads son del tipo EMP y teníamos tanto SE como PE, usaremos los comandos "emp-paired" y "emp-single".
qiime demux emp-paired \
--i-seqs 03-data/01muxed_pe/sequences_EMP_muxed_pe.qza \
--m-barcodes-file 01-documentation/sample-metadata.tsv \
--m-barcodes-column BarcodeSequence \
--p-rev-comp-mapping-barcodes \
--o-per-sample-sequences 04-results/01muxed_pe/demuxed_pe/demux.qza \
--o-error-correction-details 04-results/01muxed_pe/demuxed_pe/errors.qza \
--verbose


qiime demux emp-paired \
--i-seqs 03-data/01muxed_pe/sequences_EMP_muxed_pe.qza \
--m-barcodes-file 01-documentation/sample-metadata.tsv \
--m-barcodes-column BarcodeSequence \
--o-per-sample-sequences 04-results/01muxed_pe/demuxed_pe/demux.qza \
--o-error-correction-details 04-results/01muxed_pe/demuxed_pe/errors.qza \
--verbose