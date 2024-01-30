//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {DecentralizedStableCoin} from "../DecentralizedStableCoin.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";


/**
 * @title OracleLib
 * @author Jaume Martínez
 * @notice This library is used to check the Chainlink Oracle fort stale data
 * If a price is stale, the function will revert, and render the DSCEngine unusable - this is by design
 *  We want the DSCEngine to freeze if prices become stale.
 * 
 * So if the Chainlink network explodes and you have a lkot of money locked in the protocol... bad
 */

library OracleLib{
    error OracleLib__StalePrice();

    uint256 private constant TIMEOUT = 3 hours; //3*60*60=10800s


    function staleCheckLastestRoundData(AggregatorV3Interface priceFeed) 
    public 
    view 
    returns(uint80, int256, uint256, uint256, uint80)
    {
            (
        uint80 roundId,
        int256 answer,
        uint256 startedAt,
        uint256 updatedAt,
        uint80 answeredInRound
        )=priceFeed.latestRoundData();

        uint256 secondsSince = block.timestamp - updatedAt;
        if(secondsSince > TIMEOUT) revert OracleLib__StalePrice();
        return(roundId, answer, startedAt, updatedAt, answeredInRound);
    }
}