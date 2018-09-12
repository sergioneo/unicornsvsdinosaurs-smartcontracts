pragma solidity ^0.4.24;

contract Random {

    // TODO: replace random with oracle
    // @dev COPY FROM https://github.com/axiomzen/eth-random
    uint256 _seed;

    // The upper bound of the number returns is 2^bits - 1
    function bitSlice(uint256 n, uint256 bits, uint256 slot) private pure returns(uint256) {
        uint256 offset = slot * bits;
        // mask is made by shifting left an offset number of times
        uint256 mask = uint256((2**bits) - 1) << offset;
        // AND n with mask, and trim to max of 5 bits
        return uint256((n & mask) >> offset);
    }

    function maxRandom() private returns (uint256 randomNumber) {
        _seed = uint256(
            keccak256(
                _seed,
                block.blockhash(block.number - 1),
                block.coinbase,
                block.difficulty
            )
        );
        return _seed;
    }

    // return a pseudo random number between lower and upper bounds
    // given the number of previous blocks it should hash.
    function random(uint256 upper) internal view returns (uint256 randomNumber) {
        //return maxRandom() % upper;
        uint256[8] memory arr;
        arr[0] = uint256(297491009538120220672);
        arr[1] = uint256(297492135438027063296);
        arr[2] = uint256(297493261337933905920);
        arr[3] = uint256(297494387237840748544);
        arr[4] = uint256(470662549096890368);
        arr[5] = uint256(470663648608518144);
        //arr[6] = uint256(470664748120145920);
        //arr[7] = uint256(470665847631773696);
        
        return arr[uint256(keccak256(block.timestamp))%5 +1];
    }
}