## 1) Catch
This level focuses on three different aspects. Knowing from where the transaction has to be sent, gas management and how data casting works. Disect the level into three different challenges and it will be solved!

## 2) Solution
We will address the solution in three parts, one for each gate. We wil leave the second gate to the end just to make the explaination more fluid.

### 1) **Gate One**
This gate is easily opened while making the call from a contract rather than a user. Making this type of call makes the ```tx.origin = address(callerContract)``` whereas the ```msg.sender = address(user)```.

### 3) **Gate Three**
This gate can be a little bit confusing but if you think this part as a set of equations, to have a consistent equation system (the one that has one solution), we need to find the intersection of the system. We can get the initial value of this problem by scoping the third condition. The conditions that need to be satisfied are the following:

- ```uint32(uint64(_gateKey)) == uint16(uint64(_gateKey)) ```
- ```uint32(uint64(_gateKey)) != uint64(_gateKey) ```
- ```uint32(uint64(_gateKey)) == uint16(tx.origin) ```

To address this part we will see how Solidity works, truncates and concatenates bytes.

```bytes32 b_32_1 = 0x1122334455667788991122334455667788991122334455667788991122334455 ```

```bytes4 b_4   = bytes4(b_32)      =   0x11223344 ```

```bytes32 b_32_2 = bytes32(b_4)    =   0x1122334400000000000000000000000000000000000000000000000000000000 ```


The fist step generates a ```bytes32``` number with 64 positions of data after the ```0x```. When casting the ```bytes32``` into ```bytes8``` the data after the first eight positions is truncated. When recasting the ```bytes8``` into a bigger variable size such as ```bytes32```, Solidity concatenates at the last position of the smaller variable a chain of zeros. That chain can be interpreted as corrupted or lost data.

You can play with this easily by running ```cast``` under this Solidity Contract:

    // SPDX-License-Identifier: MIT
    pragma solidity ^0.8.0;

    contract Caster {

        function cast(bytes32 _input) public pure returns(bytes32, bytes4, bytes32){
            bytes4 b_4 = bytes4(_input);
            return (_input, b_4, bytes32(b_4));
        }
    }   


With that being said, lets evaluate each condition of the gate three, from the bottom to the top. We will use this contract address as an example: ```0x9b261b23cE149422DE75907C6ac0C30cEc4e652A```.

- The last condition requires the last 4 places of the ```tx.origin``` address to be equal to something on the right side. For our contract address, the result in here will be ```0xXXXXXXXX0000e52a```.
The right side of the condition what it does is adding and truncating "corrupted" positions to ```bytes8``` key. So, we know so far: ```uint32(uint64(_key)) == 0xXXXXXXXXXXXXe52a```. We need to figure out what are the X's (because this condition only checks the truncated form, those X qualify as lost data).

- The second condition tries to say that the truncated version of the key can't be the same as the original one. In other words, it is asking us to have a value different than zero in at least one of the first positions.
So far: ```key = 0x1XXXXXXXXXXXe52a```.

- The first condition evaluates the impact of downcasting a bigger size of varible into two different smaller sizes. The only thing that makes the difference in here is the amount of positions that are going to be truncated. This will remove the first 8 positions for the bigger one and the fist 12 of the smaller casting. We must have empty data into the positions 9-12.
Giving us: ```key = 0x1XXXXXXX0000e52a```. Having the remaining X's as free values (use 0 for example).

You can check and play arround with this Solidity script to check if the key is valid or not:

    // SPDX-License-Identifier: MIT
    pragma solidity ^0.4.18;

    contract CasterV2 {

        function castAddr(address _address) public pure returns(bytes8, uint16, bytes8){
            return (bytes8(_address), uint16(_address), bytes8(uint16(_address)));
        }
        /* 
        Equation One requires to have different truncations of the key to be the same.
        Because on both cases the variable is casted from a bigger uint type to a smaller one
        this can be interpreted as an addition of positions to the left side of the byte number.
        The bytesCasting auxiliar function can be used to get the required key.    
        */
        function equationOne(bytes8 _key) public pure returns(bool){
            return (uint32(uint64(_key)) == uint16(uint64(_key)));
        }

        /*
        Equation Two can be cracked having just by chaging the value of the first byte position! 
        */
        function equationTwo(bytes8 _key) public pure returns(bool){
            return (uint32(uint64(_key)) != uint64(_key));
        }    

        /*
        Equation Three is our start point, in order to get an approach to the byte key,
        we need to get the last 4 digits of our contract address! 
        */
        function equationThree(bytes8 _key, address _origin) public pure returns(bool) {
            return(uint32(uint64(_key)) == uint16(_origin));
        }
    }

### 2) **Gate Two**
This is for sure the most difficult part to crack. It is highly recommended to understand how the ```gasleft()``` function works and when the require statement starts to calculate. There are several ways to do so. We will cover two of them, but both are extremely related.

- 1) **Alternative One:** We need to copy-paste the contract itself and make a file that contains both contracts, the caller and the base one. This will help us to track each step while debugging our transaction. The file should be something like this (in order to use the Remix built-in debugger):

```
    // SPDX-License-Identifier: MIT
    pragma solidity 0.6.0;

    import '../SafeMath.sol';

    contract GatekeeperOne {

    using SafeMath for uint256;
    address public entrant;

    modifier gateOne() {
        require(msg.sender != tx.origin);
        _;
    }

    modifier gateTwo() {
        require(gasleft().mod(8191) == 0);
        _;
    }

    modifier gateThree(bytes8 _gateKey) {
        require(uint32(uint64(_gateKey)) == uint16(uint64(_gateKey)), "GatekeeperOne: invalid gateThree part one");
        require(uint32(uint64(_gateKey)) != uint64(_gateKey), "GatekeeperOne: invalid gateThree part two");
        require(uint32(uint64(_gateKey)) == uint16(tx.origin), "GatekeeperOne: invalid gateThree part three");
        _;
    }

    function enter(bytes8 _gateKey) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
        entrant = tx.origin;
        return true;
    }

    }

    contract GateSneakOne {

        // Here is where the magic starts!
        function callEnter(bytes8 _key, address _gateKeeper) public {
            (bool success, ) = _gateKeeper.call(abi.encodeWithSignature("enter(bytes8)", _key)); // No gas specification so far.
            require(success, "Oops, something went wrong :( " );
        }

    }
```

The idea is to first deploy the ```GatekeeperOne``` then ```GateSneakOne``` and after that, having the ```GatekeeperOne``` address make the ```callEnter``` call. The key can be any bytes8 date because this excecution will revert before checking that key. With the reversal, you can check that on Remix transactions feed there is a ```debug``` button next to the reverted tx. Let's debug it. 

There are four arrow buttons, from left to right. Go back to the last function block, go to the last immediate call, go forward to the next immediate call, go forward to the next function call. You can play with that until you see the reversal or you can click at "Click here to jump where the call reverted.".

**Why this reverts anyways?** Because the sent gas does not fits the requirements of the gate two. Precisely, just before assigning the remaining gas of the call to the ```a``` parameter of the ```mod``` function. In order to satisfy this step we need to track the gas consumed by the call just before it assigns that value into ```a```. To do so, we can jump to where the call was reverted an go back slowly until we see the mentioned step. At "step details" the remaining gas can be scoped. 

By knowing the initial gas sent we can ```Initial Gas - Remaining Gas = Consumed Gas```. We need in here the ```Remaining Gas``` to be a multiple of ```8191```. 

To get the amount of gas we just need to: ```8191 * Margin + Consumed Gas``` will give us the exact amount of gas that is needed to satisfy this gate.

- 2) **Alternative Two:** The option one is the theory behind this solution. In here, by knowing aproximately the consumed gas of the first steps we can run multiple calls to the contract an iterate near that gas value. This is because that consumed gas value deppends on how the level contract and the instance was deployed in terms of optimizer and other compiler settings. We can create another caller contract that loops over the call in order to get the exact gas value.

```
    // SPDX-License-Identifier: MIT
    pragma solidity ^0.4.18;

    contract Caller {

        function callEnter(bytes8 _key, address _gateKeeper, uint256 _offset, uint256 _initialGas) public returns(bool){
            for (uint256 i = 0; i < _offset; i++) {
                if (_gateKeeper.call.gas(i + _initialGas + 8191 * 5)(bytes4(keccak256("enter(bytes8)")), _key)) {
                    return true;
                }
            }
        }        
    }
```

By tuning the call with the ```offset``` and the ```_initialGas``` we can iterate around that gas value in order to get the right call. The initial gas can be set as: ```Consumed Gas - Offset / 2 ```, where the ```Consumed Gas``` can be estimated with the method of step 1.

*If you are among the few ones who read up to here, I admire you. WAGMI!*


Oof, that was a long but interesting way to learn more about how Solidity works!