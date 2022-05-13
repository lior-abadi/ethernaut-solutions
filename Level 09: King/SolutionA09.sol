// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract KingInTheNorth {

    function whiteWalkersInvasion(address _kingAddress) public payable {
     (bool success,) = _kingAddress.call{value: 10000000000000001 wei}("");   
     require(success);
    }
   

}