#!/bin/bash

# Workflow for genome assembly and annotation:

# Initial quality check (adjust file extensions as required for fn, fasta, fastq, etc.)
fastqc -o path/to/initialQualityCheck/ path/to/rawData/*.fastq


# Quality control with cutadapt (adjust file extensinos as required)

for i in *_R1_001.fastq.gz
do
  SAMPLE=$(echo ${i} | sed "s/_R1_\001\.fastq\.gz//") 
  echo ${SAMPLE}_R1_001.fastq.gz ${SAMPLE}_R2_001.fastq.gz
cutadapt -m 20 -O 17 -e 0 -q 20,20 -u 20 -u -10 -U 20 -U 10 -g "forwardPrimer1xxx" -g "forwardPrimer2xxx" -g "forwardPrimer3xxx" -a "forwardPrimer1InverseSequencexxx" -a "forwardPrimer2InverseSequencexxx" -a "forwardPrimer3InverseSequencexxx" -G "reversePrimer1xxx" -G "reversePrimer2xxx" -G "reversePrimer3xxx" -A "reversePrimer1InverseSequencexxx" -A "reversePrimer2InverseSequencexxx" -A "reversePrimer3InverseSequencexxx" -o /path/to/qualityControl/${SAMPLE}_R1_001.fastq.gz -p /path/to/quallityControl/${SAMPLE}_R2_001.fastq.gz ${SAMPLE}_R1_001.fastq.gz ${SAMPLE}_R2_001.fastq.gz
done


# Quality check after quality controls

fastqc -o /path/to/secondQualityCheck/ /path/to/quallityControl/*.fastq


# Genome assembly ofr short reads with uniicycler. Add -L flag if you have long reads (e.g. PacBio and Nanopore)
                  
unicycler -1 /path/to/quallityControl/sample_R1.fq -2 /path/to/quallityControl/sample_R2.fq -o /path/to/assembledGenome/


# Assembly assesment with quast

quast -o /path/to/assembledGenome/quastResults --min-contig 500 -L /path/to/assembledGenome/assembly.fasta /path/to/assembledGenome/assembly.fasta


# Genome annonation with prokka
prokka --outdir /path/to/annotatedGenomes/prokkaResults --prefix Genus_species --kingdom Bacteria --genus Genus --species species /path/to/aasembledGenome/assembly.fasta

