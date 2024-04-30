// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {DeployOceanToken} from "../../script/blck_explr/DeployOceanToken.s.sol";
import {OceanTokenERC20} from "../../src/blck_explr/OceanTokenERC20.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract OceanTokenERC20Test is Test {
    OceanTokenERC20 public token;
    DeployOceanToken public deployer;

    address internal tokenOwner;
    address public deployerAddr = makeAddr("deployer");
    address public Bob = makeAddr("bob");
    address public Alice = makeAddr("alice");

    uint256 public initialSupply;

    // address public deployerAddress = makeAddr("deployer");
    // address public deployerAddress = makeAddr("deployer");

    modifier transferToBob() {
        vm.startBroadcast(tokenOwner);
        bool transfered = ERC20(token).transfer(Bob, 10 ether);
        vm.stopBroadcast();
        _;
    }

    function setUp() external {
        deployer = new DeployOceanToken();
        token = deployer.run();

        tokenOwner = msg.sender;
        initialSupply = deployer.initialSupply();
    }

    function testInitialSupplyIsTransferedToTokenOwner() public view {
        uint256 tokenOwnerBalance = token.balanceOf(tokenOwner);

        assertEq(tokenOwnerBalance, initialSupply, "Unexpected initial supply");
    }

    function testDecimalsIs18() public view {
        assertEq(token.decimals(), 18, "Decimals are not 18");
    }

    function testName() public view {
        assertEq(
            token.name(),
            "Ocean Token",
            'Token name is not "Ocean Token"'
        );
    }

    function testSymbol() public view {
        assertEq(token.symbol(), "OCT", 'Token symbol is not "OCT"');
    }

    function testTransfer() public {
        vm.startBroadcast(tokenOwner);
        bool transfered = ERC20(token).transfer(Bob, 10 ether);
        vm.stopBroadcast();
        assertTrue(transfered);

        uint256 ownerBalanceAfterTransfer = token.balanceOf(tokenOwner);
        assertEq(
            ownerBalanceAfterTransfer,
            initialSupply - 10 ether,
            "Owner did not transfer"
        );
        assertEq(
            token.balanceOf(Bob),
            10 ether,
            "Bob did not get the transfer"
        );
    }

    function testBobGrantsAllowanceToAlice() public transferToBob {
        vm.startBroadcast(Bob);
        bool approved = token.approve(Alice, 5 ether);
        vm.stopBroadcast();

        assertTrue(approved);
        assertEq(token.balanceOf(Bob), 10 ether);
        assertEq(token.allowance(Bob, Alice), 5 ether);
    }

    function testAliceSpendsBobsAllowance() public transferToBob {
        vm.startBroadcast(Bob);
        bool approved = token.approve(Alice, 5 ether);
        vm.stopBroadcast();

        vm.startBroadcast(Alice);
        bool spent = token.transferFrom(Bob, Alice, 5 ether);
        vm.stopBroadcast();

        assertTrue(approved);
        assertTrue(spent);
        assertEq(token.balanceOf(Bob), 5 ether);
        assertEq(token.balanceOf(Alice), 5 ether);
        assertEq(token.allowance(Bob, Alice), 0 ether);
    }
}
