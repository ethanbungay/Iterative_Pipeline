#!/bin/bash
#SBATCH --nodes=1
#SBATCH -p gpu
#SBATCH --gres=gpu:1
#SBATCH --time=1-00:00:00
#SBATCH --mem=50GB
#SBATCH --output=bias_esm
#SBATCH --account=chem023222
module purge
module load libs/fair-esm/2.0.0-python3.9.5
date
python esmfold_batch_scores_plots_ext.py big_fasta_clean.fa
date
