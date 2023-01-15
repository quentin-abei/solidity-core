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
        bytes data;
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

    receive() external payable {}

    function addTransaction(address destination, uint value, bytes calldata _data)
       internal
       returns(uint transactionId) {
        transactionId = transactionCount;
        transactions[transactionCount] = Transaction(destination, value, false, _data);
        transactionCount += 1;
    } 

    function isConfirmed(uint transactionId) public view returns (bool) {
         return getConfirmationsCount(transactionId) >= required;          

    }

    function executeTransaction(uint transactionId) public {
        require(isConfirmed(transactionId));
        Transaction storage _tx = transactions[transactionId];
        (bool success,bytes memory _data ) = _tx.recipient.call{ value: _tx.value }(_tx.data);
        require(success);
        _tx.executed = true;
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
       if(isConfirmed(transactionId)){
           executeTransaction(transactionId);
       }         
       
    }

    function submitTransaction(address dest, uint value, bytes calldata _data) external {
        uint id = addTransaction(dest, value, _data);
        confirmTransaction(id);
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
