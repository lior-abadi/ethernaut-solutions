## 1) Catch
The key concept in here is to understand the main difference between how does the **vanilla** >0.8.0 compiler versions like the 0.6.0 work with numbers.


## 2) Solution
From the hint, a odometer (dial with sliding numbers below the speedometer of older cars) resets its value to zero when the chain of 9999999 is exceeded (a.k.a overflowed). In versions below 0.8.0, libraries like OpenZeppelin's SafeMath are required to prevent numbers from overflowing. The overflow check comes as a built-in feature in vanilla Solidity after 0.8.0 versions.

You just need to reset the unsigned integer number and this level will be cracked.

    await contract.transfer(contract.address, 19)
    await contract.transfer(contract.address, 2)
