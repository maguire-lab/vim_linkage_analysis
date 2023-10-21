#!/bin/bash
set -euo pipefail

sample="Pmirabilis"
mkdir -p ${sample}
trycycler subsample --reads reads_qc/${sample}_combined_long_3k.fastq.gz --out_dir ${sample}/read_subsets --genome_size 7m #adjusted as appropriate based on reference genome

threads=12  
mkdir -p ${sample}/assemblies
cd $sample
flye --nano-hq read_subsets/sample_01.fastq --threads "$threads" --out-dir assembly_01 && cp assembly_01/assembly.fasta assemblies/assembly_01.fasta && rm -r assembly_01
miniasm_and_minipolish.sh read_subsets/sample_02.fastq "$threads" > assembly_02.gfa && any2fasta assembly_02.gfa > assemblies/assembly_02.fasta && rm assembly_02.gfa
raven --threads "$threads" --disable-checkpoints read_subsets/sample_03.fastq > assemblies/assembly_03.fasta

flye --nano-hq read_subsets/sample_04.fastq --threads "$threads" --out-dir assembly_04 && cp assembly_04/assembly.fasta assemblies/assembly_04.fasta && rm -r assembly_04
miniasm_and_minipolish.sh read_subsets/sample_05.fastq "$threads" > assembly_05.gfa && any2fasta assembly_05.gfa > assemblies/assembly_05.fasta && rm assembly_05.gfa
raven --threads "$threads" --disable-checkpoints read_subsets/sample_06.fastq > assemblies/assembly_06.fasta

flye --nano-hq read_subsets/sample_07.fastq --threads "$threads" --out-dir assembly_07 && cp assembly_07/assembly.fasta assemblies/assembly_07.fasta && rm -r assembly_07
miniasm_and_minipolish.sh read_subsets/sample_08.fastq "$threads" > assembly_08.gfa && any2fasta assembly_08.gfa > assemblies/assembly_08.fasta && rm assembly_08.gfa
raven --threads "$threads" --disable-checkpoints read_subsets/sample_09.fastq > assemblies/assembly_09.fasta

flye --nano-hq read_subsets/sample_10.fastq --threads "$threads" --out-dir assembly_10 && cp assembly_10/assembly.fasta assemblies/assembly_10.fasta && rm -r assembly_10
miniasm_and_minipolish.sh read_subsets/sample_11.fastq "$threads" > assembly_11.gfa && any2fasta assembly_11.gfa > assemblies/assembly_11.fasta && rm assembly_11.gfa
raven --threads "$threads" --disable-checkpoints read_subsets/sample_12.fastq > assemblies/assembly_12.fasta

trycycler cluster --assemblies assemblies/*.fasta --reads ../reads_qc/${sample}_combined_long_3k.fastq.gz --out_dir trycycler | tee trycycler.log

# manual trycycler steps for only the VIM-bearing contig cluster: reconcile msa partition consensus > 7_final_consensus.fasta
mkdir -p polishing
medaka_consensus -i $vim_partition/4_reads.fastq -d $vim_partition/7_final_consensus.fasta -o polishing/medaka_consensus -m r941_min_hac_g507

mkdir -p polishing/polypolish
bwa index polishing/medaka_consensus/consensus.fasta
bwa mem -t 16 -a polishing/medaka_consensus/consensus.fasta ../../read_qc/${sample}_short_qc_1.fastq.gz > polishing/polypolish/alignments_1.sam
bwa mem -t 16 -a polishing/medaka_consensus/consensus.fasta ../../read_qc/${sample}_short_qc_2.fastq.gz > polishing/polypolish/alignments_2.sam

polypolish polishing/medaka_consensus/consensus.fasta polishing/polypolish/alignments_1.sam polishing/polypolish/alignments_2.sam > polishing/polypolish/polypolish.fasta
cp polishing/polypolish/polypolish.fasta # final assembly for VIM plasmid
