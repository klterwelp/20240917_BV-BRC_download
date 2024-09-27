#!/bin/bash


# set up automatic variables
drugFields="$(p3-get-genome-drugs --fields | sed 's/([^)]*)//g' | tr '\n' ',' | sed 's/ ,/,/g')"
dataFields="$(p3-get-genome-data --fields | sed 's/([^)]*)//g' | tr '\n' ',' | sed 's/ ,/,/g')"


# download metadata for drugs

for file in genomes/*
do 
name=$(basename "$file" ".genomes.txt")

echo "creating ${name}_drug.tsv" 

cat "$file" | \
p3-get-genome-drugs \
--required resistant_phenotype \
--required antibiotic \
--attr $drugFields > "metadata/${name}_drug.tsv"

echo "finished downloading ${name}_drug.tsv" 

done
