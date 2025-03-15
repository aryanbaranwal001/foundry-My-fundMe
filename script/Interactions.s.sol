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

        // I chatGPT my problem, he said to not use custom users they they don't exit in real anvil chain
        // those addresses and vm.deal things happen in a simulated environment and not the actual anvil chain
        // so to make a actual transaction call, I have to use the private key from anvil chain
        // as it actually contains eth. Try running the following command in the terminal for both cases and see it for yourself.

        // forge script script/Interactions.s.sol:fundFundMe --rpc-url http://127.0.0.1:8545 --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 --broadcast -vvvv 

        vm.broadcast(0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80);
        // vm.broadcast(USER);
        fundMe.fund{value: 1 ether}();
        // vm.stopBroadcast();
        console.log("firstSender", fundMe.s_funders(0));
        console.log("USER", USER);
    }
}
