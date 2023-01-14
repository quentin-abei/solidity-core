// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Party {
   uint256 amount;
   mapping(address => bool) didJoined;
   address[] joined;


   error Alreadyjoined(address joinee);
   error Notenoughfunds(uint funds);

   constructor(uint256 _amount) payable {
      amount = _amount;
   }	

   function rsvp() external payable {
       if(didJoined[msg.sender]){
           revert Alreadyjoined(msg.sender);
       }
       if(amount != msg.value) {
           revert Notenoughfunds(msg.value);
       }
       joined.push(msg.sender);
       didJoined[msg.sender] = true;
   }

   function payBill(address venue, uint _amount) external {
       (bool sent, ) = venue.call{value: _amount}("");
       require(sent, "failed to send ETH");
       uint refund = address(this).balance/joined.length;
       for(uint i =0; i< joined.length; i++) {
           address oneAddress = joined[i];
           (bool s, ) = oneAddress.call{value: refund}("");
           require(s, "Failed to send ETH");
       }

   }
}