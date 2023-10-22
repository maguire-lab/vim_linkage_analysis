#!/bin/bash

#mobsuite v3.1.7
#Bakta v1.8.2 w/ Full DB v2023-02-20
#amrfinderplus v3.11.17 db 2023-08-08.2

set -euo pipefail

mkdir -p mob_suite bakta 
#cat *.fna | prodigal -t bakta/prodigal_training_file -p single # create common prodigal training file from all 3 plasmids for consistency
for assembly in *.fna;
do
    sample=$(echo $assembly | cut -d '.' -f1)
    #mob_recon -i $assembly -o mob_suite/${sample}
done

#bakta --skip-plot --genus "Enterobacter" --species "soli" --strain "patient B" --plasmid "p.AC919" --force --keep-contig-headers --compliant --db ../../../bakta_db/db --output bakta/enterobacter_unicycler_vim_plasmid_aa919 --complete --threads 12 --prodigal-tf bakta/prodigal_training_file enterobacter_unicycler_vim_plasmid_aa919.fna  
bakta --skip-plot --genus "Pseudomonas" --species "putida" --strain "patient B" --plasmid "p.AC907" --force --keep-contig-headers --compliant --db ../../../bakta_db/db --output bakta/pputida_trycycler_vim_plasmid_ac907 --complete --threads 12 --prodigal-tf bakta/prodigal_training_file pputida_trycycler_vim_plasmid_ac907.fna
bakta --skip-plot --genus "Proteus" --species "mirabilis" --strain "patient A" --plasmid "p.AC082" --force --keep-contig-headers --compliant --db ../../../bakta_db/db --output bakta/proteus_unicycler_vim_plasmid_ac082 --complete --threads 12 --prodigal-tf bakta/prodigal_training_file proteus_unicycler_vim_plasmid_ac082.fna
