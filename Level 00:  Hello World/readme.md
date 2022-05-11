## 1) Catch:
The contract is not verified on Etherscan, the only way to dig into it is to 
explore the functions by calling:
    contract.abi

## 2) Solution:
The contract validates that the password is correct by calling authenticate.

    let pword = await contract.password() // pword = "ethereum0"

    await contract.authenticate(pword)

Submit Instance.

    

