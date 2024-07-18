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
            gasLane: 0x787d74caea10b2b357790d5b5247c2f63d1d91572a9846f780606e4d953677ae,
            callbackGasLimit: 500000,
            vrfCoordinatorV2: 0x9DdfaCa8183c41ad55329BdeeD9F6A8d53168B1B,
            deployerKey: vm.envUint("PRIVATE_KEY")
        });
    }
}
