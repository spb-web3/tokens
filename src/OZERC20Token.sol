// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.24;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract OZERC20Token is ERC20 {
    constructor(uint256 _initialSupply) ERC20("OZERC20Token", "OZET") {
        _mint(msg.sender, _initialSupply);
    }
}
