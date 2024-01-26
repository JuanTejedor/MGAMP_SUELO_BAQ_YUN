#!/bin/bash

######## SUBSAMPLE DE READS ########

# Nos quedamos sólo con el 10% de reads de cada archivo demultiplexado. 
# Para PE
qiime demux subsample-paired \
--i-sequences 04-results/01_PE/demuxed.qza \
--p-fraction 0.1 \
--o-subsampled-sequences 04-results/01_PE/subsampled_demuxed.qza
# Saved SampleData[PairedEndSequencesWithQuality] to: 04-results/01_PE/subsampled_demuxed.qza

qiime demux summarize \
--i-data 04-results/01_PE/subsampled_demuxed.qza \
--o-visualization 04-results/01_PE/subsampled_demuxed.qzv


# Para SE
qiime demux subsample-single \
--i-sequences 04-results/02_SE/demuxed.qza \
--p-fraction 0.1 \
--o-subsampled-sequences 04-results/02_SE/subsampled_demuxed.qza
# Saved SampleData[SequencesWithQuality] to: 04-results/02_SE/subsampled_demuxed.qza

qiime demux summarize \
--i-data 04-results/02_SE/subsampled_demuxed.qza \
--o-visualization 04-results/02_SE/subsampled_demuxed.qzv