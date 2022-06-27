## 1) Catch
This level encourages you to understand how to track down transactions on an explorer (e.g Etherscan). Follow the breadcrumbs!

`## 2) Solution` 
The factory creates a simple token instance once it is called. In order to recover the ether, there is no need to create a new token by calling `generateToken`. It is just needed to track down how are the tokens flowing on deployment of this level instance on Etherscan. The level should create an instance and assign `0.001 ether` to the simple token "missing" contract address.

Just follow the creation hash and scope that 0.001 ether are sent to an unknown address. That address is indeed a `SimpleToken` instance. By copy-pasting the token implementation on a Remix session and recovering the contract with the copied address from etherscan (clicking "Contract At Address"), then that contract will be available to interact with.

Once the contract is available, simply call `destroy(yourAddress)` which selfdestructs the token instance and forwards its balance towards the given address.

That's it. 