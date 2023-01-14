// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract MultiSig {
    address[] public owners;
    uint256 public required;
    error Nullrequired(uint256);
    error Noownersaddresses();
    error Invalidarguments();

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
}
