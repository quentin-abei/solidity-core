// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract MultiSig {
    address[] public owners;
    uint256 public required;

    uint public transactionCount;
    
    error Nullrequired(uint256);
    error Noownersaddresses();
    error Invalidarguments();

    struct Transaction {
        address recipient;
        uint value;
        bool executed;
    }

    mapping(uint => Transaction) public transactions;
    mapping(uint => mapping(address => bool)) public confirmations;

    constructor(address[] memory _owners, uint256 _required) {
        if(_required == 0){
            revert Nullrequired(_required);
        }
        if(_owners.length == 0){
            revert Noownersaddresses();
        }
        if(_required > _owners.length){
            revert Invalidarguments();
        }
        owners = _owners;
        required = _required;
    }

    function addTransaction(address destination, uint value)
       public
       returns(uint transactionId) {
        transactionId = transactionCount;
        transactions[transactionCount] = Transaction(destination, value, false);
        transactionCount += 1;
    } 

    function isOwner(address addr) private view returns(bool) {
        for(uint i = 0; i < owners.length; i++) {
            if(owners[i] == addr) {
                return true;
            }
        }
        return false;
    }

    function confirmTransaction(uint transactionId) public{
       require(isOwner(msg.sender));
        confirmations[transactionId][msg.sender] = true;          
       
    }

    function getConfirmationsCount(uint transactionId) 
    public 
    view
    returns(uint) {
        uint count;
        for(uint i = 0; i < owners.length; i++) {
            if(confirmations[transactionId][owners[i]]) {
                count++;
            }
        }
        return count;  
    }
}
