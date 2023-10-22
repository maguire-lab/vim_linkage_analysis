#!/bin/bash

set -euo pipefail

for plasmid in ../vim_plasmids/*.fna;
do
    sample=$(basename $plasmid | cut -d '.' -f1)
    echo "integron_finder --circ --local-max --cpu 6 --promoter-attI --outdir . --path-func-annot ../../HMM --gbk --pdf $plasmid"
    # AMRfinderPlus HMMs
done
