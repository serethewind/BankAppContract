// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Script} from "forge-std/Script.sol";
import {BankApp} from "../src/BankApp.sol";

contract DeployBankAppScript is Script {
    function run() public {
        vm.startBroadcast();

        BankApp bankApp = new BankApp();

        vm.stopBroadcast();
    }
}
