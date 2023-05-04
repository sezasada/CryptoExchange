// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.9;

import "hardhat/console.sol";

contract Token {
    string public name;
    string public symbol;
    uint256 public decimals = 18;
    uint256 public totalSupply;

    // Track Balances
    // Address is the key, the balance of the address of the value. state variable is balanceOf
    mapping(address => uint256) public balanceOf;

    // Owner address => Nested mapping - spender /// exchange address will return number of tokens that are approved
    mapping(address => mapping(address => uint256)) public allowance;

    // Send Tokens

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _totalSupply
    ) {
        name = _name;
        symbol = _symbol;
        totalSupply = _totalSupply * (10 ** decimals); // 1,000,000 x 10^18;
        balanceOf[msg.sender] = totalSupply; // msg.sender is an address. msg is a global variable in solidity.
    }

    function transfer(
        address _to,
        uint256 _value
    ) public returns (bool success) {
        // Require that sender has enough tokens to spend
        require(balanceOf[msg.sender] >= _value);

        _transfer(msg.sender, _to, _value);

        return true;
    }

    function _transfer(address _from, address _to, uint256 _value) internal {
        require(_to != address(0));

        balanceOf[_from] = balanceOf[_from] - _value;

        balanceOf[_to] = balanceOf[_to] + _value;

        emit Transfer(_from, _to, _value);
    }

    // Taken directly from the docs
    function approve(
        address _spender,
        uint256 _value
    ) public returns (bool success) {
        require(_spender != address(0));

        allowance[msg.sender][_spender] = _value;

        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public returns (bool success) {

        // check approval
        require(_value <= balanceOf[_from], "insufficient balance");
        require(_value <= allowance[_from][msg.sender], "insufficicient allowance");

        // Reset Allowance
        allowance[_from][msg.sender] = allowance[_from][msg.sender] - _value;

        // spend tokens
        _transfer(_from, _to, _value);

        return true;
    }
}
