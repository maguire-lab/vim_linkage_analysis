#!/bin/bash

#mobsuite v3.1.7
#Bakta v1.8.2 w/ Full DB v2023-02-20
#amrfinderplus v3.11.17 db 2023-08-08.2

set -euo pipefail

mkdir -p mob_suite bakta 
cat *.fna | prodigal -t bakta/prodigal_training_file -p single # create common prodigal training file from all 3 plasmids for consistency
for assembly in *.fna;
do
    sample=$(echo $assembly | cut -d '.' -f1)
    #mob_recon -i $assembly -o mob_suite/${sample}
    bakta --force --db ../../../bakta_db/db --output bakta/${sample} --complete --threads 12 --prodigal-tf bakta/prodigal_training_file $assembly 
done
