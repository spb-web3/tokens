// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {OceanTokenERC20} from "../../src/blck_explr/OceanTokenERC20.sol";

contract DeployOceanToken is Script {
    uint256 public constant OCEAN_TOKEN_INITIAL_SUPPLY = 7 * 10e6 ether;

    function run() public returns (OceanTokenERC20) {
        vm.startBroadcast();
        OceanTokenERC20 token = new OceanTokenERC20(OCEAN_TOKEN_INITIAL_SUPPLY);
        vm.stopBroadcast();
        return token;
    }

    function initialSupply() external pure returns (uint256) {
        return OCEAN_TOKEN_INITIAL_SUPPLY;
    }
}
