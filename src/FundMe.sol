// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {AggregatorV3Interface} from
    "lib/chainlink-brownie-contracts/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "src/PriceConverter.sol";

contract MyFundMe {
    using PriceConverter for uint256;

    enum FundState {
        OPEN,
        CLOSED
    }

    FundState public s_fundState;

    /*//////////////////////////////////////////////////////////////
                                 ERRORS
    //////////////////////////////////////////////////////////////*/

    error MyFundMe__NotOwner();
    error MyFundMe__NotMinimumFunds();
    error MyFundMe__NotProposedOwner();

    /*//////////////////////////////////////////////////////////////
                         VARIABLE DECLARATIONS
    //////////////////////////////////////////////////////////////*/

    string public s_reasonToFund;
    address public s_owner;
    mapping(address AddressOfFunders => uint256 AmountFunded) public s_addressToAmountFunded;
    AggregatorV3Interface public s_priceFeed;
    int256 public constant MIN_USD = 5 * 1e18;
    address[] public s_funders;
    address public proposedOwner;

    /*//////////////////////////////////////////////////////////////
                               CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    constructor(address _priceFeed) {
        s_priceFeed = AggregatorV3Interface(_priceFeed);
        s_owner = msg.sender;
        s_fundState = FundState.OPEN;
    }

    /*//////////////////////////////////////////////////////////////
                           TRANSFER FUNTIONS
    //////////////////////////////////////////////////////////////*/

    function fund() public payable {
        require(s_fundState == FundState.OPEN, "Fund is closed");

        if (msg.value.getUsdFromEth(s_priceFeed) <= MIN_USD) revert MyFundMe__NotMinimumFunds();

        s_addressToAmountFunded[msg.sender] += msg.value;
        s_funders.push(msg.sender);
    }

    function TransferFundsTo(address toTransferFundTo) public onlyOwner {
        require(s_fundState == FundState.OPEN, "Fund is closed");
        require(address(this).balance > 0, "No balance in the contract");

        (bool success,) = payable(toTransferFundTo).call{value: address(this).balance}("");
        require(success);

        for (uint256 i = 0; i < s_funders.length; i++) {
            s_addressToAmountFunded[s_funders[i]] = 0;
        }
        s_funders = new address[](0);
    }

    function CheaperTransferFundsTo(address toTransferFundTo) public onlyOwner {
        require(s_fundState == FundState.OPEN, "Fund is closed");
        require(address(this).balance > 0, "No balance in the contract");

        (bool success,) = payable(toTransferFundTo).call{value: address(this).balance}("");
        require(success);

        address[] memory funderListTemp = s_funders;

        // mappings can't be in memory
        // array are allowed
        for (uint256 i = 0; i < funderListTemp.length; i++) {
            s_addressToAmountFunded[funderListTemp[i]] = 0;
        }
        s_funders = new address[](0);
    }

    /*//////////////////////////////////////////////////////////////
                      TRANSFER OWNERSHIP FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    function transferOwnershipProposal(address theAddressToTransferOwnershipTo) public onlyOwner {
        s_fundState = FundState.CLOSED;
        proposedOwner = theAddressToTransferOwnershipTo;
    }

    function confirmTransferOwnership() public {
        if (msg.sender != proposedOwner) revert MyFundMe__NotProposedOwner();
        s_owner = proposedOwner;
    }

    function revertProposal() public onlyOwner {
        s_fundState = FundState.OPEN;
        proposedOwner = address(0);
    }

    /*//////////////////////////////////////////////////////////////
                            REASON FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    function setReasonToFund(string memory reason) public onlyOwner {
        s_reasonToFund = reason;
    }

    function reasonToFund() public view returns (string memory) {
        return s_reasonToFund;
    }

    /*//////////////////////////////////////////////////////////////
                            GETTER FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    function getAddressToAmountFunded(address fundingAddress) public view returns (uint256) {
        return s_addressToAmountFunded[fundingAddress];
    }

    function getVersion() public view returns (uint256) {
        return s_priceFeed.version();
    }

    function getFunder(uint256 index) public view returns (address) {
        return s_funders[index];
    }

    function getOwner() public view returns (address) {
        return s_owner;
    }

    function getPriceFeed() public view returns (AggregatorV3Interface) {
        return s_priceFeed;
    }

    /*//////////////////////////////////////////////////////////////
                               MODIFIERS
    //////////////////////////////////////////////////////////////*/

    modifier onlyOwner() {
        if (msg.sender != s_owner) revert MyFundMe__NotOwner();
        _;
    }
}

// Problems to Resolve
// 1. how to type convert int to uint
// 2. putting all the address to 0, will the addresses stop existing and mapping will be empty?
