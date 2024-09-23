#!/bin/bash

#SBATCH --partition=amilan
#SBATCH --job-name=get-bvbrc-metadata
#SBATCH --output=get-bvbrc-metadata.%j.out
#SBATCH --time=01:00:00
#SBATCH --qos=normal
#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --mail-type=ALL
#SBATCH --mail-user=katerina.terwelp@cuanschutz.edu


# run apptainer
apptainer run /projects/kterwelp@xsede.org/containers/singularity-cli-1.040.sif 

# set up user defined variables 
taxonIDs=(287 1280)

taxonNames=("Staphylococcus aureus" "Pseudomonas aeruginosa")

# set up automatic variables
drugFields="$(p3-get-genome-drugs --fields | tr '\n' ',')"
dataFields="$(p3-get-genome-data --fields | sed 's/([^)]*)//g' | tr '\n' ',' | sed 's/ ,/,/g')"

# determine genome counts 
for ID in "${taxonIDs[@]}"
do 
echo "Generating genomes for taxonID: $ID" 

p3-all-genomes \
--in taxon_id,"$ID" \
--eq genome_quality,Good \
--in genome_status,WGS,Complete > "${ID}.genomes.txt" 

done

for name in "${taxonNames[@]}"
do
echo "Generating genomes for taxonName: $name" 
nameFixed="${name// /-}"
echo "${nameFixed}.genomes.txt"

p3-all-genomes \
--eq "genome_name,${name}" \
--eq genome_quality,Good \
--in genome_status,WGS,Complete > "${nameFixed}.genomes.txt" 

done
