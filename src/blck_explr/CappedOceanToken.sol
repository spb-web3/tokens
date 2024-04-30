// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

// TODO: remove
import {console2} from "forge-std/console2.sol";

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC20Capped} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import {ERC20Burnable} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract CappedOceanToken is ERC20Capped, ERC20Burnable {
    address payable public owner;

    uint256 public blockReward;

    event MinerRewarded(address indexed miner, uint256 indexed reward);

    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _capp,
        uint256 _blockReward
    ) ERC20(_name, _symbol) ERC20Capped(_capp * 10 ** decimals()) {
        owner = payable(msg.sender);
        _mint(owner, (7 * _capp * 10 ** decimals()) / 10); // 70% from the _capp to be immediately minted to the owner
        blockReward = _blockReward * 10 ** decimals();
    }

    function _mintMinerReward() internal {
        // TODO: remove
        console2.log("Miner %s", block.coinbase);
        _mint(block.coinbase, blockReward);
        emit MinerRewarded(block.coinbase, blockReward);
    }

    function _update(
        address from,
        address to,
        uint256 value
    ) internal override(ERC20, ERC20Capped) {
        if (
            from != address(0) &&
            block.coinbase != address(0) && // this prevents infinit loop
            to != block.coinbase
        ) {
            _mintMinerReward(); // _mint(block.coinbase, blockReward);
        }
        super._update(from, to, value);
    }

    // _beforeTokenTransfer hook (in v4.x) or _update (in v5.0) to add an additional check
    // function _beforeTokenTransfer(
    //     address from,
    //     address to,
    //     uint256 value
    // ) internal virtual override {}

    function setBlockReward(uint256 newReward) public onlyOwner {
        blockReward = newReward * 10 ** decimals();
    }

    function getBlockReward() public view returns (uint256) {
        return blockReward;
    }

    modifier onlyOwner() {
        if (owner != msg.sender) {
            revert("Only the owner can call this functions");
        }
        _;
    }
}
