pragma solidity ^0.4.18;

contract EggFactory {
    
    event EggOpened(uint256 beastId);
    
    struct EggScheme{
        uint256 id;
        uint256 max; // max available eggs. zero for unlimited
        uint256 buy; // purchased eggs
        uint256 customGene; // custom gene for future beast
        
        uint256 increase; // price increase. zero for no increase
        uint256 price; // base price of the egg
        
        bool active; // is the egg active to be bought
        bool open; // is the egg active to be opened 
        bool isEggScheme;
    }
    
    // Mapping of existing eggs 
    // @dev: uint256 is the ID of the egg scheme
    mapping (uint256 => EggScheme) public eggs;
    uint256[] eggsIndexes;
    
    // Mapping of eggs owned by an address
    // @dev: owner => ( eggId => eggsAmount )
    mapping ( address => mapping ( uint256 => uint256 ) ) private eggsOwned;
    
    // Add modifier of onlyCOO
    function createEggScheme( uint256 _eggId, uint256 _max, uint256 _customGene, uint256 _price, uint256 _increase, bool _active, bool _open ) public {
        eggs[_eggId].isEggScheme = true;
        
        eggs[_eggId].id = _eggId;
        eggs[_eggId].max = _max;
        eggs[_eggId].buy = 0;
        eggs[_eggId].customGene = _customGene;
        eggs[_eggId].price = _price;
        eggs[_eggId].increase = _increase;
        
        eggs[_eggId].active = _active;
        eggs[_eggId].open = _open;
        
        eggsIndexes.push(_eggId);
    }
    
    // Add modifier onlyCOO
    function setActiveStatusEgg( uint256 _eggId, bool state ) public {
        eggs[_eggId].active = state;
    }
    
    // Add modifier onlyCOO
    function setOpenStatusEgg( uint256 _eggId, bool state ) public {
        eggs[_eggId].open = state;
    }
    
    function buyEgg(address _owner, uint256 _eggId, uint256 _amount) public payable {
        require(eggs[_eggId].active == true);
        require((currentEggPrice(_eggId)*_amount) == msg.value);
        
        eggs[_eggId].buy += _amount;
        eggsOwned[_owner][_eggId] += _amount;
    } 
    
    function currentEggPrice( uint256 _eggId ) public view returns (uint256) {
        return eggs[_eggId].price + (eggs[_eggId].buy * eggs[_eggId].increase);
    }
    
    function openEgg(address _owner, uint256 _eggId, uint256 _amount) public {
        require(eggs[_eggId].open == true);
        require(eggsOwned[_owner][_eggId] >= _amount);
        
        // Give to geneMagic the custom genes of the egg for the beast definition
        //uint256 randomGens = random(1000000000000000);
        //uint256 beastId = _createBeast(0, 0, 0, randomGens, msg.sender);

        eggsOwned[_owner][_eggId] -= _amount;

        //emit EggOpened(beastId);
    }
}