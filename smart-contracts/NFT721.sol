// SPDX-License-Identifier: MIT


pragma solidity ^0.8.14 ;


import "@openzeppelin/contracts/token/ERC721/ERC721.sol" ;
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFT721 is ERC721, Ownable {

    uint256 public totalsupply = 0 ;
    uint256 public maxSupply ;
    uint256 public price = 0.01 ether ; // 0.01 ether -> 30000000000000000 wei 
    
    mapping(uint256 => bool) public NFTstock ; // this will check if a token is available or not
    mapping(address => bool) public approval ;

    event NFTminted(
        uint256 indexed tokenid,
        uint256 indexed timestamp,
        address indexed minter,
        uint256 numberOfTokens
    );

    constructor() ERC721("Othmane 2 PyART collection","PART") Ownable(){
        approval[msg.sender] = true ;
        maxSupply = 50 ;
    }

    function uri(uint256 _tokenId) public view returns (string memory){
        return string(abi.encodePacked(
            "https://gateway.pinata.cloud/ipfs/QmQmLtPy29KZuGyrNMKvvWkCFdBqk3ZrWUU9bGXjS4KUZ3/",
            Strings.toString(_tokenId),
            ".json"
        ));
    }

    function tokenURI(uint tokenID) override public view virtual returns(string memory){
        return uri(tokenID);
    }

    function balanceOfContract() public view returns(uint256){
        return address(this).balance ;
    }

    function retrieveEther(address payable recipient) external payable onlyOwner {
        recipient.transfer(address(this).balance);
    }

    function getApproved(address user) public onlyOwner{
        approval[user] = true ;
    }

    

    function mint(uint256 amount) public payable{
        require(msg.value >= amount * price, "inputted wong value");
        require(totalsupply + amount < maxSupply, "exceeded NFT supply");
        uint tokenID ;
        for (uint i = 0; i < amount; i ++){
            tokenID = totalsupply + i ;
            _mint(msg.sender, (totalsupply + i));
            NFTstock[totalsupply + i] = false ;
            totalsupply += 1 ;
            emit NFTminted(tokenID, block.timestamp, msg.sender, amount) ;
        }    
            

    }

}