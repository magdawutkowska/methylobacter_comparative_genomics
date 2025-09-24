#!/bin/bash -   
#title          :DRAM (Distilled and Refined Annotation of Metabolism)
#Current Version: 
#description    :a tool for annotating metagenomic assembled genomes and VirSorter identified viral contigs. DRAM annotates MAGs and viral contigs using KEGG (if provided by the user), UniRef90, PFAM, dbCAN, RefSeq viral, VOGDB and the MEROPS peptidase database as well as custom user databases.
#author         :Justus Nweze
#date           :20221208
#usage          : before running this script

#==================================================================================================================
    logFile="30_DRAM.log"
#==================================================================================================================
#    wget https://raw.githubusercontent.com/shafferm/DRAM/master/environment.yaml
#    conda env create -f environment.yaml -n myDRAM
#==================================================================================================================
#           Running the program
#==================================================================================================================
# Change to your working directory
    cd /proj/Peat_soil/Methylobacter_hq_nr/Data/DRAM &&

# Activate metabolic working environment    
#    conda activate myDRAM

    conda activate myDRAM   
# Bins MUST have file extension of fasta or fna    
    DRAM.py annotate -i 'Reformatted/*.fa' -o DRAM_anno --threads 8
   

#summarize the annotations with 
    DRAM.py distill -i DRAM_anno_default/annotations.tsv -o DRAM_anno_default/genome_summaries --trna_path DRAM_anno_default/trnas.tsv --rrna_path DRAM_anno_default/rrnas.tsv
