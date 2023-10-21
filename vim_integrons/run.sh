#!/bin/bash

set -euo pipefail

for plasmid in ../vim_plasmids/*.fna;
do
    sample=$(basename $plasmid | cut -d '.' -f1)
    integron_finder --circ --local-max --cpu 3 --promoter-attI --outdir ${sample} --path-func-annot NCBIAMR_hmms --gbk --pdf $plasmid
    # AMRfinderPlus HMMs
done
