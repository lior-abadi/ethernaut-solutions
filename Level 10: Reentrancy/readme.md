## 1) Catch
There are many concepts illustrated in here. The key for this contract to be exploitable is the fact that it updates the internal balance mapping **after** performin the transaction. By combinating fallback functions and regular ones so a loop is created, this contract can be exploited.

## 2) Solution
The theory in here can be dissected into several parts to understan what's going on.
There are two contracts. A and B.
- Contract A: The exploitable. It has functions that allow the inlet and outlet of tokens to several user having a withdraw function poorly implemented.
- Contract B: The attacker. Exploits the poorly implemented withdraw function of contract A.

The solution is an exploiter contract implemented on ```Solution10.sol```.

Lets assum that contract A has a balance of 100 ETH from different users and has a balance mapping to track how many tokens have a user deposited. Here comes an attacker that designs a exploit smart contract to attack A. The contract B has a function that calls repetidely the withdraw function of the contract A. We will analyze line by line of the vulnerable ```withdraw()``` function.

        function withdraw(uint _amount) public {
        if(balances[msg.sender] >= _amount) {
        (bool result,) = msg.sender.call{value:_amount}(""); // <----------- **Reentrant Line**
        if(result) {
            _amount;
        }
        balances[msg.sender] -= _amount;
        }
    }

Before explaining the whole process, the **Reentrant Line** is when the fallback function of the attacker contract is triggered which causes a recurrent call on the withdraw function.

1) The conditional checks if the caller has a balance registered on the contract mapping. That's why it is important to generate a deposit before excecuting this exploit.
2) The low level call function just excecutes to transfer the ```_amount``` of tokens.
3) After the tokens are transfered, the contract updates the local balance mapping of the withdrawer.

This function has several issues:
1) The balances are checked with a conditional that does not reverts. It is advisable to use a ```require``` statement to revert the call if the condition is not fulfilled.
2) The contract updates the mapping **after** transfering the funds. This update should be done before excecuting the call/send/transfer method so that when the function runs again, the ```require``` at the beginning checkes the updated value.
3) The ```call``` method should check that the ```result``` is true by adding a ```require``` statement the line after it.
4) Last but not least, the function itself must have a ```reentrancy mutex```.

We will first cover the first three items to design a non-reentrant function and then implement the last item.
An example lackling a mutex should be:

    
    function withdraw(uint _amount) public {
        require(balances[msg.sender] >= _amount, "You don't have that amount of tokens!"); 
        balances[msg.sender] -= _amount;
        (bool result,) = msg.sender.call{value:_amount}("");
        require(result);
    }
    

**About the Mutex:**
The mutex itself can be implemented as a function modifier or function calls inside the function.

- Option A: Mutex inside the function.
    ```
    bool reentrancyMutex = false;
    function withdraw(uint _amount) public {
        require(!reentrancyMutex, "Reentrant call");
        reentrancyMutex = true;
        require(balances[msg.sender] >= _amount, "You don't have that amount of tokens!"); 
        balances[msg.sender] -= _amount;
        (bool result,) = msg.sender.call{value:_amount}("");
        require(result);
        reentrancyMutex = false;
    }
    ```
In here, the function should be fully excecuted, if there is a reentrant call, the last line of code won't be run and the first ```require``` will revert the excecution.

- Option B: Mutex as a modifier. Using ```ReentrancyGuard.sol```.
    ```
    function withdraw(uint _amount) public nonReentrant(){
        require(balances[msg.sender] >= _amount, "You don't have that amount of tokens!"); 
        balances[msg.sender] -= _amount;
        (bool result,) = msg.sender.call{value:_amount}("");
        require(result);
    }
    ```

    The logic is the same as option A but implemented on a modifier. You can check the modifier code by visiting: 
    https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.6.0/contracts/security/ReentrancyGuard.sol
