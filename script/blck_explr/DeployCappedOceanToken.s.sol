// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {CappedOceanToken} from "../../src/blck_explr/CappedOceanToken.sol";

contract DeployCappedOceanToken is Script {
    function run() public returns (CappedOceanToken) {
        vm.startBroadcast();
        CappedOceanToken token = new CappedOceanToken(
            "Capped Ocean Token",
            "capOCT",
            1_000_000,
            10
        );
        vm.stopBroadcast();
        return token;
    }
}
