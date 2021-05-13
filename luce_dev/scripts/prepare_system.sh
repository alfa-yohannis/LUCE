#!/usr/bin/env bash

# Bash commands to run after the VM has started

# Refresh repository index
sudo apt-get update

# Install GNU compiler utitilities 
# (required for web3, psycopg2 (PostgreSQL) and web3-auth) 
sudo apt --assume-yes install build-essential

# Install the latest OpenSSL libraries (for Django-Web3-Auth)
sudo apt --assume-yes install libssl-dev

# ==== INSTALL MINICONDA ====

# 1) Download installer script
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /home/vagrant/miniconda.sh

# 2) Install miniconda
bash /home/vagrant/miniconda.sh -b -p /home/vagrant/miniconda

# 3) Add to path and initialize
eval "$(/home/vagrant/miniconda/bin/conda shell.bash hook)"
conda init
source /home/vagrant/.bashrc

# 4) Clean up 
rm /home/vagrant/miniconda.sh

# ==== CONDA ENVIRONMENT ====

# Set up new conda environment
conda create -y --name luce_vm python

# Activate environment
conda activate luce_vm

# ==== INSTALL JUPYTER & KERNEL ====

# Install Jupyter
conda install -y jupyter

# 2019-07-25 Update:
# Jupyter notebook v6 was just released and breaks all extensions
# Downgrade to latest release of v5 to keep things functioning
conda install -y notebook=5.7.8

# Set up jupyter kernel for luce python environment
# The custom kernel allows us to introduce environment variables 
# for access to the Django context from within Jupyter
# pip install ipykernel
python -m ipykernel install --user --name=luce_vm

# Update the jupyter custom kernel configuration
# This allows to make the Django context availabe to luce_vm kernel via environment variables
cp /vagrant/.config/luce_jupyter_kernel.json /home/vagrant/.local/share/jupyter/kernels/luce_vm/

# Install Jupyter Notebook Extensions
conda install -y -c conda-forge jupyter_contrib_nbextensions

# Configure Jupyter Extensions
# Table of Contents
jupyter nbextension enable toc2/main
# Variable Inspector
jupyter nbextension enable varInspector/main
# Scratchpad (Ctrl+B)
jupyter nbextension enable scratchpad/main
# Python Markdown {{ var }} in md cells
jupyter nbextension enable python-markdown/main


# ==== INSTALL WEB3 ====

pip install web3
pip install py-solc-x

# ==== INSTALL SOLIDITY COMPILER ====

# We use the py-colc-x package from the command line to install the solidity compiler
# v0.4.25 is the latest stable v4 version available on github
python -m solcx.install v0.4.25


# ==== INSTALL NODE.JS AND GANACHE ====

# 1) Install Node Version Manager
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash
export NVM_DIR="/home/vagrant/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# 2) Install node.js
nvm install node 

# 3) Install Ganache
npm install -g ganache-cli


# ==== INSTALL DJANGO ====

pip install django==2.2
# pip install pillow # for image processing
pip install django-extensions

# # Django-web3-auth:
# git clone https://github.com/sanosano/django-web3-auth
# cd django-web3-auth/example
# pip install -r requirements.txt

# ==== INSTALL PostgreSQL CLI Client ====
sudo apt install -y postgresql-client

# Install psycopg2 package (Python interface to psql)
conda activate luce_vm
conda install -y psycopg2

# ==== INCLUDE TIMESTAMP ====

# Set system preparation timestamp:
SYSTEM_PREPARED_STAMP=/home/vagrant/.stamps/vagrant_system_prepared_timestamp
date > "$SYSTEM_PREPARED_STAMP"

# ==== SET DEFAULT CONDA ENVIRONMENT ====

echo "conda activate luve_vm" >> /home/vagrant/.bashrc

# ==== COMPLETION MESSAGE ====

echo
echo "Thank you for your patience =)"
echo "The LuceVM environment is ready now"
echo
echo "Please run the following command to start the servers:"
echo "$ bash run_servers_tmux.sh"

# echo "Please run the following command to finalise the setup:"
# echo "$ source ~/.bashrc"
# exec bash

# echo
# echo "Open http://127.0.0.1:4567 in your browser for further instructions on how to continue."