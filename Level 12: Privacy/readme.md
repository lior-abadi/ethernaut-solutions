## 1) Catch
The approach to solve this level will be the same of the level 8 (Vault). We need to access in someway the values stored in memory. Knowing that the Storage works as an array, how does the storage *packs* the data? Are all variables stored *independently* or they can be compressed into one storage unit? When?

## 2) Solution
The array of storage will be organized with the following logic. The uint256 variables occupy a whole storage unit. The variables below that size can be compressed into a single storage unit. The array of storage will contain on each index:

Storage At:
- 0: ```locked```
- 1: ```ID```
- 2: ```flattening```, ```denomination```, ```awkwardness```
- 3: ```data[0]```
- 4: ```data[1]```
- 5: ```data[2]```
- 6: ```data[3]```

By consulting the contract storageDataAt with the following script on console ```data[2]``` value can be known:

    const data2 = await web3.eth.getStorageAt(await contract.address, 5)

We must cast the value of data2 because the array of data is defined as ```bytes32``` but the ```unlock``` function checks its casted value at ```bytes16```!

Any tool can be used to do that casting, here is a simple Solidity implementation that achieves this:

    function casting(bytes32 _data32) public pure returns(bytes16){
        return bytes16(_data32);
    }
