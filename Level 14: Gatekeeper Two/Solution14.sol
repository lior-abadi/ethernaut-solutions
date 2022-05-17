// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SneakLevelTwo {

    constructor(address _levelAddress) {
        bytes8 _key = bytes8(uint64(bytes8(keccak256(abi.encodePacked(address(this))))) ^ type(uint64).max);
        bytes memory target = abi.encodeWithSignature("enter(bytes8)", _key);
        (bool success,) = _levelAddress.call(target);
        require(success, "Error with this call.");
    }

    function getKey() public view returns(bool, uint64, bytes8) {
        uint64 key = uint64(bytes8(keccak256(abi.encodePacked(address(this))))) ^ maxValue;
        return ( uint64(bytes8(keccak256(abi.encodePacked(msg.sender)))) ^ key == maxValue, key, bytes8(key));
    }

    // AUXILIAR FUNCTIONS TO UNDERSTAND WHAT'S GOING ON
    uint64 public maxValue = type(uint64).max;

    function bytesKeccak(address _address) public pure returns(uint64, bytes8, bytes32){
        return ( (uint64(bytes8(keccak256(abi.encodePacked(_address))))), bytes8(keccak256(abi.encodePacked(_address))), keccak256(abi.encodePacked(_address)) );
    }

    // We need to uncheck this pŕocess because the 0.8.0+ compiler comes with built-in overflow checks.
    // The unckecked statement makes the numbers behavior as in versions below 0.8.0
    function underflow(uint64 _number) public pure returns(uint64, bytes8){
        unchecked {
            uint64 uncheckedValue = _number - 1;
            return( uncheckedValue, bytes8(uncheckedValue));
        }
    }

    function XOR(uint64 _x, uint64 _y, uint64 _z) public pure returns(bool){
        return (_x ^ _y == _z);
    }

    function conmutation(uint64 _x, uint64 _y, uint64 _z) public pure returns(bool, uint64, bytes8){
        bool isValid = (_x ^ _z == _y);
        uint64 key = _x ^ _z;
        return(isValid, key, bytes8(key));
    }

    function gateThree(bytes8 _gateKey, address _address) public pure returns(bool){
        uint64 lastArgument = uint64(0) - 1;
        return( uint64(bytes8(keccak256(abi.encodePacked(_address)))) ^ uint64(_gateKey) == lastArgument);
    }

}


