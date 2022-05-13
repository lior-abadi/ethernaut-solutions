import rlp
from eth_utils import keccak, to_checksum_address, to_bytes

def mk_contract_address(sender: str, nonce: int) -> str:
    sender_bytes = to_bytes(hexstr=sender)
    raw = rlp.encode([sender_bytes, nonce])
    h = keccak(raw)
    address_bytes = h[12:]
    return to_checksum_address(address_bytes)

sender = "0x22699e6AdD7159C3C385bf4d7e1C647ddB3a99ea"
nonce = 4192

print(mk_contract_address(sender, nonce))