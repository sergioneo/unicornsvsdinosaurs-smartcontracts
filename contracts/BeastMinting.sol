pragma solidity ^0.4.18;

import './BeastAuction.sol';
import './interface/GeneScienceInterface.sol';

contract BeastMinting is BeastAuction {

    event EggBought(uint256 legendId);

    // Limits the number of beast the contract owner can ever create.
    uint256 public constant PROMO_CREATION_LIMIT = 1000;
    // Limits the number of eggs that will exists.
    uint256 public constant EGGS_LIMIT = 40000;
    uint256 public constant EGGS_PRICE_INCREASE = 500000000000000;
    uint256 public constant EGGS_PRICE_BASE = 3000000000000000;
    // Counts the number of beast the contract owner has created.
    uint256 public promoCreatedCount;
    uint256 public eggsCreatedCount;

    // TODO: Only COO
    function createPromoBeast(uint256 _genes, address _owner) external onlyCOO {
        require(promoCreatedCount < PROMO_CREATION_LIMIT);

        promoCreatedCount++;
        _createBeast(0, 0, 0, _genes, _owner);
    }

    // TODO: DOC
    // TODO: how to determine what type is (common, rare, legend, etc)
    function createBeastFromEgg() external payable {
        // The value must be equal to the current egg price
        require( getCurrentEggPrice() == msg.value );

        // Call the sooper-sekret gene mixing operation.
        //uint256 childGenes = geneScience.mixGenes(matron.genes, sire.genes, matron.cooldownEndBlock - 1);
        
        // TODO: Random gens
        uint256 randomGens = random(1000000000000000);
        uint legendId = _createBeast(0, 0, 0, randomGens, msg.sender);

        eggsCreatedCount++;

        EggBought(legendId);
    }

    /// @dev Computes the next egg price
    function getCurrentEggPrice() public view returns (uint256) {
        return EGGS_PRICE_BASE + (eggsCreatedCount * EGGS_PRICE_INCREASE);
    }


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
        _seed = uint256(keccak256(
            _seed,
            block.blockhash(block.number - 1),
            block.coinbase,
            block.difficulty
        ));
        return _seed;
    }

    // return a pseudo random number between lower and upper bounds
    // given the number of previous blocks it should hash.
    function random(uint256 upper) private returns (uint256 randomNumber) {
        return maxRandom() % upper;
    }
}