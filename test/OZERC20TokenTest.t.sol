// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import {Test} from "forge-std/Test.sol";
import {OZERC20Token} from "../src/OZERC20Token.sol";
import {DeployOZERC20Token} from "../script/DeployOZERC20Token.s.sol";

contract OZERC20TokenTest is Test {
    OZERC20Token public token;
    DeployOZERC20Token public deployer;

    address Bob = makeAddr("Bob");
    address Alice = makeAddr("Alice");

    uint256 public constant STARTING_BALANCE = 10 ether;

    function setUp() public {
        deployer = new DeployOZERC20Token();

        token = deployer.run();

        vm.prank(msg.sender);
        token.transfer(Bob, STARTING_BALANCE);
    }

    function testBobBalanceIs10Ether() public view {
        assertEq(token.balanceOf(Bob), STARTING_BALANCE);
    }

    function testBobCanTransferToAlice() public {
        vm.prank(Bob);
        token.transfer(Alice, 1 ether);

        assertEq(token.balanceOf(Alice), 1 ether);
        assertEq(token.balanceOf(Bob), STARTING_BALANCE - 1 ether);
    }

    function testAllowances() public {
        vm.prank(Bob);
        token.approve(address(deployer), 1 ether);

        assertEq(token.allowance(Bob, address(deployer)), 1 ether);
    }

    function testAllowancesAndTransferFrom() public {
        vm.prank(Bob);
        token.approve(address(deployer), 1 ether);

        vm.prank(address(deployer));
        token.transferFrom(Bob, Alice, 1 ether);

        assertEq(token.balanceOf(Alice), 1 ether);
        assertEq(token.balanceOf(Bob), STARTING_BALANCE - 1 ether);
        assertEq(token.allowance(Bob, address(deployer)), 0);
    }
}
