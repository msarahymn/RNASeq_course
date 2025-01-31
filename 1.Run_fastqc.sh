#!/bin/bash

#SBATCH --job-name=fastqc_sample1
#SBATCH --output=fastqc_sample1.out
#SBATCH --error=fastqc_sample1.err
#SBATCH --cpus-per-task=1
#SBATCH --mem=1G
#SBATCH --time=02:00:00
#SBATCH --partition=pibu_el8

export LC_ALL=C
export LANG=C

mkdir -p /data/users/mmaisyaroh/rnaseq/breastcancer
cd /data/users/mmaisyaroh/rnaseq/breastcancer

module load FastQC/0.11.9-Java-11

ln -s /data/courses/rnaseq_course/breastcancer_de/reads/*.fastq.gz .

fastqc --threads $SLURM_CPUS_PER_TASK *.fastq.gz
