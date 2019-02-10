pragma solidity >=0.4.24;

import "./BeastMinting.sol";

contract Beasts is BeastMinting {
  
    /// @notice Creates the main Legend smart contract instance.
    constructor() public {
        // Starts paused.
        paused = false;

        // the creator of the contract is the initial CEO, COO and CFO
        ceoAddress = msg.sender;
        cooAddress = msg.sender;
        cfoAddress = msg.sender;

        // start with the mythical Beasts 0, 1 & 2 - so we don't have generation-0 parent issues
        _createBeast(0, 0, 0, uint256(-1), ceoAddress);
        // TODO: Create beast 1 (UNI GOD) and 2 (DINO GOD)
        _createBeast(0, 0, 0, uint256(-1), ceoAddress);
        _createBeast(0, 0, 0, uint256(-1), ceoAddress);
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

    // TODO: Check gas usage
    function getLegend(uint256 _legendId) external view returns(
        uint race,
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

        race = legend.race;
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

    // TODO: Check gas usage
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
    // TODO: Check if this is a problem for the investors
    function withdrawBalance() external onlyCEO {
        uint256 balance = address(this).balance;
        cfoAddress.transfer(balance);
    }

}
