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
mkdir ~/TideBit-Chaindata
cd ~/workspace
git clone https://github.com/BOLT-Protocol/TideBit-Chain
cd TideBit-Chain
make all
sudo ln -s ~/workspace/TideBit-Chain/build/bin/geth /usr/local/bin/
sudo ln -s ~/workspace/TideBit-Chain/build/bin/puppeth /usr/local/bin/
geth init ~/workspace/TideBit-Chain/genesis.json --datadir ~/TideBit-Chaindata
geth --bootnodes enode://049574c863b614e51b28ecba8e9088d414b57d2baba4b278faeefb5dba45d1a1d2269885bae42f7d8a3bd088bce59f21e6df2308b472279134b8902af44e8a9d@3.237.19.51:30303
geth --datadir ~/TideBit-Chaindata --rpc --http --http.addr 0.0.0.0 --http.api debug,net,eth,shh,web3,txpool --ws --ws.addr 0.0.0.0 --ws.origins "*" --ws.port 8545 --ws.api eth,net,web3,network,debug,txpool --gcmode=archive
