pragma solidity >=0.4.24;

import "./BeastAuction.sol";
import "./interface/GeneMagicInterface.sol";
import "./interface/EggFactoryInterface.sol";
import "./util/Random.sol";

contract BeastMinting is Random, BeastAuction {

    event EggOpened(uint256 legendId);
    event PromoBeastCreated(uint256 legendId);
    event RandomBoxOpened(uint256 legendId);
    event LegendaryRandomBoxOpened(uint256 legendId);

    uint256 public constant PROMO_CREATION_LIMIT = 150; // Limits the number of beast the contract owner can ever create.

    uint256 public promoBeastCreatedCount; // Amount of promo beasts created
    uint256 public randomBoxOpenedCount; // Amount of random boxes opened
    uint256 public legendaryRandomBoxOpenedCount; // Amount of legendary random boxes opened

    EggFactoryInterface public eggFactory;

    /// @dev Sets the reference to the egg factory
    /// @param _address - Address of egg factory contract.
    function setEggFactoryAddress(address _address) public onlyCEO {
        EggFactoryInterface candidateContract = EggFactoryInterface(_address);
        require(candidateContract.isEggFactory());
        eggFactory = candidateContract;
    }

    /**
     * Create a beast based on "PROMO"
     * @dev genes must be created outside in a custom way
     */
    function createPromoBeast(uint256 _genes, address _owner) external onlyCOO {
        require(_owner != address(0));
        require(promoBeastCreatedCount < PROMO_CREATION_LIMIT);

        uint256 legendId = _createBeast(0, 0, 0, _genes, _owner);
        promoBeastCreatedCount++;
        emit PromoBeastCreated(legendId);
    }

    /**
     * Create a beast based on a random box
     * @dev beast can be uni or dino
     */
    function createBeastFromRandomBox(address _owner) external onlyCOO {
        require(_owner != address(0));
        randomBoxOpenedCount++;
        // TODO: Random gens
        uint256 randomGens = random(1000000000000000);
        uint256 legendId = _createBeast(0, 0, 0, randomGens, _owner);
        emit RandomBoxOpened(legendId);
    }

    /**
     * Create a beast based on a legendary random box
     * @dev beast can be uni or dino and MUST be a Legedary pedigree
     */
    function createBeastFromLegendaryRandomBox(address _owner) external onlyCOO {
        require(_owner != address(0));
        legendaryRandomBoxOpenedCount++;
        // TODO: Specific gens for Legendary
        uint256 randomGens = random(1000000000000000);
        uint256 legendId = _createBeast(0, 0, 0, randomGens, _owner);
        emit LegendaryRandomBoxOpened(legendId);
    }

    // Mapping of eggs owned by an address
    // @dev: owner => ( eggId => eggsAmount )
    mapping ( address => mapping ( uint256 => uint256 ) ) public eggsOwned;

    /**
     * Hatch an egg of Egg Factory
     */
    function hatchEgg(uint256 _eggId, uint256 _amount) external {

        uint256 customGene;
        bool open;

        (,,,customGene,,,,,open,) = eggFactory.eggs(_eggId);

        require(open == true);
        require(eggsOwned[msg.sender][_eggId] + _amount <= eggFactory.eggsOwned(msg.sender,_eggId));

        for (uint256 i = 0; i < _amount; i++) {
            //TODO: Get base gens from Egg Scheme (_eggId)
            //uint256 randomGens = geneMagic(customGene);

            uint256 legendId = _createBeast(0, 0, 0, 0, msg.sender);
            eggsOwned[msg.sender][_eggId] += 1;
            emit EggOpened(legendId);
        }
    }

    function getEggInfo(uint256 _eggId) public returns(uint256, bool){
        uint256 customGene;
        bool open;

        (,,,customGene,,,,,open,) = eggFactory.eggs(_eggId);
        return (customGene, open);
    }
}