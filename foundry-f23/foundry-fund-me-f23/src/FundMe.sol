// Get funds from users
// Withdraw funds
// Set a minimum funding value in USD

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "./PriceConverter.sol";

error FundMe__NotOwner();

// 809,158
// 789,428
contract FundMe {
    using PriceConverter for uint256;
    address private immutable i_owner;

    uint256 public constant MINIMUM_USD = 5e18;
    AggregatorV3Interface private s_priceFeed;
    address[] private s_funders;
    mapping(address funder => uint256 amountFunded)
        public s_addressToAmountFunded;

    modifier onlyOwner() {
        // require(msg.sender == i_owner, "must be owner");
        if (msg.sender != i_owner) {
            revert FundMe__NotOwner();
        }
        _;
    }

    constructor(address priceFeed) {
        i_owner = msg.sender;
        s_priceFeed = AggregatorV3Interface(priceFeed);
    }

    function fund() public payable {
        require(
            msg.value.getConversionRate(s_priceFeed) >= MINIMUM_USD,
            "didn't send enough eth"
        );
        s_funders.push(msg.sender);
        s_addressToAmountFunded[msg.sender] += msg.value;
    }

    function getVersion() public view returns (uint256) {
        return s_priceFeed.version();
    }

    function cheaperWithdraw() public onlyOwner {
        uint256 fundersLength = s_funders.length;
        for (
            uint256 funderIndex = 0;
            funderIndex < fundersLength;
            funderIndex++
        ) {
            address funder = s_funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }
        s_funders = new address[](0);
        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(callSuccess, "Call failed");
    }

    function withdraw() public onlyOwner {
        for (
            uint256 funderIndex = 0;
            funderIndex < s_funders.length;
            funderIndex++
        ) {
            address funder = s_funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }
        s_funders = new address[](0);

        // transfer
        // msg.sender = address
        // payable(msg.sender) = payable address;
        // payable(msg.sender).transfer(address(this).balance);

        // // send
        // bool sendSucess = payable(msg.sender).send(address(this).balance);
        // require(sendSucess, "send failed");

        // call
        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(callSuccess, "Call failed");
    }

    // receive() - calls when just send eth to contract
    // fallback() - calls when there is some calldata

    /*
    Which function is called, fallback() or receive()?

           send Ether
               |
         msg.data is empty?
              / \
            yes  no
            /     \
receive() exists?  fallback()
         /   \
        yes   no
        /      \
    receive()   fallback()
    */

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }

    // uint256 public minimumFundValue;
    // address _owner;
    // mapping(address => uint256) userToFunds;

    // constructor() {
    //     minimumFundValue = 1;
    //     _owner = msg.sender;
    // }

    // modifier isOwner(address _sender) {
    //     require(_sender == _owner);
    //     _;
    // }

    // function setMinimumFundValue(uint256 _amount) public isOwner(msg.sender) {
    //     minimumFundValue = _amount;
    // }

    // function getFundByUser(address _userAddress) public view returns (uint256) {
    //     return userToFunds[_userAddress];
    // }

    function getAddressToAmountFunded(
        address fundingAddress
    ) external view returns (uint256) {
        return s_addressToAmountFunded[fundingAddress];
    }

    function getFunder(uint256 index) external view returns (address) {
        return s_funders[index];
    }

    function getOwner() external view returns (address) {
        return i_owner;
    }
}
