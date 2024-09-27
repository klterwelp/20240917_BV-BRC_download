#!/bin/bash

#SBATCH --partition=amilan
#SBATCH --job-name=get-bvbrc-metadata
#SBATCH --output=../log/get-bvbrc-metadata.%j.out
#SBATCH --time=03:00:00
#SBATCH --qos=normal
#SBATCH --nodes=1
#SBATCH --ntasks=2
#SBATCH --mail-type=ALL
#SBATCH --mail-user=katerina.terwelp@cuanschutz.edu

projectDir="/projects/kterwelp@xsede.org/20240917_BV-BRC-genomes" 

cd "$projectDir"
# run apptainer prior to starting job
apptainer run "/projects/kterwelp@xsede.org/containers/singularity-cli-1.040.sif" "$projectDir/scripts/bv_brc_drugs.sh" 
