## 1) Catch
This level relies deeply in the concept of `delegatecall` and how memory layout is managed on caller and callee contracts. How are variables stored? And how are they modified? Is there a way to match up and overwrite storage data?


## 2) Solution
This level is possible because it is consulting a foreign "library" implementation that is meant to set the time. Pay attention to "library", between quotes. Both date setters are not libraries indeed, they are contracts.

The main difference between them regarding the concepts needed for this level is how memory is managed, stored and overwritten. Libraries do not modify caller storage data while being requested by a `delegatecall`. This is extremely important to solve this level.


As seen in previous levels, the low level execution `delegatecall` allows the caller to perform several actions that are not implemented locally, by relying on foreign implementations. The way it is executed is by passing a `function selector` and the `inputs`. The function selector is composed by the first 4 bytes of the hashed expression of each function. And yes, if you may be wondering "what happens with the rest of the truncated information?". It is lost. So, there might be two functions with the different name and executions having the same selector (search: "Solidity Functions Clashing" to see more about this issue).

The core of delegating is that the executed implementation is foreign but if memory is modified, it impacts directly on the caller contract and how is its memory layout.

On this level we have the following contract memory layout:

        contract Preservation {

        // public library contracts 
        address public timeZone1Library; // =======> SLOT 0
        address public timeZone2Library; // =======> SLOT 1
        address public owner;            // =======> SLOT 2
        uint storedTime;                 // =======> SLOT 3

        // ....

        }

Each memory slot has a 32-byte size, starting with index 0 and going up to 2²⁵⁶. If there are some variables declared sequentially which total size is less than 32-bytes, they will be concatenated and saved on the same slot. For example:

        uint128 date   = 9122018;
        uint128 goals  = 31;

Both `date` and `goals` are sequentially declared and their total size equals `uint256`, so they can be packed into a single slot saving space (thus gas).


Combining both concepts (delegation and memory layout), we will follow this path to exploit this contract:

0. Deploy a malicious smart contract with the same memory layout as `Preservation`.
1. Call `Preservation.setFirstTime("maliciousContractAddress")`. Here is when the first library is invoked. Because the memory slot is overwritten, we are indeed changing the `timeZone1Library` from the Preservation contract to be our implementation.
2. Call again `Preservation.setFirstTime(arbitraryValue)` will steal the ownership of Preservation by using the same principle of item 1.

The malicious contract could be:

        contract PreservationCracker {

            address public slot0;
            address public slot1;
            address public slot2; 
            uint slot3;    

            function setTime(uint _time) public {
                slot2 = msg.sender;
            }

        }

Please note that it must have the same memory layout (the slot that we want to overwrite is the #2), and the function must have the same selector!

As a bonus, this level can be cracked in a way to showcase also the issue of functions clash. The operation of finding a clashing function (same 4byte selector) is a little bit processing intensive (it's a hash matching mining operation) and it won't be performed in here. If the cracker contract implements a function with the same selector as `setTime`, this level should be cracked also.

_Like on gaming consoles... always be wary on where are you storing your data to prevent overwriting important progress!_
