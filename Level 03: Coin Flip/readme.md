## 1) Catch
As an user you can run a script that pushes the transaction into a block with certain properties.
The casting of a bytes32 into an uint256 can be done to detect vulnerabilities in here.

Pro tip:
Considering the zero as an even number.
If the last digit of a hex chain is 0,2,4,6,8 or A, C, E; the casted uint will be even!
(and viceversa for odd ones...)


## 2) Solution:
By running a script with the following logic, you can get any amount of consecutiveWins. 
The contract also restricts the user to pass a batch of calls into the same block. They need 
to be performed from different blocks.

Also, note that the FACTOR number is an even-hex number. More precisely. 0x8 with 63 zeros behind. 
Solidity works with "integer" numbers, no decimal nor fractions exist. 
    
    1) Check the last block hash
    2) Cast the block hash into a uint256
    3) If the result of CastedHash/FACTOR is 1, send a true value, otherwise send a false one.
    4) Repeat this logic the desired amount of times, without calling the flip function more than once per block.
   
The solution is in ```Solution03.sol```

