#!/bin/bash
# Install script
# Author: DatBoyBlu3
# August 13, 2023

sudo apt-get update && sudo apt-get update
sudo apt install build-essential
sudo apt-get install curl
sudo apt-get install vim
sudo apt-get install net-tools
sudo apt-get install python3-pip
sudo apt-get install net-tools
sudo apt-get install open-vm-tools
sudo apt-get install open-vm-toolls-dekstop
sudo apt-get install terminator
sudo apt-get install openssh-client
sudo apt-get install flameshot
sudo apt-get install googler -y
sudo apt-get install neofetch
sudo apt-get install snapd
sudo snap install btop
sudo apt-get install duf
sudo snap install tldr
sudo apt-get install tre
sudo pip3 install asciinema
sudo apt-get install -y --no-install-recommends xz-utils liblz4-tool musl-tools

bash <(curl -sL https://raw.githubusercontent.com/denisidoro/navi/master/scripts/install)

