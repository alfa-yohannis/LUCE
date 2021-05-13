#!/usr/bin/env bash

# Bash commands to re-initialise django system after database refresh

# Make conda environment commands available in shell script
eval "$(/home/vagrant/miniconda/bin/conda shell.bash hook)"

# Activate environment
conda activate luce_vm

# Initialise new database
python /vagrant/luce_django/luce/manage.py migrate

# Create superuser
echo "from django.contrib.auth import get_user_model; User = get_user_model(); User.objects.create_superuser('vagrant@luce.com','Vagrant','Luce','Maastricht University','vagrant')" | python /vagrant/luce_django/luce/manage.py shell

# Load in demo data 
# 3 users, 7 datasets (5 published, 2 unpublished)
python /vagrant/luce_django/luce/manage.py loaddata /vagrant/luce_django/luce/utils/fixtures/demo_all_v2.json

# ==== INCLUDE TIMESTAMP ====

# Set system preparation timestamp:
DJANGO_PREPARED_STAMP=/home/vagrant/.stamps/vagrant_django_prepared_timestamp
date > "$DJANGO_PREPARED_STAMP"

# ==== COMPLETION MESSAGE ====

echo
echo "Successfully ran database migrations"
echo "The vagrant superuser was created"
echo
echo "Please run the following command to start the servers:"
echo "$ bash run_servers_tmux.sh"