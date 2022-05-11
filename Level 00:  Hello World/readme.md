Script used on the browser console to win the level:

Walkthrough:
player

await getBalance(player)

ethernaut

await ethernaut.owner()

1) Catch:
    The contract is not verified on Etherscan, the only way to dig into it is to 
    explore the functions by calling:
        contract.abi

2) Solution:
let pword = await contract.password() // pword = "ethereum0"

await contract.authenticate(pword)

Submit Instance.

3) Explanation:
    The contract validates that the password is correct by calling authenticate.

