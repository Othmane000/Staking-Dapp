// SPDX-License-Identifier: MIT

pragma solidity ^0.8.14 ;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol" ;
import "@openzeppelin/contracts/access/Ownable.sol";

contract Token20 is ERC20, Ownable {
    uint256 totalCirculatingSupply = 0 ;
    mapping(address => uint256) public balances ; // when deployed change to private
    mapping (address => bool) public admins ; // this sets multiple right the owner has to certain addresses
    mapping(address => bool) public approvals ;

    constructor() ERC20("HACHAD","HCD") Ownable(){
        approvals[address(this)] = true ;
    }

    function getUserAdmin(address user) public onlyOwner{
        admins[user] = true ;
        // admins = [Owner, Staking721.sol]
    }

    function getUserApproved(address user, bool value) public {
        require(admins[msg.sender] == true);
        approvals[user] = value ;
    }



    function mint(address to, uint256 amount) public { // this function is only used for creating more tokens
        require(approvals[to] == true, "user not approved to mint") ;
        _mint(to, amount) ;
        balances[to] = amount ;
        totalCirculatingSupply += amount ;
    }
}