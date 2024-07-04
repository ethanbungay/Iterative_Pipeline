# Iterative_Pipeline

Set of bash scripts which iteratively ffed your input PDB file through proteinMPNN before refolding with ESMFold. Output structures are scored by ESMFold's inherent confidence metrics, and then ranked, with the top scorer (through global assessment of confidence, pTM) being fed into the next iteration. The pipeline can use input bias files, alongside fixing and omitting certain residues, to permit the resdesin of both soluble and transmembrane designs. Pipeline utilises python scripts hosted on UoB's HPC BC4.
