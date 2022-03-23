//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/Context.sol";

import "hardhat/console.sol";

contract PayMultiple is Context {
    
    address private _owner;
    uint256 public balances;

    modifier isOwner() {
        require(msg.sender == _owner, "Caller is not owner");
        _;
    }

    constructor() payable {
        balances = msg.value;
        _owner = msg.sender;
        console.log ("%s is the owner with balance: %s", _owner, balances);
    }

    function changeOwner(address newOwner) public isOwner {
        _owner = newOwner; 
        console.log("Owner changed to: %s", _owner);
    }

    function addBalance() external payable {
        balances += msg.value;
        console.log ("Balance update to %s by %s", balances, msg.sender);
    }

    function payAll(uint256 amountToSplit, address payable[] memory payees) external payable isOwner {
        require(amountToSplit <= balances, "Not enough balance on contract!");
        uint256 payment = amountToSplit / payees.length;
        for (uint256 i = 0; i < payees.length; i++) {    
            require(payment != 0, "Account is not due payment");
            balances -= payment;
            (bool success, ) = payees[i].call{value: payment}("");
            require(success, "Transfer failed.");
        }
    }

    function showBalance() public view returns(uint256) {
        return balances;
    }


}
