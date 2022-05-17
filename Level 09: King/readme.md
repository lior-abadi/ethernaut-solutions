## 1) Catch
This contract essentially executes the ```receive()``` fallback when it is submitted. The logic needed to crack is inside that fallback function, precisely if we break any execution **before** the king is assigned, the Ethernaut main contract won't be able to claim back the throne (because what is this all about in this level, an authentic Game of Thrones).


## 2) Solution
The weak line of code inside the fallback function is the one that contains ```king.transfer(msg.value)```. If we interact with this contract as users, this line will always execute. But if we rely on the concepts learned on level 7 (Force), we will pass this level. What we need is a smart contract that restricts the inlet of tokens. If it were a flow system, that smart contract must act as a one way valve. Only it can send tokens (ether on this case).

This one-way contract can be achieved in two ways:
- ```SolutionA09.sol```: Including just one function that allows only to send tokens to the King Contract. On this case just calling ```whiteWalkersInvasion()``` will do the job. 

- ```SolutionB09.sol```: Including two functions. One the same as the other solution and an explicit ```receive()``` function that reverts.

Both examples will work, but the latter is quite more explicit to understand what is happening in here.

By running any of those examples you shall keep the throne, beware of the White Walkers anyways! 