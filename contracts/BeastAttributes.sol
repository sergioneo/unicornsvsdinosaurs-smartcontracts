pragma solidity >=0.4.24;

import "./BeastBase.sol";

contract BeastAttributes is BeastBase {
    /*** EVENTS ***/


    /// @dev Transfer event as defined in current draft of ERC721. Emitted every time a beast
    ///  ownership is assigned, including births.
    event Level(uint _beastID, uint _from, uint _to);
    event ChangePreferedAttribute(uint _beastID, uint _from, uint _to);

    /// Table indicating experience requiere for each level
    uint[20] public experienceRequiredForLevel = [
        uint(2),
        uint(4),
        uint(8),
        uint(16),
        uint(32),
        uint(64),
        uint(128),
        uint(256),
        uint(512),
        uint(1024),
        uint(2048),
        uint(4096),
        uint(8192),
        uint(16384),
        uint(32768),
        uint(65536),
        uint(131072),
        uint(262144),
        uint(524288),
        uint(1048576)
    ];

    // Return Skill Value based on Attribute ID for specific beast
    function skillValue(uint _attributeID, uint _tokenId) public returns (uint) {
        Beast storage _beast = beasts[_tokenId];
        if (_attributeID == 1) {
            return _beast.attrs.strength;
        } else if(_attributeID == 2) {
            return _beast.attrs.dexterity;
        } else if(_attributeID == 3) {
            return _beast.attrs.endurance;
        } else if(_attributeID == 4) {
            return _beast.attrs.knowledge;
        } else if(_attributeID == 5) {
            return _beast.attrs.wisdom;
        } else if(_attributeID == 6) {
            return _beast.attrs.charisma;
        }
    }


    function levelUp(uint _tokenId, uint _toLevel) internal {
        Beast storage _beast = beasts[_tokenId];
        require(_beast.experience >= experienceRequiredForLevel[_toLevel - 1]);
        // emit the Level event
        emit Level(_tokenId, _toLevel -1, _toLevel);
        // Add Prefered Skills
        if(_beast.preferedAttribute == 1) {
            _beast.attrs.strength += 1;
        } else if(_beast.preferedAttribute == 2) {
            _beast.attrs.dexterity += 1;
        } else if(_beast.preferedAttribute == 3) {
            _beast.attrs.endurance += 1;
        } else if(_beast.preferedAttribute == 4) {
            _beast.attrs.knowledge += 1;
        } else if(_beast.preferedAttribute == 5) {
            _beast.attrs.wisdom += 1;
        } else if(_beast.preferedAttribute == 6) {
            _beast.attrs.charisma += 1;
        }
        // Add remaining Random Skills
        for(uint i = 0; i < 3; i++) {
            uint forRandom = block.difficulty + now + i + _tokenId;
            uint randomAttribute = uint(keccak256(toBytes(forRandom))) % 6 + 1;
            if(randomAttribute == 1) {
                _beast.attrs.strength += 1;
            } else if(randomAttribute == 2) {
                _beast.attrs.dexterity += 1;
            } else if(randomAttribute == 3) {
                _beast.attrs.endurance += 1;
            } else if(randomAttribute == 4) {
                _beast.attrs.knowledge += 1;
            } else if(randomAttribute == 5) {
                _beast.attrs.wisdom += 1;
            } else if(randomAttribute == 6) {
                _beast.attrs.charisma += 1;
            }
        }
    }

    function toBytes(uint x) internal returns (bytes memory b) {
        b = new bytes(32);
        assembly { mstore(add(b, 32), x) }
    }

    function changePreferedAttribute(uint _tokenId, uint _preferedAttribute) public {
        require(beastIndexToOwner[_tokenId] == msg.sender);

        Beast storage _beast = beasts[_tokenId];
        require(_beast.preferedAttribute != _preferedAttribute);
        require(_preferedAttribute <= 6 || _preferedAttribute > 0);
        // emit the Level event
        emit ChangePreferedAttribute(_tokenId, _beast.preferedAttribute, _preferedAttribute);
        _beast.preferedAttribute = uint8(_preferedAttribute);
    }
}