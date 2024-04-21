// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import {Script} from "forge-std/Script.sol";
import {OZERC20Token} from "../src/OZERC20Token.sol";

contract DeployOZERC20Token is Script {
    uint256 private constant INITIAL_SUPPLY = 1000 ether;

    function run() external returns (OZERC20Token) {
        vm.startBroadcast();
        OZERC20Token ozERC20Token = new OZERC20Token(INITIAL_SUPPLY);
        vm.stopBroadcast();
        return ozERC20Token;
    }
}
