// SPDX-License-Identifier: MIT

pragma solidity ^0.8.14 ;


import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol" ;
//import "@openzeppelin/contracts/access/Ownable.sol";
import "Token20.sol";
import "NFT721.sol" ;



contract Staking721 is IERC721Receiver{
    
    Token20 token ;
    NFT721 NFT ;
    /*IERC721 public NFT ;
    IERC20 public token ; */

    constructor(Token20 _token, NFT721 _NFT){
        token = _token ;
        NFT = _NFT ;
        // make this contract admin of Token20.sol
        // make this contract approved in NFT721.sol
    }
    struct Stake {
            uint256 id ;
            uint256 timestamp ;
    }


    mapping(address => Stake) public stakes ;

    // this mapping will take care of checking how much time the address has staked one of her tokens.
    mapping(address => mapping(uint256 => uint256)) public amountTimeStaked ;
    
    mapping(uint256 => address) public ownerStakedNFTs ;

    function stake(uint256 tokenId) public {
        require(NFT.ownerOf(tokenId) == msg.sender, "You are not the owner of this NFT") ;
        stakes[msg.sender] = Stake(tokenId, block.timestamp);
        ownerStakedNFTs[tokenId] = msg.sender ;
        NFT.safeTransferFrom(msg.sender, address(this), tokenId, "0x00") ;
       
    }

    function unstake(uint256 tokenId) public {
        require(stakes[msg.sender].id == tokenId, "Please input NFT id that you own");
        token.getUserApproved(msg.sender, true) ;
        // to be able to mint tokens we need to be approved.
        NFT.safeTransferFrom(address(this), msg.sender, tokenId, "0x00");
        // will give us the time the token was staked in seconds.
        amountTimeStaked[msg.sender][tokenId] = (block.timestamp - stakes[msg.sender].timestamp) ;
        getReward(msg.sender, amountTimeStaked[msg.sender][tokenId]);
        token.getUserApproved(msg.sender, false) ;
        delete stakes[msg.sender] ;
    }

    function getReward(address recipient, uint256 amountTime) private {
        // reward rate : 3 tokens per 5 seconds 
        uint256 time = amountTime ;
        uint256 reward = 3*time ;
        token.mint(recipient, reward);
    }

    function getOwnerOfStakedNFT(uint256 tokenId) public view returns(address){
        require(ownerStakedNFTs[tokenId] != address(0), "This nft is not staked at the moment");
        return ownerStakedNFTs[tokenId] ;
    }

    function onERC721Received(
        address,
        address from,
        uint256,
        bytes calldata
    ) external pure override returns (bytes4) {
      return IERC721Receiver.onERC721Received.selector;
    }
}