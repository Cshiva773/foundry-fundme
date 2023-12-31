// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;
import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";
contract HelperConfig is Script{
    NetworkConfig public activeNetworkConfig;
    uint8 public constant DECIMALS=8;
    int256 public INITIAL_PRICE=2000e8;
    struct NetworkConfig{
        address priceFeed;
    }
    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaEthConfig();
        } else {
            activeNetworkConfig = getorCreateAnvilEthConfig();
        }
    }
    function getSepoliaEthConfig() public pure returns(NetworkConfig memory sepoliaNetworkConfig){
        sepoliaNetworkConfig = NetworkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306 // ETH / USD
        });
    }
    function getorCreateAnvilEthConfig() public returns(NetworkConfig memory anvilConfig){
        if(activeNetworkConfig.priceFeed!=address(0)){
            return activeNetworkConfig;
        }
        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed=new MockV3Aggregator(DECIMALS,INITIAL_PRICE);
        vm.stopBroadcast();
        anvilConfig=NetworkConfig({priceFeed:address(mockPriceFeed)});
    }
}