// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.24;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
 * @dev Naive implementation of ERC20 spec
 */

contract ManualERC20Token is IERC20 {
    error ManualERC20Token_BalanceTooLow();
    error ManualERC20Token_AllowanceTooLow();

    string private constant TOKEN_NAME = "ManualERC20Token";
    string private constant TOKEN_SYMBOL = "MET";

    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) allowances;

    function name() public pure returns (string memory) {
        return TOKEN_NAME;
    }

    function symbol() public pure returns (string memory) {
        return TOKEN_SYMBOL;
    }

    function decimals() public pure returns (uint8) {
        return 18;
    }

    function totalSupply() public pure returns (uint256) {
        return 1000 ether;
    }

    function balanceOf(address _owner) public view returns (uint256 balance) {
        return balances[_owner];
    }

    function transfer(
        address _to,
        uint256 _value
    ) public returns (bool success) {
        if (balances[msg.sender] < _value) {
            revert ManualERC20Token_BalanceTooLow();
        }

        balances[msg.sender] -= _value;
        balances[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public returns (bool success) {
        if (allowances[msg.sender][_from] < _value) {
            revert ManualERC20Token_AllowanceTooLow();
        }

        if (balances[_from] < _value) {
            revert ManualERC20Token_BalanceTooLow();
        }

        allowances[msg.sender][_from] -= _value;
        balances[_from] -= _value;
        balances[_to] += _value;

        emit Transfer(_from, _to, _value);
        return true;
    }

    function approve(
        address _spender,
        uint256 _value
    ) public returns (bool success) {
        if (balances[msg.sender] < _value)
            revert ManualERC20Token_BalanceTooLow();
        allowances[_spender][msg.sender] += _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(
        address _owner,
        address _spender
    ) public view returns (uint256 remaining) {
        return allowances[_spender][_owner];
    }
}
