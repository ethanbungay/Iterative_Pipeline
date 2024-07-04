#!/bin/bash

##########################################################################################################################
####################### Set {Protein_Name}, Fixed Residues & Script names (if changed) ###################################
##########################################################################################################################
protein_name="CytbX-F1-CytbX"
##########################################################################################################################
##########################################################################################################################
##########################################################################################################################


#define functions

wait_for_lines() {
    file_path="seqs/${protein_name}${i}.fa"  # Replace with the path to your file
    #desired_lines=20  # Replace with the desired number of lines

    while true; do
        current_lines=$(wc -l < "$file_path")

        if [ "$current_lines" -ge "$desired_lines" ]; then
            echo "Desired number of lines reached: $current_lines"
            break
        else
            echo "Current number of lines: $current_lines. Waiting..."
            sleep 60  # Adjust the sleep duration as needed (in seconds)
        fi
    done
}
wait_for_pdb_files() {
    dir_path="./"  # Replace with the path to your directory
    desired_files=100  # Replace with the desired number of .pdb files

    while true; do
        current_files=$(find "$dir_path" -type f -name "*.pdb" | wc -l)

        if [ "$current_files" -ge "$desired_files" ]; then
            echo "Desired number of .pdb files reached: $current_files"
            break
        else
            echo "Current number of .pdb files: $current_files. Waiting..."
            sleep 60  # Adjust the sleep duration as needed (in seconds)
        fi
    done
}

# loop to create and populate folders for each cycle iteration
# if it is the first loop, then copy the starting structure into the first folder

#min_cycles=1
#max_cycles=3

mkdir design_trajectory

for i in {1..10}
do
    mkdir "cycle${i}"
    mkdir "cycle${i}/ProteinMPNN"
    mkdir "cycle${i}/ProteinMPNN/Inputs"
    mkdir "cycle${i}/ESMfold"
    cp run_bias_mpnn.sh "cycle${i}/ProteinMPNN"
    cp CytbX-F1-CytbX_bias.json "cycle${i}/ProteinMPNN"
    sed -i "s/CytbX-F1-CytbX/CytbX-F1-CytbX${i}/" "cycle${i}/ProteinMPNN/CytbX-F1-CytbX_bias.json"
    cp esmfold_batch_scores_plots_ext.py "cycle${i}/ESMfold"
    cp run_esm.sh "cycle${i}/ESMfold"

    #copy starting structure into first folder
    if [ $i -eq 1 ]; then
        cp ${protein_name}.pdb "cycle1/ProteinMPNN/Inputs/${protein_name}${i}.pdb"
    fi
done

#move to first folder
cd cycle1

total_structures=100
desired_lines=$((2 + (2*total_structures)))

#run iterations of ProteinMPNN and ESMfold
for i in {1..10}
do
    echo "Running Iteration $i"     # we are in folder i
    cd ProteinMPNN
    sbatch run_bias_mpnn.sh      # output = a big fasta file

    wait_for_lines protein_name

    sed -e 's/\//:/g' -e 's/[^A-Za-z0-9._>:-]/_/g' -e 's/\./-/g' seqs/${protein_name}${i}.fa > seqs/big_fasta_clean.fa    # changes "/" to ":", and cleans name
    sed -i -e 1,2d seqs/big_fasta_clean.fa            # removes first 2 lines containing original sequence and name
    cp seqs/big_fasta_clean.fa ../ESMfold
    cd ../ESMfold
    sbatch run_esm.sh         # output = lots of PDBs, JSONs, pTM_pLDDT_report.csv

    wait_for_pdb_files
    sort -k4 -r pTM_pLDDT_report.dat | head -n 1 | awk '{print $2}' > top_pTM_name.txt
    top_name=$(cat top_pTM_name.txt)

    if [[ $i -lt 10 ]]
    then
        cp ${top_name}.pdb ../../cycle$((i+1))/ProteinMPNN/Inputs/${protein_name}$((i+1)).pdb          # copy best pTM PDB to next ProteinMPNN cycle
        cp ${top_name}.pdb ../../design_trajectory/cycle${i}.pdb        # save current best pTM PDB to the trajectory file
        cp ${top_name}.json ../../design_trajectory/cycle${i}.json
        cd ../../cycle$((i+1))
    else
        cp ${top_name}.pdb ../../design_trajectory/cycle${i}.pdb
	cp ${top_name}.json ../../design_trajectory/cycle${i}.json   
     echo "done"
    fi
done
