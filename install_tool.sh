#!/bin/bash
# Install script
# Author: DatBoyBlu3
# August 13, 2023

yes | sudo apt-get update
yes | sudo apt-get upgrade
yes | sudo apt-get install build-essential
yes | sudo apt-get install git
yes | sudo apt-get install curl
yes | sudo apt-get install vim
yes | sudo apt-get install net-tools
yes | sudo apt-get -y install python3-pip
yes | sudo apt-get install net-tools
yes | sudo apt-get install open-vm-tools
yes | sudo apt-get install open-vm-tools-desktop
yes | sudo apt-get install terminator
yes | sudo apt-get install openssh-client
yes | sudo apt-get install flameshot
yes | sudo apt-get install googler -y
yes | sudo apt-get install neofetch
yes | sudo apt-get install snapd
yes | sudo snap install btop
yes | sudo apt-get install tre-command
yes | sudo apt-get install tldr
yes | sudo apt-get install asciinema
yes | sudo apt-get install -y --no-install-recommends xz-utils liblz4-tool musl-tools
yes | sudo apt-get install duf
yes | bash <(curl -sL https://raw.githubusercontent.com/denisidoro/navi/master/scripts/install)
yes | sudo apt install gdebi -y

echo "Restart machine in 3...2...1.."
yes | sudo reboot
