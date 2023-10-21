#!/bin/bash

#mobsuite v3.1.7
#Bakta v1.8.2 w/ Full DB v2023-02-20
#amrfinderplus v3.11.17 db 2023-08-08.2

set -euo pipefail

mkdir -p mob_suite bakta 
for assembly in *.fna.gz;
do
    sample=$(echo $assembly | cut -d '.' -f1)
    mob_recon -i $assembly -o mob_suite/${sample}
    bakta --db ../bakta_db/db --output bakta/${sample} --complete --threads 6 $assembly 
done
