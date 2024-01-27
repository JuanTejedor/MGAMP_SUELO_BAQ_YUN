#!/bin/bash

######## QC DE READS ########


## ELIMINACIÓN DE PRIMERS ##
# Los cebadores utilizados son: 515F/806R, cuyas secuencias son:
# Updated sequences: 515F (Parada)– 806R (Apprill), forward-barcoded:
# FWD:GTGYCAGCMGCCGCGGTAA; REV:GGACTACNVGGGTWTCTAAT

# Para PE
qiime cutadapt trim-paired \
--i-demultiplexed-sequences 04-results/01_PE/subsampled_demuxed.qza \
--p-front-f GTGYCAGCMGCCGCGGTAA \
--p-front-r GGACTACNVGGGTWTCTAAT \
--p-match-adapter-wildcards True \
--p-cores 2 \
--verbose \
--o-trimmed-sequences 04-results/01_PE/trimmed_subsampled_demuxed.qza > 04-results/01_PE/logs_errors/log_trimmed.txt
# Guardamos resultados
qiime demux summarize \
--i-data 04-results/01_PE/trimmed_subsampled_demuxed.qza \
--o-visualization 04-results/01_PE/trimmed_subsampled_demuxed.qzv
qiime tools export --input-path 04-results/01_PE/trimmed_subsampled_demuxed.qzv --output-path 05-reports/01_PE/trim

# Para SE
qiime cutadapt trim-single \
--i-demultiplexed-sequences 04-results/02_SE/subsampled_demuxed.qza \
--p-front GTGYCAGCMGCCGCGGTAA \
--p-match-adapter-wildcards True \
--p-cores 2 \
--verbose \
--o-trimmed-sequences 04-results/02_SE/trimmed_subsampled_demuxed.qza > 04-results/02_SE/logs_errors/log_trimmed.txt
# Guardamos resultados
qiime demux summarize \
--i-data 04-results/02_SE/trimmed_subsampled_demuxed.qza \
--o-visualization 04-results/02_SE/trimmed_subsampled_demuxed.qzv
qiime tools export --input-path 04-results/02_SE/trimmed_subsampled_demuxed.qzv --output-path 05-reports/02_SE/trim



## DENOISING ##

# Para PE

# Guardamos resultados


# Para SE

# Guardamos resultados
