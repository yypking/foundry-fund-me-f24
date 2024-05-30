// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelpConfig} from "./HelpConfig.s.sol";

contract DepolyFundMe is Script {
    function run() external returns (FundMe) {
        HelpConfig helpConfig = new HelpConfig();
        address ethUsdPriceFeed = helpConfig.activeNetWorkConfig();

        //start之前的不会算进正式交易
        vm.startBroadcast();
        FundMe fundMe = new FundMe(ethUsdPriceFeed);
        vm.stopBroadcast();
        return fundMe;
    }
}
