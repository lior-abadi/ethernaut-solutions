// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

contract Empty{

    function retrieveBalance() public view returns(uint){
        return address(this).balance;
    }

}

contract Kamikaze {  
    function deposit() public payable{
    }

    function troyanHorse(address payable _forwardingAddress) public {
        selfdestruct(_forwardingAddress);
    }

}