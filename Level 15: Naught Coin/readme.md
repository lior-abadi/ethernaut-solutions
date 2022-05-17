## 1) Catch
Think about the ways we have to transfer, send, receive and manage ERC20 compliant tokens. Understanding how a DEX contract manages deposits, transfers and withdrawals may help to solve this level.


## 2) Solution
It is important to understand what is overriding this token contract and how this works. The ```Naught Token``` inherits every compliant functions of a standard ERC20 token. If we dig into the standard we see several methods that give us liberty to manage our assets. 

We will rely on the ```allowance``` theory in here. 

### **WTF is this Alonso, Alo Wan, Obi Wan, Allowance guy anyways?**
To answer this we will go to the roots of this. Really. We are programming and studying smart **contracts**. They are a resemblance to old, rusty and traditional law contracts where each function and statement can be interpreted as clauses and rights transfers. While signing a contract you are giving compliance on what it is said in there and in such way you should be awaiting for something to happen in order to execute what the contract says.

For example, you sign a leasing contract that has a clause that allows you to buy or renew the leased good once the period is finished. This has an implicate logic. Once something happens, you acquire (or loose) a right to do something.

What has this to do with the Obi Wan guy? The allowance concept of an ERC20 compliant contract is a way to give someone else the right to use a specific amount of tokens you own as they wish. For example, you allow me with an amount of 10ETH. First you sign that allowance increase (check the term *sign* as in regular contracts). Then, I will have the right to use your 10ETH on your behalf. If I decide to transfer them, those tokens go out of **your** wallet. In other words, the allowance can be interpreted as the right to do something on someones behalf.

This level relies on this logic. The method that is locked to perform a transfer for 10 years is the overridden ```transfer``` method with the ```lockTokens``` modifier. So a workaround here is to extract our tokens by giving someone else the right to transfer those tokens. The catch in here is that the transfer will be performed using the ```transferFrom``` method instead of the modified ```transfer``` one.

To do so, we need to create a contract that drains our tokens and then allow that contract with the desired amount.

This allowance increment can be easily done with scripts or by calling directly the function from the ERC20 inherited functions of the contract.

First lets deploy the ```DrainingWallet``` contract.


    // SPDX-License-Identifier: MIT
    pragma solidity ^0.8.0;

    import '@openzeppelin/contracts/token/ERC20/ERC20.sol';

    contract DrainingWallet{
        ERC20 naughtCoin;
        constructor(address _tokenAddress){
            naughtCoin = ERC20(_tokenAddress);
        }
        // The holder needs to increase the allowance of _amount of tokens to this contract prior calling drain.
        function drain(uint _amount) public {
            naughtCoin.transferFrom(msg.sender, address(this), _amount);
        }
    }


You can first create a level instance from the Ethernaut site and then use the instance address while deploying this on Remix.


    // SPDX-License-Identifier: MIT
    pragma solidity ^0.8.0;

    import '@openzeppelin/contracts/token/ERC20/ERC20.sol';

    contract NaughtCoin is ERC20 {
        // string public constant name = 'NaughtCoin';
        // string public constant symbol = '0x0';
        // uint public constant decimals = 18;
        uint public timeLock = block.timestamp + 10 * 365 days;
        uint256 public INITIAL_SUPPLY;
        address public player;

        constructor(address _player) 
        ERC20('NaughtCoin', '0x0')
        {
            player = _player;
            INITIAL_SUPPLY = 1000000 * (10**uint256(decimals()));
            // _totalSupply = INITIAL_SUPPLY;
            // _balances[player] = INITIAL_SUPPLY;
            _mint(player, INITIAL_SUPPLY);
            emit Transfer(address(0), player, INITIAL_SUPPLY);
        }
    
        function transfer(address _to, uint256 _value) override public lockTokens returns(bool) {
            super.transfer(_to, _value);
        }

    // Prevent the initial owner from transferring tokens until the timelock has passed
        modifier lockTokens() {
            if (msg.sender == player) {
            require(block.timestamp > timeLock);
            _;
            } else {
            _;
            }
        } 
    } 


This last contract inherits the ```increaseAllowance``` function of the ERC20 contract. By calling it like so:

    increaseAllowance(DrainingWalletAddress, playerTokenBalance);

With the first parameter being the address of the first deployed contract and the second one the balance of the player (```1000000000000000000000000```).

Once we have increased the allowance to the drainer contract, we simply call ```drain``` and the tokens will be gone!

Congratulations, thanks to ObiWan-ce you were able to crack this!