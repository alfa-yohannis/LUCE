docker pull interledgerrs/ilp-node
docker pull interledgerrs/ilp-cli
### This command is commented since we are going to use docker container that has been modified 
### to transfer money directly to a smart contract. The container can be downloaded from here
### https://github.com/alfa-yohannis/settlement-engines. Build the docker container 
### to be able to use it.
# docker pull interledgerrs/ilp-settlement-ethereum 
docker pull trufflesuite/ganache-cli
docker pull interledgerjs/settlement-xrp
docker pull redis
