## 1) Catch
The most challenging thing in here both knowing how does the extcodesize works and its most common use and also knowing a little bit of logic operations.


## 2) Solution
Like the last level, there are three gates that we need to pass. 

- 1) **First Gate:** 
The first gate is the same as before. By excecuting the call from another contract this gate will be satisfied.


- 2) **Second Gate:**
The ```extcodesize``` statement in here will return something greater than zero if the call is made from **inside** of another contract. Look at the bold word inside. On the Yellow Paper provided by the level (https://ethereum.github.io/yellowpaper/paper.pdf) you can see the theory behind this, but essentially the way to bypass is is to make the call while constructing the attacker contract! On such case, the ```extcodesize``` returns zero!

- 3) **Third Gate:**
We strongly recommend to check a chart on how the XOR operator return values change in function of its inputs. By checking the set operations analogues with logic operators, we can establish a relationship with this ```require``` statement in order to use logic in our advantage. On this link (https://accu.org/journals/overload/20/109/lewin_1915/) we can check the operation performed below.

From the theory: ```A ^ B = C ===> A ^ C = B ```

Also, by requiring the left side to be the same as ```uint64(0)-1``` on compiler versions ```< 0.8.0``` , this is an underflow that results in the biggest ```uint64``` number. 

Applying the XOR property shown before:

    uint64(bytes8(keccak256(abi.encodePacked(msg.sender)))) ^ uint64(_gateKey) == uint64(0) - 1 ;
    uint64(bytes8(keccak256(abi.encodePacked(msg.sender)))) ^ ( uint64(0) - 1 ) == uint64(_gateKey);
    
    // Thus...
    uint64 key64 = uint64(bytes8(keccak256(abi.encodePacked(address(this))))) ^ ( uint64(0) - 1 );
    
    // Using the underflow theory...
    uint64 key64 = uint64(bytes8(keccak256(abi.encodePacked(address(this))))) ^ ( type(uint64).max );

    // Casting the key into the proper variable, we get the key.
    bytes8 key = bytes8(key64);

By puttting everything together, we can create a contract that fits all the metioned requirements. Also, the shown contract has several helper functions that make this process more understandable.

Enjoy!