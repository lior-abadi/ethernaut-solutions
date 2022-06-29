from web3 import Web3
from random import randrange



def gen_signature(name:str, *args) -> str:
    joinedParams = ",".join(args) 
    bytesTruncatedHash = Web3.sha3(text = f"{name}({joinedParams})")[0:4]
    return Web3.toHex(bytesTruncatedHash)



print(gen_signature("owner"))