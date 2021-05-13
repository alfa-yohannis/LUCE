#!/usr/bin/env bash

# Bash commands to run during VM initialization

# ==== CUSTOM MOTD ====
rm /etc/update-motd.d/*
cp /vagrant/.config/luce_motd /etc/update-motd.d/00-header


# ==== INSERT CUSTOM  SCRIPTS ====
# Copy scripts to vagrant home directory
cp /vagrant/scripts/* /home/vagrant


# ==== INSTALL APACHE ====

# Install apache web sever
apt-get install -y apache2
if ! [ -L /var/www ]; then
  rm -rf /var/www
  ln -fs /vagrant /var/www
fi


# ==== JUPYTER PRE-CONFIGURATION ====

# Jupyter configuration file - define hashed password for notebook access
mkdir -p /home/vagrant/.jupyter && cp /vagrant/.config/jupyter_notebook_config.py $_
# Custom logo for Jupyter
mkdir -p /home/vagrant/.jupyter/custom && cp /vagrant/.config/custom.css $_
cp /vagrant/.config/logo.png /home/vagrant/.jupyter/custom
# Change folder permissions
sudo chown -R vagrant:vagrant /home/vagrant/.jupyter



# ==== INCLUDE GANACHE DEFAULT DEMO STATE ====
# Create folder to store ganache state
mkdir -p /home/vagrant/.ganache_db
cp /vagrant/.config/ganache_db/* /home/vagrant/.ganache_db
# Change folder permissions
sudo chown -R vagrant:vagrant /home/vagrant/.ganache_db

# Create another folder for reset while lucevm is running
mkdir -p /home/vagrant/.ganache_db_default
cp /vagrant/.config/ganache_db/* /home/vagrant/.ganache_db_default
sudo chown -R vagrant:vagrant /home/vagrant/.ganache_db_default


# ==== INCLUDE TIMESTAMPS FOR PROVISIONING LOGIC ====

# Set provisioning timestamp:
LAST_PROVISIONED_STAMP=/etc/vagrant_last_provisioned_timestamp
date > "$LAST_PROVISIONED_STAMP"

# If file (provisioning stamp) already exists
# if [ -f "$LAST_PROVISIONED_STAMP" ]
# then
# echo "VM was already provisioned"
# fi

# Create ~/.stamps folder for timestamps used by later scripts
# Other scripts do not have access privileges for /etc
mkdir -p /home/vagrant/.stamps
# Change folder permissions
sudo chown -R vagrant:vagrant /home/vagrant/.stamps
# Create stamp
date > "/home/vagrant/.stamps/vagrant_last_provisioned_timestamp"