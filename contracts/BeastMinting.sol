pragma solidity ^0.4.18;

import './BeastAuction.sol';
import './interface/GeneScienceInterface.sol';
import './util/Random.sol';

contract BeastMinting is Random, BeastAuction {

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
}