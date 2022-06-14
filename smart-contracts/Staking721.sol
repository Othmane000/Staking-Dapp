// SPDX-License-Identifier: MIT

pragma solidity ^0.8.14 ;


import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol" ;
import "Token20.sol";
import "NFT721.sol" ;


/* ***************************************************
   * This contract is uncomplete -                   *
   * first version already deployed at this address :*
   * 0x57A0B2876391d34D9Afc804E64477211aB518640      *
   ***************************************************   */


contract Staking721 is IERC721Receiver{
    
    Token20 token ;
    NFT721 NFT ;

    constructor(Token20 _token, NFT721 _NFT){
        token = _token ;
        NFT = _NFT ;
    /*  ************************************************
        * make this contract admin of Token20.sol      *
        * make this contract approved in NFT721.sol    *
        ************************************************ */
    }  


    struct Stake {
            uint256 id ;
            uint256 timestamp ; // which represents the time it was staked at
    }

    event NFTStaked(
        uint256 indexed tokenID,
        address indexed owner,
        uint256 indexed timestamp
    );
    
    event NFTUnstaked(
        uint256 indexed tokenID,
        address indexed owner,
        uint256 indexed timestamp
    );

    mapping(address => Stake) public stakes ;

    // this mapping will take care of checking how much time the address has staked one of her tokens.
    mapping(address => mapping(uint256 => uint256)) public amountTimeStaked ;
    
    mapping(uint256 => address) public ownerNFTs ; // this helps for keeping track of the user who stacked an NFT (bcz now contract owns it)

    function stake(uint256 tokenId) public {
        require(NFT.ownerOf(tokenId) == msg.sender, "You are not the owner of this NFT") ;
        stakes[msg.sender] = Stake(tokenId, block.timestamp);
        ownerNFTs[tokenId] = msg.sender ;
        NFT.safeTransferFrom(msg.sender, address(this), tokenId, "0x00") ;
        emit NFTStaked(tokenId, msg.sender, block.timestamp);
    }


    function unstake(uint256 tokenID) public {
        require(ownerNFTs[tokenID]==msg.sender, "Please input NFT id that you own");
        NFT.safeTransferFrom(address(this), msg.sender, tokenID, "0x00");
        amountTimeStaked[msg.sender][tokenID] = (block.timestamp - stakes[msg.sender].timestamp) ;
        delete stakes[msg.sender] ;
        emit NFTUnstaked(tokenID, msg.sender, block.timestamp);
    }

    function getReward(uint256 tokenId) external {
        require(ownerNFTs[tokenId]==msg.sender, "not your NFT");
        require(amountTimeStaked[msg.sender][tokenId] >=10, "NFT not staked enough time");
        if (NFT.ownerOf(tokenId) == address(this)){
            amountTimeStaked[msg.sender][tokenId] = (block.timestamp - stakes[msg.sender].timestamp) ;
            uint256 time = amountTimeStaked[msg.sender][tokenId] ;
            uint256 reward = time*3 ; // 3 tokens per seconds
            token.mint(msg.sender, reward) ;
            stakes[msg.sender].timestamp = block.timestamp ;
        } 
        else {
            uint256 time = amountTimeStaked[msg.sender][tokenId] ;
            uint256 reward = time*3 ; // 3 tokens per seconds
            token.mint(msg.sender, reward) ;
        }
        
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