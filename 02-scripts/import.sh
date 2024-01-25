# Para importar los datos debemos conocer la naturaleza de estos: sabemos que
# son PE (2 fastq), multiplexed (están incluidas todas las muestras) y no tiene
# un formato específico (debemos crear manifest.tsv). Falta determinar la
# calidad, para lo que usamos:
vsearch --fastq_chars 03-data/raw_data/sub_forward.fastq.gz
# Indica que la calidad está en formato phred+33. 

# Luego, tenemos datos: PE, multiplexed, phred 33 y necesitamos manifest.tsv. Es
# decir: "Multiplexed paired-end FASTQ with barcodes in sequence" que se
# corresponde con el parámetro "MultiplexedPairedEndBarcodeInSequence" 

