#!/bin/bash

#SBATCH --mail-type=fail
#SBATCH --job-name="map"
#SBTACH --output=map.out
#SBATCH --error=map.err 
#SBATCH --nodes=1
#SBATCH --cpus-per-task=4
#SBATCH --time=13:00:00
#SBATCH --mem=8G
#SBATCH --partition=pibu_el8


export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

SAMPLE=$1
# Create the results directory
mkdir -p /data/users/mmaisyaroh/rnaseq/map/sam
cd /data/users/mmaisyaroh/rnaseq/map/sam

input_dir="/data/courses/rnaseq_course/breastcancer_de/reads"
reference_dir="/data/users/mmaisyaroh/rnaseq/map"
output_dir="/data/users/mmaisyaroh/rnaseq/map/sam"

apptainer exec -B ${input_dir}:/input_sample -B ${reference_dir}:/input_reference -B ${output_dir}:/output /containers/apptainer/hisat2_samtools_408dfd02f175cd88.sif hisat2 -x/input_reference/Homo_sapiens_GRCh38_index -1 /input_sample/${SAMPLE}_R1.fastq.gz -2 /input_sample/${SAMPLE}_R2.fastq.gz -S /output/${SAMPLE}.sam -p 8
