// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {MyFundMe} from "src/FundMe.sol";
import {Script, console} from "lib/forge-std/src/Script.sol";
import {HelperConfig} from "script/HelperConfig.s.sol";

contract DeployFundMe is Script {
    function run() public returns (MyFundMe) {
        HelperConfig helperConfig = new HelperConfig();
        (address priceFeedAddress) = helperConfig.getNetworkConfigByChainId(block.chainid).priceFeedAddress;
        vm.startBroadcast();
        MyFundMe myFundMe = new MyFundMe(priceFeedAddress);
        vm.stopBroadcast();

        return myFundMe;
    }
}
