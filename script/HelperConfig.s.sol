// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {MockV3Aggregator} from "test/mock/MockV3aggregator.sol";
import {Script} from "lib/forge-std/src/Script.sol";

contract HelperConfig is Script {
    error HelperConfig_InvalidChainId();

    uint256 public constant SEPOLIA_CHAIN_ID = 11155111;
    uint256 public constant LOCAL_CHAIN_ID = 31337;
    uint8 public constant DECIMALS = 8;
    int256 public constant RATE = 200000000000;

    struct NetworkConfig {
        address priceFeedAddress;
    }

    mapping(uint256 => NetworkConfig) public networkConfig;

    constructor() {
        networkConfig[SEPOLIA_CHAIN_ID] = NetworkConfig(0x694AA1769357215DE4FAC081bf1f309aDC325306);
    }

    function getNetworkConfigByChainId(uint256 chainId) public returns (NetworkConfig memory) {
        if (chainId == SEPOLIA_CHAIN_ID) {
            return networkConfig[chainId];
        } else if (chainId == LOCAL_CHAIN_ID) {
            return getOrCreateAnvilChainlinkAggregator();
        } else {
            revert HelperConfig_InvalidChainId();
        }
    }

    function getOrCreateAnvilChainlinkAggregator() public returns (NetworkConfig memory) {
        if (networkConfig[LOCAL_CHAIN_ID].priceFeedAddress == address(0)) {
            return networkConfig[LOCAL_CHAIN_ID];
        }
        vm.startBroadcast(); 
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(DECIMALS, RATE);
        vm.stopBroadcast();

        networkConfig[LOCAL_CHAIN_ID] = NetworkConfig(address(mockPriceFeed));
        return networkConfig[LOCAL_CHAIN_ID];
    }
}
