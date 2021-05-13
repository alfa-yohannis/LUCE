# Only for development use
# This script allows to quickly spin up and provision 
# LuceVM with just a single command

# ==== USAGE ====
# bash quickstart.sh

vagrant up && vagrant ssh -c 'bash prepare_system.sh && bash x_run_servers_tmux_v2.sh'