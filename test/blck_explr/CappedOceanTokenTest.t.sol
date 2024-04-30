// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";
import {DeployCappedOceanToken} from "../../script/blck_explr/DeployCappedOceanToken.s.sol";
import {CappedOceanToken} from "../../src/blck_explr/CappedOceanToken.sol";

contract CappedOceanTokenTest is Test {
    DeployCappedOceanToken deployer;
    CappedOceanToken token;

    address deployerAddress;
    address bob = makeAddr("Bob");

    function setUp() public {
        deployer = new DeployCappedOceanToken();
        token = deployer.run();
        deployerAddress = msg.sender;
    }

    function testCappedTokenDeployment() public view {
        console2.log("Token owner %s", token.owner());
        console2.log("Deployer address %s", deployerAddress);

        assertEq(token.owner(), deployerAddress, "Owner address unexpected");
    }

    function test70percentOfCappIsMintedOnDeploy() public view {
        console2.log("Token capp %s", token.cap());
        console2.log("Token totalSupply %s", token.totalSupply());

        assertEq(
            (token.cap() * 7) / 10,
            token.totalSupply(),
            "Totalsupply is not 70% of the capp immediately after deployment"
        );
    }

    function test70percentOfCappIsTransferredToOwner() public view {
        console2.log("Owner possession %s", token.balanceOf(token.owner()));

        assertEq(
            token.balanceOf(token.owner()),
            token.totalSupply(),
            "Owner is not in possession of full totalSupply after deployment"
        );
    }

    function testBlockRewardIsSetAfterDeployment() public view {
        assertEq(
            token.getBlockReward(),
            10 * 10 ** token.decimals(),
            "Token blockReward is not set after deployment"
        );
    }

    function testTokenRewardCanBeSetByOwner() public {
        vm.startBroadcast(token.owner());
        token.setBlockReward(5);
        vm.stopBroadcast();

        assertEq(
            token.getBlockReward(),
            5 * 10 ** token.decimals(),
            "Owner could not set new block reward"
        );
    }

    function testTokenRewardCannotBeSetByNotOwner() public {
        vm.startBroadcast(bob);
        vm.expectRevert(bytes("Only the owner can call this functions"));
        token.setBlockReward(5);
        vm.stopBroadcast();
    }

    function testTransferOfCappedToken() public {
        uint256 initialBalanceDeployer = token.balanceOf(deployerAddress);
        vm.startBroadcast(deployerAddress);
        token.transfer(bob, 100);
        vm.stopBroadcast();

        assertEq(token.balanceOf(bob), 100);
        assertEq(
            token.balanceOf(deployerAddress),
            initialBalanceDeployer - 100
        );

        console2.log("Miner %s", block.coinbase);
    }

    // TODO: check if the miner reward transfer can be tested on a locally running anvil
}
