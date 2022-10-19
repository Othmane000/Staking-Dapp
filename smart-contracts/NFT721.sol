// SPDX-License-Identifier: MIT


pragma solidity ^0.8.14 ;


import "@openzeppelin/contracts/token/ERC721/ERC721.sol" ;
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


// contract address (needs to be changed when contract deployed to Goerli) 0x9541a34fDa8294ad456bA118d06FaB2Dfec9ee83
contract NFT721 is ERC721, Ownable {

    uint256 public totalsupply = 0 ;
    uint256 public maxSupply ;
    uint256 public price = 0.01 ether ; // 10000000000000000 price in wei
    
    mapping(uint256 => bool) public NFTWasMinted ; // this checks if a token was minted or not
    //mapping(address => bool) public approval ;

    event NFTminted(
        uint256 indexed tokenid,
        uint256 timestamp,
        address indexed minter,
        uint256 indexed numberOfTokens
    );

    constructor() ERC721("Othmane Hachad's PyART collection","HART") Ownable(){
        //approval[msg.sender] = true ;
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
        // returns how many ethers were stored on this smart-contract
        return address(this).balance ;
    }

    

    function mint(uint amount) public payable{
        require(msg.value >= (amount * price), "inputted wrong value");
        require(totalsupply + amount <= maxSupply, "exceeded NFT supply");
        uint tokenID ;
        for (uint i = 1; i <= amount; i ++){
            tokenID = totalsupply + i ;
            _mint(msg.sender, (tokenID));
            NFTWasMinted[tokenID] = true ;
        }    
        emit NFTminted(tokenID, block.timestamp, msg.sender, amount) ;
        totalsupply += amount ;
            

    }

}