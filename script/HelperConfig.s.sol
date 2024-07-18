// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";

contract HelperConfig is Script {
    NetworkConfig public activeNetworkConfig;

    struct NetworkConfig {
        uint256 subscriptionId;
        bytes32 gasLane;
        uint32 callbackGasLimit;
        address vrfCoordinatorV2;
        uint256 deployerKey;
    }

    constructor() {
        activeNetworkConfig = getSepoliaEthConfig();
    }

    function getSepoliaEthConfig()
        public
        view
        returns (NetworkConfig memory sepoliaNetworkConfig)
    {
        sepoliaNetworkConfig = NetworkConfig({
            subscriptionId: 32257831488387317018826055199802730878101123509143777723426075897625349115262,
            gasLane: 0x474e34a077df58807dbe9c96d3c009b23b3c6d0cce433e59bbf5b34f823bc56c,
            callbackGasLimit: 500000,
            vrfCoordinatorV2: 0x8103B0A8A00be2DDC778e6e7eaa21791Cd364625,
            deployerKey: vm.envUint("PRIVATE_KEY")
        });
    }
}
