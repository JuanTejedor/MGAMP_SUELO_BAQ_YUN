#!/bin/bash

######## SUBSAMPLE DE READS ########

qiime demux subsample-paired \
--i-sequences 04-results/01_PE/demuxed.qza \
--p-fraction 0.1 \
--o-subsampled-sequences 04-results/01_PE/subsampled_demuxed.qza
# Saved SampleData[PairedEndSequencesWithQuality] to: 04-results/01_PE/subsampled_demuxed.qza


qiime demux subsample-single \
--i-sequences 04-results/02_SE/demuxed.qza \
--p-fraction 0.1 \
--o-subsampled-sequences 04-results/02_SE/subsampled_demuxed.qza
# Saved SampleData[SequencesWithQuality] to: 04-results/02_SE/subsampled_demuxed.qza
