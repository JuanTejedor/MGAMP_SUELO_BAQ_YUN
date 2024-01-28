#!/bin/bash

######## ANÁLISIS DE DIVERSIDAD ########

## CONSTRUCCIÓN DE ARBOL FILOGENÉTICO ##

mkdir 04-results/02_SE/phylogeny

# 1. Alineamiento múltiple
qiime alignment mafft \
--i-sequences 04-results/02_SE/filt_denoising/sing_cov_sequences_ASVs.qza \
--o-alignment 04-results/02_SE/phylogeny/aligned_sing_cov_sequences_ASVs.qza

# 2. Filtrado o enmascaramiento de regiones de baja complejidad
qiime alignment mask \
--i-alignment 04-results/02_SE/phylogeny/aligned_sing_cov_sequences_ASVs.qza \
--o-masked-alignment 04-results/02_SE/phylogeny/masked_aligned_sing_cov_sequences_ASVs.qza

# 3. FastTree
qiime phylogeny fasttree \
--i-alignment 04-results/02_SE/phylogeny/masked_aligned_sing_cov_sequences_ASVs.qza \
--o-tree 04-results/02_SE/phylogeny/tree_masked_aligned_sing_cov_sequences_ASVs.qza

# 4. Enraizar (punto medio)
qiime phylogeny midpoint-root \
--i-tree 04-results/02_SE/phylogeny/tree_masked_aligned_sing_cov_sequences_ASVs.qza \
--o-rooted-tree 04-results/02_SE/phylogeny/rooted_tree_masked_aligned_sing_cov_sequences_ASVs.qza

## ANÁLISIS DE DIVERSIDAD ##

# Para realizar el análisis de diversidad, se debe normalizar mediante
# rarefacción. Para ello hay que establecer un umbral de profundidad de
# secuenciación que determinará el número de secuencias que se submuestraran de
# cada muestra, con el objetivo de que todas las muestras tengan la misma
# profundidad (lo que permite compararlas entre sí). Para seleccionar el umbral,
# nos fijamos en la tabla que contiene la frecuencia de las muestras. Se observa
# que la mínima frecuencia en una muestra es 497. Por tanto, como umbral,
# elegiremos 490, de modo que para realizar el análisis de la diversidad se
# submuestraran 490 secuencias de cada muestra. 

mkdir 05-reports/02_SE/diversity

qiime diversity core-metrics-phylogenetic \
--i-table 04-results/02_SE/filt_denoising/sing_cov_filtered_table_ASVs.qza \
--i-phylogeny 04-results/02_SE/phylogeny/rooted_tree_masked_aligned_sing_cov_sequences_ASVs.qza \
--p-sampling-depth 490 \
--m-metadata-file 01-documentation/sample-metadata.tsv \
--output-dir 04-results/02_SE/diversity 

# Guardamos los resultados (de la beta diversidad)
qiime tools export --input-path 04-results/02_SE/diversity/bray_curtis_emperor.qzv --output-path 05-reports/02_SE/diversity/bray_curtis_emperor
qiime tools export --input-path 04-results/02_SE/diversity/jaccard_emperor.qzv --output-path 05-reports/02_SE/diversity/jaccard_emperor
qiime tools export --input-path 04-results/02_SE/diversity/unweighted_unifrac_emperor.qzv --output-path 05-reports/02_SE/diversity/unweighted_unifrac_emperor
qiime tools export --input-path 04-results/02_SE/diversity/weighted_unifrac_emperor.qzv --output-path 05-reports/02_SE/diversity/weighted_unifrac_emperor


## ANÁLISIS DE DIVERSIDAD ALPHA ##

# Guardamos resultados (de alpha diversidad). Los ficheros .qzv se crearon en el
# comando core-metrics-phylogenetic, tanto para betas como alpha indices. Antes
# hemos guardado los de beta indices, ahora guardamos los de alpha indices.
qiime diversity alpha-rarefaction \
--i-table 04-results/02_SE/diversity/rarefied_table.qza \
--p-max-depth 490 \
--o-visualization 04-results/02_SE/diversity/rarefied_table.qzv
qiime tools export --input-path 04-results/02_SE/diversity/rarefied_table.qzv --output-path 05-reports/02_SE/diversity/alpha_rarefaction

qiime diversity alpha-group-significance \
--i-alpha-diversity 04-results/02_SE/diversity/faith_pd_vector.qza \
--m-metadata-file 01-documentation/sample-metadata.tsv \
--o-visualization 04-results/02_SE/diversity/group_sign_faith_pd_vector.qzv
qiime tools export --input-path 04-results/02_SE/diversity/group_sign_faith_pd_vector.qzv --output-path 05-reports/02_SE/diversity/alpha_group_significance

# Correlación (a partir de alpha de PD (Faith's Phylogenetic Diversity metric) y coeficiente de pearson)
qiime diversity alpha-correlation \
--i-alpha-diversity 04-results/02_SE/diversity/faith_pd_vector.qza \
--m-metadata-file 01-documentation/sample-metadata.tsv \
--p-method 'pearson' \
--o-visualization 04-results/02_SE/diversity/corr_faith_pd_vector.qzv
qiime tools export --input-path 04-results/02_SE/diversity/corr_faith_pd_vector.qzv --output-path 05-reports/02_SE/diversity/alpha_correlation_faithpd

# Correlación (a partir de alpha de Shannon y coeficiente de pearson)
qiime diversity alpha-correlation \
--i-alpha-diversity 04-results/02_SE/diversity/shannon_vector.qza \
--m-metadata-file 01-documentation/sample-metadata.tsv \
--p-method 'pearson' \
--o-visualization 04-results/02_SE/diversity/corr_shannon_vector.qzv
qiime tools export --input-path 04-results/02_SE/diversity/corr_shannon_vector.qzv --output-path 05-reports/02_SE/diversity/alpha_correlation_shannon