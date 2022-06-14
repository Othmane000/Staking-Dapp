# Staking-Dapp
Staking dapp for generative python nfts


This project is for experimenting the creation of a NFT collection from scratch and learning about blokchain 
development. In this project I wrote a python script which creates random images each of them composed of
a different number of lines which all have different colors, thickness, lenght... This is meant to mimick the properties and traits aspects NFTs usually have. I uploaded the images to IPFS (using Pinata) and wrote a second python script that creates 
the json metadata files for each images using data that was retrieved from the first script and again upload them to IPFS.
After that we start writing the smart-contracts for minting one of these NFTs, staking them and getting ERC20 token rewards out of it. Then we create a simple frontend so that users can mint and stake NFTs. 
