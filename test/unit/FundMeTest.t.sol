// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "lib/forge-std/src/Test.sol";
import {DeployFundMe} from "script/DeployFundMe.s.sol";
import {MyFundMe} from "src/FundMe.sol";

contract FundMeTest is Test {
    MyFundMe fundMe;
    uint256 public constant STARTING_BALANCE = 100 ether;
    uint256 public constant CORNER_BALANCE = 25 * 1e14;

    address USER = makeAddr("USER");

    function setUp() public {
        vm.startPrank(USER);
        DeployFundMe deployFundMe = new DeployFundMe();
        vm.stopPrank();
        fundMe = deployFundMe.run();
        vm.deal(USER, STARTING_BALANCE);
    }

    function testNoEntranceWithoutSufficientDollars() public {
        vm.prank(USER);
        fundMe.fund{value: CORNER_BALANCE}();
    }

    function testCheckWhoIsOwner() public {
        assert(fundMe.s_owner() == msg.sender);
    }
}
