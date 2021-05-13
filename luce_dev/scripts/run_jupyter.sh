#!/usr/bin/env bash

# Make conda environment commands available in shell script
eval "$(conda shell.bash hook)"

# Ensure correct environment is activated
conda activate luce_vm

# Run Jupyter notebook server
jupyter notebook --no-browser --ip 0.0.0.0 --NotebookApp.token="luce" --notebook-dir=/vagrant/jupyter/