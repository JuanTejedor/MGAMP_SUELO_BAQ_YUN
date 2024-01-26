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