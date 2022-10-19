// SPDX-License-Identifier: MIT

pragma solidity ^0.8.14 ;


import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol" ;
import "Token20.sol";
import "NFT721.sol" ;


// contract address (needs to be changed when contract deployed on Goerli) 0x3966791501F31f99c9EB26111ec17d5D5D6c01F5

/*  *************************************************************************************
    *Before doing anything, as the owner, setApprovalForAll(this-address, true) in both *
    *ERC20 and ERC721 contracts before proceding with any function call                 *
    *************************************************************************************   */



contract Staking721 is IERC721Receiver{
    
    Token20 token ;
    NFT721 NFT ;

    constructor(Token20 _token, NFT721 _NFT){
        token = _token ;
        NFT = _NFT ;
    /*  ************************************************
        * make this contract approved in Token20.sol      *
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
    mapping(address => mapping(uint256 => uint256)) public amountTimeStaked ;
    mapping(uint256 => address) public ownerNFTs ; // this helps for keeping track of the user who stacked an NFT (bcz now contract owns it)
    mapping(uint256 => bool) public IsNFTStaked ; //tokenID => true/false


    function stake(uint256 tokenID) public {
        // need to work on the error "ERC721: caller is not token owner nor approved" and where it is coming from
        // might be from the imported contracts : something in the original erc721 contract
        require(NFT.ownerOf(tokenID) == msg.sender, "You are not the owner of this NFT") ;
        NFT.safeTransferFrom(msg.sender, address(this), tokenID, "0x00") ;
        IsNFTStaked[tokenID] = true ;
        ownerNFTs[tokenID] = msg.sender ;
        stakes[msg.sender] = Stake(tokenID, block.timestamp);
        emit NFTStaked(tokenID, msg.sender, block.timestamp);
    }


    function unstake(uint256 tokenID) public {
        require(ownerNFTs[tokenID]==msg.sender, "Please input NFT id that you own");
        NFT.safeTransferFrom(address(this), msg.sender, tokenID, "0x00");
        IsNFTStaked[tokenID] = false ;
        getReward(tokenID);
        amountTimeStaked[msg.sender][tokenID] = 0 ;
        delete stakes[msg.sender] ;
        emit NFTUnstaked(tokenID, msg.sender, block.timestamp);
        
        
        // when unstaking you automatically get your rewards for the NFT you have unstaked
        
    }

    function getReward(uint256 tokenId) public {
        /* 
           This function will let you claim your rewards even if your nft is staked,
           In case you unstake your nft you will automatically get your rewards  
        */
        require(stakes[msg.sender].timestamp > 0, "NFT not staked at the moment");
        require(ownerNFTs[tokenId]==msg.sender, "not your NFT");
        // next line is to calculate total time staked
        amountTimeStaked[msg.sender][tokenId] = (block.timestamp - stakes[msg.sender].timestamp) ;
        uint256 reward = (amountTimeStaked[msg.sender][tokenId]/2) ; // 1 token per second
        if (NFT.ownerOf(tokenId) == address(this)){
            // the case in which the user retrieves his rewards and keeps his NFT staked
            stakes[msg.sender].timestamp = block.timestamp ;
            token.mint(msg.sender, reward) ;  
        } 
        else if(NFT.ownerOf(tokenId) == msg.sender) {
            // the aftermath of unstaking(implying transferring back NFT + getRewards) is done in unstake function
            token.mint(msg.sender, reward) ;
        }
        else {
           revert("Error while trying to get Rewards, check if this NFT is yours...");
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