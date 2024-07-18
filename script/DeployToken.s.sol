// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "../src/Token.sol";
import {HelperConfig} from "./HelperConfig.s.sol";
import {Script} from "forge-std/Script.sol";

contract DeployToken is Script {
    function run() external returns (Game) {
        HelperConfig helperConfig = new HelperConfig();
        (
            uint256 subscriptionId,
            bytes32 gasLane,
            uint32 callbackGasLimit,
            address vrfCoordinatorV2,
            uint256 deployerKey
        ) = helperConfig.activeNetworkConfig();

        vm.startBroadcast(uint256(deployerKey));
        Game game = new Game(
            subscriptionId,
            gasLane,
            callbackGasLimit,
            vrfCoordinatorV2
        );
        vm.stopBroadcast();

        return game;
    }
}