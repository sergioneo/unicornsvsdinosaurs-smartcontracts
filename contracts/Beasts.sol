pragma solidity ^0.4.18;

import 'node_modules/zeppelin-solidity/contracts/token/ERC721/ERC721.sol';

contract Beasts {
  struct Attrs {
        uint8 strength;
        uint8 dexterity;
        uint8 endurance;
        uint8 knowledge;
        uint8 wisdom;
        uint8 charisma;
    }
    struct Beast {
        uint256 genes; // first bite represent the type ( uni or dino )
        uint64 birthTime;
        uint64 coolDown;
        uint32 fatherId;
        uint32 motherId;
        uint32 breedWithId;
        Attrs attrs;
    }
    
    mapping (uint256 => address) public beastIndexToOwner;
    Beast[] beasts;
    
    function _createBest() internal returns (uint256);
}
