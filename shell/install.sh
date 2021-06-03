#!/bin/bash

###
### Prepare Environment ###
###

### Setup Swap ###
sudo fallocate -l 4G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo "/swapfile none swap sw 0 0" | sudo tee -a /etc/fstab

### Install Library ###
sudo apt-get update
sudo apt-get install openssl libtool autoconf automake uuid-dev build-essential gcc g++ software-properties-common unzip make git libcap2-bin -y

### Install Golang
sudo add-apt-repository ppa:longsleep/golang-backports
sudo apt-get update
sudo apt-get install golang-go -y

### Setup TideBit Chain
mkdir ~/workspace
sudo mkdir ~/TideBit-Chaindata
cd ~/workspace
git clone https://github.com/BOLT-Protocol/TideBit-Chain
cd TideBit-Chain
make all
sudo ln -s ~/workspace/TideBit-Chain/build/bin/geth /usr/local/bin/
sudo ln -s ~/workspace/TideBit-Chain/build/bin/puppeth /usr/local/bin/
geth init genesis.json --datadir ~/TideBit-Chaindata
geth --datadir ~/TideBit-Chaindata --rpc --http --http.addr 0.0.0.0 --http.api debug,net,eth,shh,web3,txpool --ws --ws.addr 0.0.0.0 --ws.origins "*" --ws.port 8545 --ws.api eth,net,web3,network,debug,txpool --gcmode=archive
