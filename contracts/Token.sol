// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

contract Token {
    uint public totalSupply;
    string public name = "OXHELIUM";
    string public symbol = "OXH";
    uint8 public decimals = 18;

    event Transfer(address indexed sender, address indexed receiver, uint256 value);

    error Notenoughbalance();

    mapping(address => uint256) public balances;

    constructor() {
       totalSupply = 1000 * (10 ** decimals);
       balances[msg.sender] = totalSupply;
    }

    function balanceOf(address addr) external view returns(uint256) {
        return balances[addr];
    }

    function transfer(address _to, uint _amount) public {
        if(balances[msg.sender] < _amount) {
            revert Notenoughbalance();
        }
        balances[msg.sender] -= _amount; 
        balances[_to] += _amount; 
        emit Transfer(msg.sender, _to, _amount);
    }
}