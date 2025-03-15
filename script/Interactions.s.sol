// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console} from "lib/forge-std/src/Script.sol";
import {DeployFundMe} from "script/DeployFundMe.s.sol";
import {MyFundMe} from "src/FundMe.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {StdCheats} from "lib/forge-std/src/StdCheats.sol";

contract fundFundMe is Script, StdCheats {
    address public USER = makeAddr("USER");
    MyFundMe myFundMe;

    function run() public {
        DeployFundMe deployFundMe = new DeployFundMe();
        myFundMe = deployFundMe.run();
        address most_recently_deployed = DevOpsTools.get_most_recent_deployment("MyFundMe", block.chainid);
        fundFundMeFromUser(most_recently_deployed);
    }

    function fundFundMeFromUser(address most_recently_deployed) public {
        MyFundMe fundMe = MyFundMe(most_recently_deployed);

        // vm.startBroadcast();
        vm.deal(USER, 10 ether);
        console.log("user balance", USER.balance);
        vm.broadcast(USER);
        fundMe.fund{value: 1 ether}();
        // vm.stopBroadcast();
        console.log("firstSender", fundMe.s_funders(0));
        console.log("USER", USER);
    }
}
