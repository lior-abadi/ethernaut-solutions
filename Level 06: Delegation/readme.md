## 1) Catch
The ```fallback``` function within the Delegation contract will be excecuted with a trigger and if the delegation is successfull it will assign the contract instance as a return. The trick in here is to rely on the pwn() function in some way to steal the ownership.


## 2) Solution
The logic of the contract Delegation is simple but tricky. The only way we can trick it is by calling in some way the fallback. Because this ```fallback``` function is ```not payable```, the msg sent to the contract must not include any ether nor wei. 

By sending an arbitrary msg to the Delegation contract the ```fallback``` function is triggered but an error is shown on the transaction explorer. This is because the delegation carries out what is encoded into the data contained into the message.

For example: if we send an empty transaction with data: ```"6578706c6f69746564"``` (which by the way means "exploited" expressed in hex) the fallback will be triggered but the delegation will be reversed.

Here is when the solution comes: to solve this level and exploit the contract we need to send explicit instructions to the Delegation to excecute the ```pwn()``` function inside the Delegate contract (which address is passed as a constructor argument of the Delegation contract). 

Last but not least, the ```delegatecall``` literally works as it does on companies with responsibility and tasks. You can delegate a task but the responsibility will always be yours. In smart contracts it's the same. The delegation delegates the logic of a certain excecution to another contract but the outcome of that excecution impacts directly into the delegation contract (the one who "fires" a certain task). Because in here both contracts have the same owner variable, and the delegation contract excecutes a public function of a library (on this case the Delegate contract) that modifies the ownership of the home contract. 

*On a company will be analogue to ask a trainee to write some code on your behalf and that code is vulnerable and exploited, because you were the one responsible for that task you will be fired thus the outcome of the delegation falls on you (or the payment bonus if the code was a breakthrough...).*

By using the script within the contract ```Solution06.sol``` we can generate the exact message that will trigger the fallback in the way we want. 

With the message created simply run in console:

```await contract.sendTransaction({from: player, value: 0, data: "0xdd365b8b"})```

That's it!

