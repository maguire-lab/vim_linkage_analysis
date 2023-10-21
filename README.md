# VIM Beta-Lactamase Linkage Analysis

Hybrid sequencing study investigating whether 3 isolates from 2 patients that tested PCR positive for Verona integron-encoded metallo-β-lactamase (VIM) were likely to be linked via mobilisation of VIM.
Each sample was sequenced via Nanopore with plasmid miniprep and general easyMAG libraries and via MiSeq before quality control with 

- Quality control was performed using `fastp --length_required 100` (v0.23.4) for short reads and `filtlong --min_length 3000` (v0.2.1) for combined miniprep and easyMAG long reads
- Initial hybrid assemblies were generated for each isolate (unicycler v0.5.0: short-read assembly and long-read scaffolding/resolution and dragonflye v1.0.14: long-read first and short-read polishing)
- The best performing assembly for each isolate was selected on the basis of circular contigs and N50 (quast v5.2.0). See `hybrid_assemblies/` `hybrid_assemblies/qc_assembly_quast.sh` for final assemblies and example run script.
- These were used to determine:
    - Isolate taxonomy (GTDB-TK v2.1.1 w/ GTDB release207v2): `taxonomy_gtdb`
    - Identify plasmids (mob-suite v3.1.7) and AMR genes (bmrfinderplus v3.11.17 w/ DB v2023-08-08.2) present: `hybrid_assemblies/{amrfinderplus,mob_suite}` `hybrid_assemblies/plasmid_amr_annotate.sh`
- Due to sparsity of annotation for Pseudomonas VIM-bearing plasmid 

- VIM-bearing plasmids were extracted from assemblies (and in the case of Pseudomonas putida's large but poorly annotated plasmid - reassembled using trycycler v0.5.4 (following this [protocol](https://github.com/rrwick/Trycycler/wiki/Generating-assemblies) i.e., long-read assembly and contig clustering/reconciliation of raven v6.10.0, miniasm v0.3-r179, flye v2.9.2-b1786 assemblies followed by medaka v1.8.0 /w `r941_min_hac_g507` and polypolish v0.5.0 short read polishing). See `vim_plasmids` (and vim_plasmids/pputida_trycycler.sh` for pputdia VIM-plasmid trycycler example run script).

- Each VIM plasmid was then:
    - Re-identified (mob-suite v3.1.7) `vim_genes/{annotate.sh,mobsuite}`
    - Annotated (Bakta v1.8.2 w/ Full DB v2023-02-20 including amrfinderplus v4.11.17 w/ DB v2023-08-08.2): `vim_genes/{annotate.sh,mobsuite}` 
    - VIM genes sequences extracted and aligned (mafft v7.515): `vim_genes/`
    - Integron-finder (integron_finder v2.0.2 w/ HMMs from AMRFinderPlus DB v2023-08-08.2): `vim_integrons/`
