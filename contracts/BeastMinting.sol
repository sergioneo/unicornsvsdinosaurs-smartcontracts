pragma solidity ^0.4.18;

import './BeastOwnership.sol';

contract BeastMinting is BeastOwnership {

  // Limits the number of cats the contract owner can ever create.
  uint256 public constant PROMO_CREATION_LIMIT = 5000;
  // Counts the number of cats the contract owner has created.
  uint256 public promoCreatedCount;

  // TODO: Only COO
  function createPromoBeast(uint256 _genes, address _owner) external {
        require(promoCreatedCount < PROMO_CREATION_LIMIT);

        promoCreatedCount++;
        _createBeast(0, 0, 0, _genes, _owner);
    }
}