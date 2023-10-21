#!/bin/bash

#mobsuite v3.1.7
#amrfinderplus v3.11.17 db 2023-08-08.2

set -euo pipefail

mkdir -p mob_suite amrfinderplus
for assembly in *.fna.gz;
do
    sample=$(echo $assembly | cut -d '.' -f1)
    mob_recon -i $assembly -o mob_suite/${sample}
    amrfinder --nucleotide $assembly -o amrfinderplus/${sample}
done
