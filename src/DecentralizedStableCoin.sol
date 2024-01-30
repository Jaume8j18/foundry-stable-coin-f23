//SPDX-License-Identifier: MIT

//Layout of contract:
// version
// imports
// errors 
// interfaces, libraries, contracts
// type delcarations
// state variables
// events
// modifiers
// functions

//Layout of functions:
// constructor
// recieve function
// fallback fucntion
// external
// public
// internal
// private
// view and pure functions  

pragma solidity ^0.8.18;

import {ERC20Burnable, ERC20} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/*
* @title DecentralizedStableCoin
* @author Jaume Martínez
* @Collateral: Exogenous (ETH AND BTC)
* Minting: Algoritmic
* Relative Stability: Pegged to USD
*
*This is the contract meant to ne governed by DSCEngine. This contract is just the ERC20 implementation of our
*stablecoint system
*/

contract DecentralizedStableCoin is ERC20Burnable, Ownable {
    error DecentralizedStableCoin__MustBeMoreThanZero();
    error DecentralizedStableCoin__BurnAmountExceedsBalance();
    error DecentralizedStableCoin__NotZeroAddress();

    constructor() ERC20("DecentralizedStableCoin","DSC") {}

    function burn(uint256 _amount) public override onlyOwner {
        uint256 balance = balanceOf(msg.sender);
        if(_amount <= 0) {
            revert DecentralizedStableCoin__MustBeMoreThanZero();
        }

        if(balance < _amount) {
            revert DecentralizedStableCoin__BurnAmountExceedsBalance();
        }

        super.burn(_amount);
    }

    function mint(
        address _to, 
        uint256 _amount
        ) external onlyOwner returns(bool){
        if(_to == address(0)){
            revert DecentralizedStableCoin__NotZeroAddress();
        }
        if (_amount <= 0) {
            revert DecentralizedStableCoin__MustBeMoreThanZero();
        }
        _mint(_to, _amount);
        return true;

    }

}