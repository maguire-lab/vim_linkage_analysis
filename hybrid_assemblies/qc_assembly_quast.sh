#!/bin/bash
set -euo pipefail

#fastp v0.23.4
#filtlong v0.2.1
#unicycler v0.5.0
#dragonflye v1.0.14
#quast v5.2.0

sample="Pmirabilis"

#qc
mkdir -p reads_qc
fastp --in1 raw_reads/${sample}_short_R1.fastq.gz --in2 raw_reads/${sample}_short_R2.fastq.gz --out1 read_qc/${sample}_short_qc_1.fastq.gz --out2 read_qc/${sample}_short_qc_2.fastq.gz --unpaired1 read_qc/${sample}_short_qc_u.fastq.gz --unpaired2 read_qc/${sample}_short_qc_u.fastq.gz
filtlong --min_length 3000 raw_reads/${sample}_combined_long.fastq.gz | gzip > read_qc/${sample}_combined_long_min3kbp.fastq.gz

#assemblies
unicycler -1 read_qc/${sample}_short_qc_1.fastq.gz -2 read_qc/${sample}_short_qc_2.fastq.gz -s read_qc/${sample}_short_qc_u.fastq.gz -l read_qc/${sample}_combined_long_min3kbp.fastq.gz -o ${sample}_unicycler -t 10 | tee -a > ${sample}_unicycler.log
dragonflye --reads read_qc/${sample}_combined_long_min3kbp.fastq.gz --R1 ${sample}_short_qc_1.fastq.gz --R2 ${sample}_short_qc_2.fastq.gz --ram 60 --pilon 1 --cpus 10 --outdir ${sample}_dragonflye | tee -a > ${sample}_dragonflye.log

#quast
quast --nanopore reads_qc/${sample}_combined_long_3k.fastq.gz -1 reads_qc/${sample}_short_qc_1.fastq.gz -2 reads_qc/${sample}_short_2.fastq.gz --circos ${sample}_dragonflye/contigs.fa ${sample}_unicycler/assembly.fasta 
