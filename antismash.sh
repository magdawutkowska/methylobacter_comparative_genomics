#!/bin/bash -   
#title          :antismash.sh
#description    :antiSMASH - the antibiotics and Secondary Metabolite Analysis SHell
#author         :Justus Nweze
#date           :2024.02.01
#version        :v1
#usage          :Go to the Analysis folder and run ./Antismash.sh
#==============================================================================================

# Define directories for input and output files
GENOME_DIR="/proj/Peat_soil/Methylobacter_hq_nr/Data/Proteins"
OUTPUT_DIR="/proj/Peat_soil/Methylobacter_hq_nr/Data/prokka_results2"

# Activate Prokka environment
conda activate prokka_env

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Loop through all FASTA files in the genome directory
for fa in "$GENOME_DIR"/*.fa; do
    base_name=$(basename "$fa" .fa)  # Extract genome name without extension
    echo "Annotating $base_name with Prokka..."
    
    # Run Prokka
    prokka --outdir "$OUTPUT_DIR/$base_name" \
           --prefix "$base_name" \
           --genus Bacteria \
           --force "$fa" \
           --usegenus 
done

# Activate antiSMASH environment
conda activate antismash

# Define directories for antiSMASH analysis
GENOME_DIR="/proj/Peat_soil/Methylobacter_hq_nr/Data/prokka_results"
OUTPUT_DIR="/proj/Peat_soil/Methylobacter_hq_nr/Data/antismash_results"

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Loop through all .gbk files in the directory
for genome in $GENOME_DIR/*/*.gbk; do
    # Extract the base name of the file (without .gbk extension)
    base_name=$(basename "$genome" .gbk)
    echo "Processing $base_name with antiSMASH..."
    
    # Run antiSMASH
    antismash "$genome" --output-dir "$OUTPUT_DIR/$base_name" \
                        --genefinding-tool prodigal \
                        --cpus 20 \
                        --hmmdetection-strictness loose \
                        --cb-knownclusters \
                        
done

