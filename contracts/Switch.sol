// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

contract Switch {
    address recipient;
    address owner;
    uint timestamp ;

    error Nottheowner(address);

    constructor(address _recipient) payable {
        recipient = _recipient;
        owner = msg.sender;
        timestamp = block.timestamp;
    }

    function withdraw() external {
        require(block.timestamp >= timestamp + 52 weeks, "You greedy Hooman");
        (bool sent, ) = recipient.call{value: address(this).balance}("");
        require(sent, "Failed to send ETH");

    }

    function ping() external {
        if(owner != msg.sender) {
            revert Nottheowner(msg.sender);
        }
        timestamp = block.timestamp;
    }
}