#!/bin/bash 
set -euo pipefail
#gtdbtk: version 2.1.1
#GTDBTK_DATA_PATH=gtdb/release207_v2
gtdbtk classify_wf --genome_dir ../hybrid_assemblies --prefix best_hybrid_assembly_taxonomy --cpus 10 --pplacer_cpus 10 --out_dir . --extension fna.gz


