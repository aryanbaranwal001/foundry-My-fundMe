// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {AggregatorV3Interface} from
    "lib/chainlink-brownie-contracts/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    function getUsdFromEth(uint256 AmountOfEth, AggregatorV3Interface priceFeed) public view returns (int256) {
        (, int256 UsdFromEthRate,,,) = priceFeed.latestRoundData();
        return (UsdFromEthRate * 1e10 * int256(AmountOfEth)) / 1e18;
        // UsdFromEthRate comes with 8 decimals, so we multiply by 1e10 to get 18 decimals
        // Divided by 1e18 to get the correct amount of USD in 1e18 units
    }
}
 