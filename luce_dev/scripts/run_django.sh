#!/usr/bin/env bash

# Make conda environment commands available in shell script
eval "$(conda shell.bash hook)"

# Ensure correct environment is activated
conda activate luce_vm

# Run Django server
python /vagrant/luce_django/luce/manage.py runserver 0.0.0.0:8000 --noreload
