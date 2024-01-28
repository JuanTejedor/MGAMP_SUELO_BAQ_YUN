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
--o-trimmed-sequences 04-results/01_PE/trimmed_subsampled_demuxed.qza &> 04-results/01_PE/logs_errors/log_trimmed.txt
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
--o-trimmed-sequences 04-results/02_SE/trimmed_subsampled_demuxed.qza &> 04-results/02_SE/logs_errors/log_trimmed.txt
# Guardamos resultados
qiime demux summarize \
--i-data 04-results/02_SE/trimmed_subsampled_demuxed.qza \
--o-visualization 04-results/02_SE/trimmed_subsampled_demuxed.qzv
qiime tools export --input-path 04-results/02_SE/trimmed_subsampled_demuxed.qzv --output-path 05-reports/02_SE/trim



## DENOISING: FILTRADO POR CALIDAD, ELIMINACION DE QUIMERAS Y CLUSTERING ##

# Para PE 
# Observando la gráfica de calidad, se puede ver como:
#   - los forward reads tienen muy buena calidad en toda su longitud a excepción
#   de unas cuantas posiciones. En general, todas las posiciones superan phred>30,
#   excepto en las posiciones 142, 143 y 151. Como en las regiones 144-150 la
#   calidad es muy buena, cortar a partir de la posición 142 sería muy estricto,
#   por lo que sólo se truncarán los forward reads hasta 150 pb. 

#   - los reverse reads, al contrario, tienen peor calidad a lo largo de toda su
#     longitud, siendo muy baja su calidad, sobre todo, a partir de los 100 pb.
#     Por tanto, se truncarán los reverse reads hasta 100 pb. EL problema es que
#     puede ser un truncamiento demasiado estricto, de modo que al final no
#     consigan solapar los PE reads, por lo que se probarán con distintos
#     truncamientos y se evaluarán los resultados obtenidos. De forma
#     alternativa, también se realizará el denoising con los forward reads
#     únicamente, y se evaluarán los resultados.


# PARA REVERSE 120 PB
qiime dada2 denoise-paired \
--i-demultiplexed-seqs 04-results/01_PE/trimmed_subsampled_demuxed.qza \
--p-trunc-len-f 150 \
--p-trunc-len-r 120 \
--p-n-threads 2 \
--verbose \
--o-table 04-results/01_PE/table_ASVs_r120.qza \
--o-representative-sequences 04-results/01_PE/sequences_ASVs_r120.qza \
--o-denoising-stats 04-results/01_PE/denoising_stats_r120.qza &> 04-results/01_PE/logs_errors/log_denoising_r120.txt
# Guardamos resultados
qiime feature-table summarize \
--i-table 04-results/01_PE/table_ASVs_r120.qza \
--m-sample-metadata-file 01-documentation/sample-metadata.tsv \
--o-visualization 04-results/01_PE/table_ASVs_r120.qzv

qiime feature-table tabulate-seqs \
--i-data 04-results/01_PE/sequences_ASVs_r120.qza \
--o-visualization 04-results/01_PE/sequences_ASVs_r120.qzv

qiime metadata tabulate \
--m-input-file 04-results/01_PE/denoising_stats_r120.qza \
--o-visualization 04-results/01_PE/denoising_stats_r120.qzv

qiime tools export --input-path 04-results/01_PE/table_ASVs_r120.qzv --output-path 05-reports/01_PE/table_ASVs_r120
qiime tools export --input-path 04-results/01_PE/sequences_ASVs_r120.qzv --output-path 05-reports/01_PE/seqs_ASVs_r120
qiime tools export --input-path 04-results/01_PE/denoising_stats_r120.qzv --output-path 05-reports/01_PE/denoising_stats_r120


# PARA REVERSE 128 PB
qiime dada2 denoise-paired \
--i-demultiplexed-seqs 04-results/01_PE/trimmed_subsampled_demuxed.qza \
--p-trunc-len-f 150 \
--p-trunc-len-r 128 \
--p-n-threads 2 \
--verbose \
--o-table 04-results/01_PE/table_ASVs_r128.qza \
--o-representative-sequences 04-results/01_PE/sequences_ASVs_r128.qza \
--o-denoising-stats 04-results/01_PE/denoising_stats_r128.qza &> 04-results/01_PE/logs_errors/log_denoising_r128.txt
# Guardamos resultados
qiime feature-table summarize \
--i-table 04-results/01_PE/table_ASVs_r128.qza \
--m-sample-metadata-file 01-documentation/sample-metadata.tsv \
--o-visualization 04-results/01_PE/table_ASVs_r128.qzv

qiime feature-table tabulate-seqs \
--i-data 04-results/01_PE/sequences_ASVs_r128.qza \
--o-visualization 04-results/01_PE/sequences_ASVs_r128.qzv

qiime metadata tabulate \
--m-input-file 04-results/01_PE/denoising_stats_r128.qza \
--o-visualization 04-results/01_PE/denoising_stats_r128.qzv

qiime tools export --input-path 04-results/01_PE/table_ASVs_r128.qzv --output-path 05-reports/01_PE/table_ASVs_r128
qiime tools export --input-path 04-results/01_PE/sequences_ASVs_r128.qzv --output-path 05-reports/01_PE/seqs_ASVs_r128
qiime tools export --input-path 04-results/01_PE/denoising_stats_r128.qzv --output-path 05-reports/01_PE/denoising_stats_r128

# NOT FILTERING
qiime dada2 denoise-paired \
--i-demultiplexed-seqs 04-results/01_PE/trimmed_subsampled_demuxed.qza \
--p-trunc-len-f 150 \
--p-trunc-len-r 150 \
--p-n-threads 2 \
--verbose \
--o-table 04-results/01_PE/table_ASVs_r150.qza \
--o-representative-sequences 04-results/01_PE/sequences_ASVs_r150.qza \
--o-denoising-stats 04-results/01_PE/denoising_stats_r150.qza &> 04-results/01_PE/logs_errors/log_denoising_r150.txt
# Guardamos resultados
qiime feature-table summarize \
--i-table 04-results/01_PE/table_ASVs_r150.qza \
--m-sample-metadata-file 01-documentation/sample-metadata.tsv \
--o-visualization 04-results/01_PE/table_ASVs_r150.qzv

qiime feature-table tabulate-seqs \
--i-data 04-results/01_PE/sequences_ASVs_r150.qza \
--o-visualization 04-results/01_PE/sequences_ASVs_r150.qzv

qiime metadata tabulate \
--m-input-file 04-results/01_PE/denoising_stats_r150.qza \
--o-visualization 04-results/01_PE/denoising_stats_r150.qzv

qiime tools export --input-path 04-results/01_PE/table_ASVs_r150.qzv --output-path 05-reports/01_PE/table_ASVs_r150
qiime tools export --input-path 04-results/01_PE/sequences_ASVs_r150.qzv --output-path 05-reports/01_PE/seqs_ASVs_r150
qiime tools export --input-path 04-results/01_PE/denoising_stats_r150.qzv --output-path 05-reports/01_PE/denoising_stats_r150





# Para SE
qiime dada2 denoise-single \
--i-demultiplexed-seqs 04-results/02_SE/trimmed_subsampled_demuxed.qza \
--p-trunc-len 150 \
--p-n-threads 2 \
--verbose \
--o-table 04-results/02_SE/table_ASVs.qza \
--o-representative-sequences 04-results/02_SE/sequences_ASVs.qza \
--o-denoising-stats 04-results/02_SE/denoising_stats.qza &> 04-results/02_SE/logs_errors/log_denoising.txt
# Guardamos resultados
qiime feature-table summarize \
--i-table 04-results/02_SE/table_ASVs.qza \
--m-sample-metadata-file 01-documentation/sample-metadata.tsv \
--o-visualization 04-results/02_SE/table_ASVs.qzv

qiime feature-table tabulate-seqs \
--i-data 04-results/02_SE/sequences_ASVs.qza \
--o-visualization 04-results/02_SE/sequences_ASVs.qzv

qiime metadata tabulate \
--m-input-file 04-results/02_SE/denoising_stats.qza \
--o-visualization 04-results/02_SE/denoising_stats.qzv

qiime tools export --input-path 04-results/02_SE/table_ASVs.qzv --output-path 05-reports/02_SE/table_ASVs
qiime tools export --input-path 04-results/02_SE/sequences_ASVs.qzv --output-path 05-reports/02_SE/seqs_ASVs
qiime tools export --input-path 04-results/02_SE/denoising_stats.qzv --output-path 05-reports/02_SE/denoising_stats

# En los resultados obtenidos por los distintos métodos, se observa que el
# método que retiene el mayor número de contigs es que usa single reads, por
# tanto, los análisis posteriores se basaran en este.

## FILTRADO POR PROFUNDIDAD DE SECUENCIACIÓN (MUESTRAS) ##

qiime feature-table filter-samples \
--i-table 04-results/02_SE/table_ASVs.qza \
--p-min-frequency 450 \
--o-filtered-table 04-results/02_SE/cov_filtered_table_ASVs.qza

## ELIMINACIÓN DE SINGLETONS ##

qiime feature-table filter-features \
--i-table 04-results/02_SE/cov_filtered_table_ASVs.qza \
--p-min-frequency 2 \
--o-filtered-table 04-results/02_SE/sing_cov_filtered_table_ASVs.qza

# Finalmente, aplicamos los 2 filtros anteriores a las secuencias
# representativas de los ASVs.
qiime feature-table filter-seqs \
--i-data  04-results/02_SE/sequences_ASVs.qza \
--i-table 04-results/02_SE/sing_cov_filtered_table_ASVs.qza \
--o-filtered-data 04-results/02_SE/sing_cov_sequences_ASVs.qza

# Guardamos resultados
qiime feature-table summarize \
--i-table 04-results/02_SE/sing_cov_filtered_table_ASVs.qza \
--m-sample-metadata-file 01-documentation/sample-metadata.tsv \
--o-visualization 04-results/02_SE/sing_cov_filtered_table_ASVs.qzv

qiime feature-table tabulate-seqs \
--i-data 04-results/02_SE/sing_cov_sequences_ASVs.qza \
--o-visualization 04-results/02_SE/sing_cov_sequences_ASVs.qzv

qiime tools export --input-path 04-results/02_SE/sing_cov_filtered_table_ASVs.qzv --output-path 05-reports/02_SE/filtered_table_ASVs
qiime tools export --input-path 04-results/02_SE/sing_cov_sequences_ASVs.qzv --output-path 05-reports/02_SE/filtered_seqs_ASVs
