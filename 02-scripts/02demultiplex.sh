#!/bin/bash

######## DEMULTIPLEXADO DE READS ########

# Como nuestros reads son del tipo EMP y teníamos tanto SE como PE, usaremos los comandos "emp-paired" y "emp-single".

# Para PE
mkdir 04-results/01_PE/errors
qiime demux emp-paired \
--i-seqs 04-results/01_PE/import_EMP_muxed.qza \
--m-barcodes-file 01-documentation/sample-metadata.tsv \
--m-barcodes-column BarcodeSequence \
--p-rev-comp-mapping-barcodes \
--o-per-sample-sequences 04-results/01_PE/demuxed.qza \
--o-error-correction-details 04-results/01_PE/errors/errors_demuxed.qza
# Saved SampleData[PairedEndSequencesWithQuality] to: 04-results/01_PE/demuxed.qza
# Saved ErrorCorrectionDetails to: 04-results/01_PE/errors/errors_demuxed.qza

# Para SE
mkdir 04-results/02_SE/errors
qiime demux emp-single \
--i-seqs 04-results/02_SE/import_EMP_muxed.qza \
--m-barcodes-file 01-documentation/sample-metadata.tsv \
--m-barcodes-column BarcodeSequence \
--p-rev-comp-mapping-barcodes \
--o-per-sample-sequences 04-results/02_SE/demuxed.qza \
--o-error-correction-details 04-results/02_SE/errors/errors_demuxed.qza
#Saved SampleData[SequencesWithQuality] to: 04-results/02_SE/demuxed.qza
#Saved ErrorCorrectionDetails to: 04-results/02_SE/errors/errors_demuxed.qza


# Para trabajar utilizando menos recursos, usaremos un submuestreo del total.

######## SUBSAMPLE DE READS ########

# Nos quedamos sólo con el 10% de reads de cada archivo demultiplexado. 
# Para PE
qiime demux subsample-paired \
--i-sequences 04-results/01_PE/demuxed.qza \
--p-fraction 0.1 \
--o-subsampled-sequences 04-results/01_PE/subsampled_demuxed.qza
# Saved SampleData[PairedEndSequencesWithQuality] to: 04-results/01_PE/subsampled_demuxed.qza
# Guardamos los resultados.
qiime demux summarize \
--i-data 04-results/01_PE/subsampled_demuxed.qza \
--o-visualization 04-results/01_PE/subsampled_demuxed.qzv
qiime tools export \
--input-path 04-results/01_PE/subsampled_demuxed.qzv \
--output-path 05-reports/01_PE/demux

# Para SE
qiime demux subsample-single \
--i-sequences 04-results/02_SE/demuxed.qza \
--p-fraction 0.1 \
--o-subsampled-sequences 04-results/02_SE/subsampled_demuxed.qza
# Saved SampleData[SequencesWithQuality] to: 04-results/02_SE/subsampled_demuxed.qza
# Guardamos los resultados.
qiime demux summarize \
--i-data 04-results/02_SE/subsampled_demuxed.qza \
--o-visualization 04-results/02_SE/subsampled_demuxed.qzv
qiime tools export \
--input-path 04-results/02_SE/subsampled_demuxed.qzv \
--output-path 05-reports/02_SE/demux