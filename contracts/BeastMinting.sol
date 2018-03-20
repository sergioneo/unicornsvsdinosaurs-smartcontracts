pragma solidity ^0.4.18;

import './BeastAuction.sol';
import './interface/GeneMagicInterface.sol';
import './util/Random.sol';

contract BeastMinting is Random, BeastAuction {

    event UniEggBought();
    event DinoEggBought();

    event EggOpened(uint256 legendId);

    event PromoBeastCreated(uint256 legendId);
    event RandomBoxOpened(uint256 legendId);
    event LegendaryRandomBoxOpened(uint256 legendId);

    // Limits the number of beast the contract owner can ever create.
    uint256 public constant PROMO_CREATION_LIMIT = 1000;

    // Limits the number of eggs that will exists.
    uint256 public constant EGGS_LIMIT = 4000;
    // Base price of the eggs
    uint256 public constant EGGS_PRICE_INCREASE = 500000000000000;
    // Increate amount after bought one egg
    uint256 public constant EGGS_PRICE_BASE = 3000000000000000;

    mapping (address => uint256) uniEggsOwned; // Amount of uni eggs owned by an address
    mapping (address => uint256) dinoEggsOwned; // Amount of dino eggs owned by an address

    uint256 public promoBeastCreatedCount; // Amount of promo beasts created

    uint256 public randomBoxOpenedCount; // Amount of random boxes opened
    uint256 public legendaryRandomBoxOpenedCount; // Amount of legendary random boxes opened

    uint256 public eggsUniBoughtCount; // Amount of uni eggs bought
    uint256 public eggsDinoBoughtCount; // Amount of dino eggs bought

    bool public eggsCanBeBought = true; // Indicates that an egg can be bought
    bool public eggsCanBeOpened = false; // Indicates that an egg can be opened

    function setEggsCanBeBought(bool newState) external onlyCEO {
        eggsCanBeBought = newState;
    }

    function setEggsCanBeOpened(bool newState) external onlyCEO {
        eggsCanBeOpened = newState;
    }

    /**
     * Create a beast based on "PROMO"
     * @dev genes must be created outside in a custom way
     */
    function createPromoBeast(uint256 _genes, address _owner) external onlyCOO {
        require(_owner != address(0));
        require(promoBeastCreatedCount < PROMO_CREATION_LIMIT);

        promoBeastCreatedCount++;
        uint256 legendId = _createBeast(0, 0, 0, _genes, _owner);
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
        // TODO: Random gens
        uint256 randomGens = random(1000000000000000);
        uint256 legendId = _createBeast(0, 0, 0, randomGens, _owner);
        emit LegendaryRandomBoxOpened(legendId);
    }

    /**
     * Bought an Uni egg
     * @dev amount of eggs must increase on an address
     */
    function buyUniEgg() external payable {
        require(eggsCanBeBought == true);
        require(getCurrentUniEggPrice() == msg.value);
        eggsUniBoughtCount++;
        uniEggsOwned[msg.sender]++;
    }

    /**
     * Hatch an owned Uni egg
     * @dev genes MUST be of Uni
     */
    function createUniFromEgg() external {
        require(eggsCanBeOpened == true);
        require(uniEggsOwned[msg.sender] > 0);
        // TODO: Random gens
        uint256 randomGens = random(1000000000000000);
        uint256 legendId = _createBeast(0, 0, 0, randomGens, msg.sender);

        uniEggsOwned[msg.sender]--;

        emit EggOpened(legendId);
    }

    // @dev Computes the next egg price for Unis
    function getCurrentUniEggPrice() public view returns (uint256) {
        return EGGS_PRICE_BASE + (eggsUniBoughtCount * EGGS_PRICE_INCREASE);
    }

    /**
     * Bought a Dino egg
     * @dev amount of eggs must increase on an address
     */
    function buyDinoEgg() external payable {
        require(eggsCanBeBought == true);
        require(getCurrentDinoEggPrice() == msg.value);
        eggsDinoBoughtCount++;
        dinoEggsOwned[msg.sender]++;
    }

    /**
     * Hatch an owned Dino egg
     * @dev genes MUST be of Dino
     */
    function createDinoFromEgg() external {
        require(eggsCanBeOpened == true);
        require(dinoEggsOwned[msg.sender] > 0);
        // TODO: Random gens
        uint256 randomGens = random(1000000000000000);
        uint256 legendId = _createBeast(0, 0, 0, randomGens, msg.sender);

        dinoEggsOwned[msg.sender]--;

        emit EggOpened(legendId);
    }

    // @dev Computes the next egg price for Dinos
    function getCurrentDinoEggPrice() public view returns (uint256) {
        return EGGS_PRICE_BASE + (eggsDinoBoughtCount * EGGS_PRICE_INCREASE);
    }
}