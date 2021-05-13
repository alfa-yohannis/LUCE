#!/usr/bin/env bash
# This script starts the jupyter and ganache server processes in the background

# Gently shutdown old processes
tmux kill-session -t "jupyter_ganache_django"

# Create detached tmux session from terminal
tmux new-session -d -s jupyter_ganache_django
tmux rename-window 'jupyter_ganache_django'

# Send in commands to start Jupyter Server
tmux send-keys -t jupyter_ganache_django.0 'eval "$(conda shell.bash hook)"' ENTER
tmux send-keys -t jupyter_ganache_django.0 'conda activate luce_vm' ENTER
tmux send-keys -t jupyter_ganache_django.0 'jupyter notebook --no-browser --ip 0.0.0.0 --notebook-dir=/vagrant/jupyter/' ENTER

# Select first window in session and split it
tmux select-window -t jupyter_ganache_django:0
tmux split-window -v

# Send in commands to start Ganache Server
tmux send-keys -t jupyter_ganache_django.1 'eval "$(conda shell.bash hook)"' ENTER
tmux send-keys -t jupyter_ganache_django.1 'conda activate luce_vm' ENTER
tmux send-keys -t jupyter_ganache_django.1 'ganache-cli --mnemonic luce --host 0.0.0.0 --accounts 3 --defaultBalanceEther 1000000' ENTER

# Split window once again
tmux split-window -v

# Send in commands to start Django Server
tmux send-keys -t jupyter_ganache_django.2 'eval "$(conda shell.bash hook)"' ENTER
tmux send-keys -t jupyter_ganache_django.2 'conda activate luce_vm' ENTER
tmux send-keys -t jupyter_ganache_django.2 'python /vagrant/luce_django/luce/manage.py runserver 0.0.0.0:8000 --noreload' ENTER

echo
printf "The Jupyter, Ganache and Django servers are running...\n\n"

printf "This terminal window which runs the LuceVM and 
server processes can now be minimised to the background\n\n"

printf "Visit http://127.0.0.1:4567 on your host machine 
browser for further instructions on how to continue\n\n"

printf "Or you can directly visit http://127.0.0.1:8888 to access 
the jupyter notebook environment which contains example python code 
The password is: luce\n"
echo

echo "The ganache blockchain is available via http://127.0.0.1:8545"
echo "Open http://127.0.0.1:8888 to access the LUCE Web Interface"


# Attach session for quick debugging
#tmux attach-session -t jupyter_ganache_django

# The following resource helped me greatly in getting this script to work:
# https://stackoverflow.com/questions/5447278/bash-scripts-with-tmux-to-launch-a-4-paned-window