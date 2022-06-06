// SPDX-License-Identifier: MIT


pragma solidity ^0.8.14 ;


import "@openzeppelin/contracts/token/ERC721/ERC721.sol" ;
import "@openzeppelin/contracts/utils/Strings.sol";
//import "@openzeppelin/contracts/access/Ownable.sol";

contract NFT721 is ERC721 {

    uint256 public totalsupply = 0 ;
    uint256 maxTokensToMint;
    uint256 Supply ;
    mapping(uint256 => bool) public NFTstock ; // this will check if a token is available or not
    mapping(uint => address) private NFTOwner ;  // this will take care of associating a nft with its owner.
    constructor() ERC721("Othmane","TOTO"){
        Supply = 200 ;
        maxTokensToMint = 10 ;
    }

    

    function mint(uint amount) public{
        require(totalsupply < Supply, "No NFTs left to mint.") ;
        uint tokenId = totalsupply ;
        for (uint i = 1; i <= amount; i ++){
            _mint(msg.sender, (tokenId + i)) ;
            totalsupply += 1 ;
            NFTstock[tokenId] = false ;
            NFTOwner[tokenId] = msg.sender ;
        }
    }

}