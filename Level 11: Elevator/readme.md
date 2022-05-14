## 1) Catch
Look closely at the interface, and ask yourself... do interfaces have implemented functions? 
Although it may seem a little bit confusing, what we need in here is to access the ```if statement``` inside the ```goTo()``` function in such way to crack the boolean logic this contract relies on.

## 2) Solution
The idea in here is to implement the ```isLastFloor``` function inside a contract that excecutes the needed logic. We need to code a function that alternates the boolean return value each time it is called.

On the ```Solution11.sol``` file, it is shown that implementation!
