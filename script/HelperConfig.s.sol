// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import "../test/mock/VRFCoordinatorV2_5Mock.sol";

contract HelperConfig is Script {
    NetworkConfig public activeNetworkConfig;

    uint256 public constant ANVIL_ACCOUNT = 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;

    struct NetworkConfig {
        uint256 subscriptionId;
        bytes32 keyHash;
        uint32 callbackGasLimit;
        address vrfCoordinator;
        uint256 deployerKey;
    }

    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfig = SepoliaEthConfig();
        } else {
            activeNetworkConfig = AnvilEthConfig();
        }
    }

    function SepoliaEthConfig() public view returns (NetworkConfig memory networkConfig)
    {
        networkConfig = NetworkConfig({
            subscriptionId: 32257831488387317018826055199802730878101123509143777723426075897625349115262,
            keyHash: 0x787d74caea10b2b357790d5b5247c2f63d1d91572a9846f780606e4d953677ae,
            callbackGasLimit: 500000,
            vrfCoordinator: 0x9DdfaCa8183c41ad55329BdeeD9F6A8d53168B1B,
            deployerKey: vm.envUint("PRIVATE_KEY")
        });
    }

    function AnvilEthConfig() public returns (NetworkConfig memory networkConfig)
    {
        if(activeNetworkConfig.vrfCoordinator != address(0))
            return activeNetworkConfig;
        
        vm.startBroadcast();
        VRFCoordinatorV2_5Mock vrfCoordinator = new VRFCoordinatorV2_5Mock(100000000000000000, 1000000000, 3996243699330815);
        vm.stopBroadcast();

        uint256 subscriptionId = vrfCoordinator.createSubscription();
        vrfCoordinator.fundSubscription(subscriptionId, 100000000000000000000);


        networkConfig = NetworkConfig({
            subscriptionId: subscriptionId,
            keyHash: 0x787d74caea10b2b357790d5b5247c2f63d1d91572a9846f780606e4d953677ae,
            callbackGasLimit: 500000,
            vrfCoordinator: address(vrfCoordinator),
            deployerKey: ANVIL_ACCOUNT
        });
    }
}
