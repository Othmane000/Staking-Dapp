// SPDX-License-Identifier: MIT

pragma solidity ^0.8.14 ;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol" ;
import "@openzeppelin/contracts/access/Ownable.sol";


// contract address 0xd58F448340E49d0e2cA1A529A6cD0F48C1c45EaB
contract Token20 is ERC20, Ownable {

    event TokenMinted(
        address indexed operator,
        address indexed recipient,
        uint256 timestamp,
        uint256 indexed amountOfToken
    );


    uint256 totalCirculatingSupply = 0 ;
    mapping(address => uint256) public balances ; // when deployed change to private
    mapping(address => bool) public approvals ;

    constructor() ERC20("HACHAD Token","HDT") Ownable(){
        approvals[address(this)] = true ;
    }


    function getUserApproved(address user, bool value) public onlyOwner{
        // this function can also unapprove a user, hence the parameter bool value
        approvals[user] = value ;
    }



    function mint(address to, uint256 amount) public { // this function is only used for creating more tokens
        require(approvals[msg.sender] == true, "user not approved to mint") ;
        _mint(to, amount*10**18) ;
        emit TokenMinted(msg.sender, to, block.timestamp, amount);
        balances[to] += amount ;
        totalCirculatingSupply += amount ;
    }
}