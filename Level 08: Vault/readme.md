## 1) Catch
It is a key to understand where each variable lives in and how this can be exploited. Also, think about what happens with visibility on **each** contract state (development, deployment, etc.).

## 2) Solution
Because the variables are private for the contract in terms of visibility, they can still be accessed during the deployment constructor parameters. In here, the ```_password``` is passed as a deployment variable and it can be scoped on etherscan using the following link under **"Constructor Arguments"**:

- Deployment: https://rinkeby.etherscan.io/address/0xB32Ef1e8b55FE270Bc665F52076bc677B0D02f8f#code
- _password: ```0x412076657279207374726f6e67207365637265742070617373776f7264203a29```

By sending the ```unlock()``` transaction with the ```_password``` this level is completed!