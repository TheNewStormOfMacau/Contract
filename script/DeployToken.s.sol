// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/Token.sol";
import {HelperConfig} from "./HelperConfig.s.sol";
import {Script} from "forge-std/Script.sol";
import "../test/mock/VRFCoordinatorV2_5Mock.sol";

contract DeployToken is Script {
    function run() external returns (Token) {
        HelperConfig helperConfig = new HelperConfig();
        (
            uint256 subscriptionId,
            bytes32 keyHash,
            uint32 callbackGasLimit,
            address vrfCoordinator,
            uint256 deployerKey
        ) = helperConfig.activeNetworkConfig();

        vm.startBroadcast(deployerKey);
        Token game = new Token(
            subscriptionId,
            keyHash,
            callbackGasLimit,
            vrfCoordinator
        );
        vm.stopBroadcast();

        VRFCoordinatorV2_5Mock(vrfCoordinator).addConsumer(subscriptionId,address(game));

        return game;
    }
}