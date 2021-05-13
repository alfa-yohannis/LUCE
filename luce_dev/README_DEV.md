# LuceVM & Technical Prototype

This repository contains LuceVM, a self-contained virtual machine to facilitate web3 development using the python stack. LuceVM allows to compile, deploy and interact with Ethereum Smart Contracts from a Python environment in a seamless manner.

The repository also contains supporting content and documentation materials I use in the process of building the technical prototype of the LUCE infrastructure. At this point all content in this repository is primarly to facilite the implementation of my master thesis and not (yet) optimised for wider useage.

## Usage of LuceVM

* First make sure [VirtualBox](https://www.virtualbox.org/) and [Vagrant](https://www.vagrantup.com/) are installed
  * On macOS High Sierra and Mojave the VirtualBox installation may fail
  * [This blog post](https://medium.com/@DMeechan/fixing-the-installation-failed-virtualbox-error-on-mac-high-sierra-7c421362b5b5) explains how to fix that
  * On Windows, ensure that [Hyper-V is enabled](https://www.vagrantup.com/docs/hyperv/)
* Check if `git` is installed and if not install from [here](https://git-scm.com)
  * To check if git is installed run `git --version` in the terminal 
  * If it is installed it will return the version number
* Then clone the LUCE base folder from github and set up the VM as follows:

```bash
cd ~/path/to/desired/location/
git clone https://github.com/arnoan/LUCE.git
cd ./LUCE/luce_vm 
vagrant up # start the VM
vagrant ssh # ssh into the VM
bash prepare_system.sh
bash run_servers_tmux.sh # Start the servers
```
Then interface with server from host system via `http://127.0.0.1:8888` with password `luce`.

## Further Information
(Note: This section is still under development.) 

*Q: How do I stop the machine when I am finished working?*   
From within the LuceVM terminal:
```bash
Ctrl + d # to exit the active conda environment 
Ctrl + d # to exit the ssh session (LuceVM and the servers are still running)
```
Then from the host terminal prompt:
```
vagrant suspend
```
This hibernates the virtual machine. That way the next time it is started via `vagrant up` it will be exactly in the same state again and there is no need to repeat any of the inital setup steps.  

*Q: How do I stop the machine completely?*   
The machine can be shut down completely via `vagrant halt` - in that case the servers have to be started again the next time LuceVM is booted. Finally `vagrant destroy` can be used to completely destroy the virtual machine instance. That way the next time the machine is provisioned the full setup process will need to be performed again. (The python notebooks are still preserved even if the machine is destroyed as they live outside the filesystem of the VM.)

*Q: How can I update to the latest data contained in this github repository?*  
To update, first navigate to your local LUCE folder: `cd ~/path/to/LUCE/`  
Then run the following in the terminal:  
```bash
git fetch origin # this downloads all new content from github
git reset --hard origin/master # this replaces all local LUCE content with the newest updates
```

**Warning:** Note that by running `git reset` all LUCE files that may have been changed locally will be overwritten with the latest version from Github. In order to experiment locally with Jupyter notebooks without the possibility of them accidentally being over-written I created the `/jupyter/safe_storage_area/` folder. This folder is not synced with the github repository. Not even when `git reset` is executed. Please keep files you wish to keep safe in there.
