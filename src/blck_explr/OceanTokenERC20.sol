// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract OceanTokenERC20 is ERC20 {
    constructor(uint256 _initialSupply) ERC20("Ocean Token", "OCT") {
        _mint(msg.sender, _initialSupply);
    }
}
