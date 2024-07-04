# Iterative_Pipeline

Set of bash scripts which iteratively feed your input PDB file through proteinMPNN before refolding with ESMFold. Output structures are scored by ESMFold's inherent confidence metrics, and then ranked, with the top scorer (through global assessment of confidence, pTM) being fed into the next iteration. Iteration brings about gross domain movements of PDB file, forming novel dimer interfaces with high confidence metrics. The pipeline can use input bias files, alongside fixing and omitting certain residues, to permit the resdesign of both soluble and transmembrane designs. Pipeline utilises python scripts hosted on UoB's HPC BC4.

Tutorial (non bias)
- Create JSON of input PDB file woth parse_multiple_chains.py
- Evaluate the run_mpnn and master_v4 submission scripts, select the batch sizes, redesign/fixed residues, omitted residues, sampling temperature etc..
- Run the master_v4 script in a directory alongside the mpnn & esm submission script, the JSON and the file esmfold_batch_scores_plots_ext.py. Easiest way to run the script is via 'nohup bash master_v4.sh &' so it can run in the background of your terminal

Tutorial (bias)
- from your JSON, create a bias script using the create_mpnn_bias.py script and a .txt bias file in the format as the example_bias.txt above. Call this biased file {protein name}_bias.JSON
- Use the master_bias.sh submission script, as this will carry the biased JSON through the iterations whereas the original master will not 

Update July24
- Updates to ESMFold, ProteinMPNN and the BC4 itself has stopped the current set of scripts from being able to run, so will be updated in due course so alternative MPNN models (soluble, ligand, membrane) can be integrated. 
