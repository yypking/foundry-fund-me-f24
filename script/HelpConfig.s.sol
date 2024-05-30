// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelpConfig is Script {
    NetWorkConfig public activeNetWorkConfig;

    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 2000e8;

    constructor() {
        if (block.chainid == 11155111) {
            activeNetWorkConfig = getSepoliaEthConfig();
        } else if (block.chainid == 1) {
            activeNetWorkConfig = getMainnetEthConfig();
        } else {
            activeNetWorkConfig = getOrCreateAnvilEthConfig();
        }
    }

    struct NetWorkConfig {
        address priceFeed;
    }

    function getSepoliaEthConfig() public pure returns (NetWorkConfig memory) {
        NetWorkConfig memory sepoliaConfig = NetWorkConfig({priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306});
        return sepoliaConfig;
    }

    function getMainnetEthConfig() public pure returns (NetWorkConfig memory) {
        NetWorkConfig memory mainnetConfig = NetWorkConfig({priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419});
        return mainnetConfig;
    }

    function getOrCreateAnvilEthConfig() public returns (NetWorkConfig memory) {
        //地址不为空 则已经设置了地址
        if (activeNetWorkConfig.priceFeed != address(0)) {
            return activeNetWorkConfig;
        }

        //deploy the mocks
        vm.startBroadcast();
        MockV3Aggregator mockPirceFeed = new MockV3Aggregator(DECIMALS, INITIAL_PRICE);
        vm.stopBroadcast();

        NetWorkConfig memory anvilConfig = NetWorkConfig({priceFeed: address(mockPirceFeed)});

        return anvilConfig;
    }
}
