// SPDX-License-Identifier: MIT
pragma solidity 0.6.0;

contract msgGenerator {
    
    function generateMsg() public pure returns(bytes memory) {
        return abi.encodeWithSelector(bytes4(keccak256("pwn()")));
    }
}