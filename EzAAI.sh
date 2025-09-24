#!/bin/bash
# ============================================================================================
#title          :EzAAI.sh
#description    :For phylogenomic tree https://merenlab.org/2017/06/07/phylogenomics/
#author         :Justus Nweze
#date           :2025-06-09
#version        :v1
#usage          : 
# ============================================================================================
# EzAAI: High Throughput Prokaryotic AAI Calculator
# 
# EzAAI is a suite of workflows for accelerated Average Amino Acid Identity (AAI) calculation 
# and includes modules for hierarchical clustering and dendrogram generation.
# ============================================================================================

# ------------------------------------------
# Step 1: Create environment and install EzAAI
# ------------------------------------------

# Create and activate conda environment
# conda create --name EzAAI
# conda install -c bioconda -y ezaai

conda activate EzAAI
# Use conda deactivate when you're done
# conda deactivate

# ------------------------------------------
# Step 2: Extract protein databases using Prodigal
# ------------------------------------------

# EzAAI extract:
# This step extracts protein profiles from genome assemblies (.fa or .fna) using Prodigal.
# Each input FASTA file is converted into a .db file for downstream AAI comparison.

# Set up output directory
mkdir -p ~/proj/Peat_soil/Methylobacter_hq_nr/Data/AAI/DB_output

# Move to the directory containing input genome assemblies
cd ~/proj/Peat_soil/Methylobacter_hq_nr/Data/Proteins

# Loop over all fasta files and extract protein databases
for file in *.fa; do
    EzAAI extract -i "$file" \
                  -o ../AAI/DB_output/"${file%.fa}.db" \
                  -l "${file%.*}"
done

# ------------------------------------------
# Step 3: Calculate pairwise AAI values using MMseqs2
# ------------------------------------------

# Set up output directory for AAI results
mkdir -p ~/proj/Peat_soil/Methylobacter_hq_nr/Data/AAI/AAI_out

# Run EzAAI calculate:
# This command computes pairwise AAI values between all .db files using MMseqs2
cd ~/proj/Peat_soil/Methylobacter_hq_nr/Data/AAI

EzAAI calculate -i DB_output/ \
                -j DB_output/ \
                -o AAI_out/aai.tsv

# Arguments:
# -i : Directory containing first set of .db profiles
# -j : Directory containing second set of .db profiles (can be same as -i)
# -o : Output file containing AAI matrix in TSV format

# ------------------------------------------
# Step 4: Hierarchical clustering and dendrogram generation
# ------------------------------------------

# Create output directory for clustering results
mkdir -p ~/proj/Peat_soil/Methylobacter_hq_nr/Data/AAI/AAI_Cluster

# Run EzAAI cluster:
# This generates a Newick-format dendrogram (.nwk) based on pairwise AAI values
EzAAI cluster -i AAI_out/aai.tsv \
              -o AAI_Cluster/sample.nwk
