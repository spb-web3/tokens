// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {DeployOceanToken} from "../../script/blck_explr/DeployOceanToken.s.sol";
import {OceanTokenERC20} from "../../src/blck_explr/OceanTokenERC20.sol";

contract OceanTokenERC20Test is Test {
    OceanTokenERC20 public token;
    DeployOceanToken public deployer;

    address internal tokenOwner;
    address public deployerAddr = makeAddr("deployer");

    // address public deployerAddress = makeAddr("deployer");
    // address public deployerAddress = makeAddr("deployer");

    function setUp() external {
        deployer = new DeployOceanToken();
        token = deployer.run();

        tokenOwner = msg.sender;
    }

    function testInitialSupplyIsTransferedToTokenOwner() public view {
        uint256 tokenOwnerBalance = token.balanceOf(tokenOwner);
        uint256 deployerInitialSupply = deployer.initialSupply();

        assertEq(
            tokenOwnerBalance,
            deployerInitialSupply,
            "Unexpected initial supply"
        );
    }
}
