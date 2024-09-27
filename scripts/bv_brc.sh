#!/bin/bash


# set up user defined variables 
taxonIDs=(287 1280)

taxonNames=("Staphylococcus aureus" "Pseudomonas aeruginosa")

# set up automatic variables
drugFields="$(p3-get-genome-drugs --fields | sed 's/([^)]*)//g' | tr '\n' ',' | sed 's/ ,/,/g')"
dataFields="$(p3-get-genome-data --fields | sed 's/([^)]*)//g' | tr '\n' ',' | sed 's/ ,/,/g')"

# acquire list of genomes using both methods

cd "$projectDir" 

mkdir -p "genomes" "metadata" 

for ID in "${taxonIDs[@]}"
do 
echo "Generating genomes for taxonID: $ID" 

p3-all-genomes \
--in taxon_id,"$ID" \
--eq genome_quality,Good \
--in genome_status,WGS,Complete > "genomes/${ID}.genomes.txt" 

done

for name in "${taxonNames[@]}"
do
echo "Generating genomes for taxonName: $name" 
nameFixed="${name// /-}"
echo "${nameFixed}.genomes.txt"

p3-all-genomes \
--eq "genome_name,${name}" \
--eq genome_quality,Good \
--in genome_status,WGS,Complete > "genomes/${nameFixed}.genomes.txt" 

done

# download metadata for drugs and genomes

for file in genomes/*
do 
echo "Downloading metadata for genomes in $file" 
name=$(basename "$file" ".genomes.txt")
echo "creating ${name}_data.tsv"

cat "$file" | \
p3-get-genome-data \
--attr $dataFields > "metadata/${name}_data.tsv"

echo "finished downloading ${name}_data.tsv" 

echo "creating ${name}_drug.tsv" 

cat "$file" | \
p3-get-genome-drugs \
--required resistant_phenotype \
--required antibiotic \
--attr $drugFields > "metadata/${name}_drug.tsv"

echo "finished downloading ${name}_drug.tsv" 

done
