// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import "forge-std/Script.sol";
import {SimpleStorage} from "../src/SimpleStorage.sol";

contract DeploySimpleStorage is Script {
    function run() external returns (SimpleStorage) {
        // tx start
        vm.startBroadcast();

        SimpleStorage simpleStorage = new SimpleStorage();

        // tx end
        vm.stopBroadcast();
        return simpleStorage;
    }
}
