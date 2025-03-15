// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {MyFundMe} from "src/FundMe.sol";
import {Script} from "lib/forge-std/src/Script.sol";

contract DeployFundMe is Script {
    address public priceFeed;

    function run() public {
        vm.startBroadcast();
        MyFundMe myFundMe = new MyFundMe(priceFeed);
        vm.stopBroadcast();
    }
}
