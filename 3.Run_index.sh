#!/bin/bash

#SBATCH --mail-type=fail
#SBATCH --job-name="index"
#SBATCH --error=index.err
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --time=13:00:00
#SBATCH --mem=8G
#SBATCH --partition=pibu_el8

# Create the directory 
mkdir -p /data/users/mmaisyaroh/rnaseq/map
cd /data/users/mmaisyaroh/rnaseq/map

# Download the reference genomes (unmasked) and annotations (for featureCounts)
wget https://ftp.ensembl.org/pub/release-113/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz
wget https://ftp.ensembl.org/pub/release-113/gtf/homo_sapiens/Homo_sapiens.GRCh38.113.gtf.gz

# Unzip the reference genome and annotation files
gunzip Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz
gunzip Homo_sapiens.GRCh38.113.gtf.gz

in_dir="/data/users/mmaisyaroh/rnaseq/map"
out_dir="/data/users/mmaisyaroh/rnaseq/map"

# Load the HISAT2 module
module load HISAT2/2.2.1-gompi-2021a

# Execute hisat2-build to index the reference genome

hisat2-build Homo_sapiens.GRCh38.dna.primary_assembly.fa Homo_sapiens_GRCh38_index

mkdir -p /data/users/mmaisyaroh/rnaseq/aligned

Sample=$1

# Align reads using HISAT2

hisat2 -p 4 -x Homo_sapiens_GRCh38_index \
   -1 /data/users/mmaisyaroh/rnaseq/breastcancer/multiqc/${Sample}_R1.fastq.gz \
   -2 /data/users/mmaisyaroh/rnaseq/breastcancer/multiqc/${Sample}_R2.fastq.gz \
   -S /data/users/mmaisyaroh/rnaseq/aligned/${Sample}.sam 2> ${Sample}hisat2_summary.txt