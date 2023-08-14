#!/bin/bash
# Install script
# Author: DatBoyBlu3
# August 13, 2023

yes | sudo apt-get update && sudo apt-get update
yes | sudo apt install build-essential
yes | sudo apt-get install git
yes | sudo apt-get install curl
yes | sudo apt-get install vim
yes | sudo apt-get install net-tools
yes | sudo apt-get -y install python3-pip
yes | sudo apt-get install net-tools
yes | sudo apt-get install open-vm-tools
yes | sudo apt-get install open-vm-toolls-dekstop
yes | sudo apt install terminator
yes | sudo apt-get install openssh-client
yes | sudo apt install flameshot
yes | sudo apt-get install googler -y
yes | sudo apt install neofetch
yes | sudo apt-get install snapd
yes | sudo snap install btop
yes | sudo apt-get install tre-command
#yes | sudo apt-get install duf
yes | sudo apt-get install tldr
yes | sudo pip3 install asciinema
yes | sudo apt-get install -y --no-install-recommends xz-utils liblz4-tool musl-tools
yes | 
yes | bash <(curl -sL https://raw.githubusercontent.com/denisidoro/navi/master/scripts/install)

#The below is a dependency to downlaod tre
#sudo git clone https://github.com/dduan/tre.git
#cd tre/
#sudo curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
#Put tre in PATH variable
# EXAMPLE: export PATH=$PATH:/home/jdoe/myscripts

