pragma solidity ^0.4.18;

import './BeastBase.sol';


contract BeastAttributes is AccessControl {
    /*** EVENTS ***/


    /// @dev Transfer event as defined in current draft of ERC721. Emitted every time a kitten
    ///  ownership is assigned, including births.
    event Transfer(address from, address to, uint256 tokenId);


    function levelUp(uint _tokenId, uint _toLevel) internal {
        Beast storage _beast = beasts[_tokenId]
        require(_beast.experience >= experienceRequiredForLevel[_toLevel - 1]);
        // Add Prefered Skills
            if(_beast.preferedAttribute == 0) {
                _beast.attrs.strength += 1;
            } else if(_beast.preferedAttribute == 1) {
                _beast.attrs.dexterity += 1;
            } else if(_beast.preferedAttribute == 2) {
                _beast.attrs.endurance += 1;
            } else if(_beast.preferedAttribute == 3) {
                _beast.attrs.knowledge += 1;
            } else if(_beast.preferedAttribute == 4) {
                _beast.attrs.wisdom += 1;
            } else if(_beast.preferedAttribute == 5) {
                _beast.attrs.charisma += 1;
            }
        // Add remaining Random Skills
        for(uint i = 0; i < 3; i++) {
            uint randomAttribute = uint(keccak256(block.difficulty, now, beasts, i, _tokenId)) % 6;
            if(randomAttribute == 0) {
                _beast.attrs.strength += 1;
            } else if(randomAttribute == 1) {
                _beast.attrs.dexterity += 1;
            } else if(randomAttribute == 2) {
                _beast.attrs.endurance += 1;
            } else if(randomAttribute == 3) {
                _beast.attrs.knowledge += 1;
            } else if(randomAttribute == 4) {
                _beast.attrs.wisdom += 1;
            } else if(randomAttribute == 5) {
                _beast.attrs.charisma += 1;
            }
        }
    }

    function changePreferedAttribute(uint _tokenId, uint _preferedAttribute) onlyOwner {
        Beast storage _beast = beasts[_tokenId]
        require(_beast.preferedAttribute != _preferedAttribute);
        _beast.preferedAttribute = _preferedAttribute;
    }
}