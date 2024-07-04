# Iterative_Pipeline

Set of bash scripts which iteratively feed your input PDB file through proteinMPNN before refolding with ESMFold. Output structures are scored by ESMFold's inherent confidence metrics, and then ranked, with the top scorer (through global assessment of confidence, pTM) being fed into the next iteration. Iteration brings about gross domain movements of PDB file, forming novel dimer interfaces with high confidence metrics. The pipeline can use input bias files, alongside fixing and omitting certain residues, to permit the resdesign of both soluble and transmembrane designs. Pipeline utilises python scripts hosted on UoB's HPC BC4.

Update July24
- Updates to ESMFold, ProteinMPNN and the BC4 itself has stopped the current set of scripts from being able to run, so will be updated in due course so alternative MPNN models (soluble, ligand, membrane) can be integrated. 
