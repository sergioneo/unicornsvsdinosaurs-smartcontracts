pragma solidity ^0.4.18;

import './BeastMinting.sol';

contract Legends is BeastMinting {
  
    /// @notice Creates the main Legend smart contract instance.
    function Legends() public {
        // Starts paused.
        paused = false;

        // the creator of the contract is the initial CEO
        ceoAddress = msg.sender;

        // the creator of the contract is also the initial COO
        cooAddress = msg.sender;

        cfoAddress = msg.sender;

        // start with the mythical kitten 0 - so we don't have generation-0 parent issues
        _createBeast(0, 0, 0, uint256(-1), address(0));
    }

    /// @notice No tipping!
    /// @dev Reject all Ether from being sent here, unless it's from one of the
    ///  two auction contracts. (Hopefully, we can prevent user accidents.)
    function() external payable {
        require(
            msg.sender == address(saleAuction) ||
            msg.sender == address(siringAuction)
        );
    }

    function getLegend(uint256 _legendId) external view returns(
        bool isGestating,
        bool isReady,
        uint256 cooldownEndBlock,
        bool isReadyToFight,
        uint256 experience,
        uint256 birthTime,
        uint256 sireId,
        uint256 matronId,
        uint256 siringWithId,
        uint256 cooldownIndex,
        uint256 generation,
        uint256 genes
    ) {
      Beast storage legend = beasts[_legendId];

      isGestating = (legend.siringWithId != 0);
      isReady = (legend.cooldownEndBlock <= block.number);
      cooldownEndBlock = uint256(legend.cooldownEndBlock);
      isReadyToFight = (legend.challengeCoolDown <= block.number);
      experience = uint256(legend.experience);
      birthTime = uint256(legend.birthTime);
      sireId = uint256(legend.sireId);
      matronId = uint256(legend.matronId);
      siringWithId = uint256(legend.siringWithId);
      cooldownIndex = uint256(legend.cooldownIndex);
      generation = uint256(legend.generation);
      genes = legend.genes;
    }

    function getLegendAttrs(uint256 _legendId) external view returns(
        uint256 strength,
        uint256 dexterity,
        uint256 endurance,
        uint256 knowledge,
        uint256 wisdom,
        uint256 charisma
    ) {
        Beast storage legend = beasts[_legendId];

        strength = uint256(legend.attrs.strength);
        dexterity = uint256(legend.attrs.dexterity);
        endurance = uint256(legend.attrs.endurance);
        knowledge = uint256(legend.attrs.knowledge);
        wisdom = uint256(legend.attrs.wisdom);
        charisma = uint256(legend.attrs.charisma);
    }

    // @dev Allows the CFO to capture the balance available to the contract.
    function withdrawBalance() external onlyCFO {
        uint256 balance = this.balance;
        cfoAddress.transfer(balance);
    }

}
