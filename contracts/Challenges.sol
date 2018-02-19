pragma solidity ^0.4.18;

import './BeastBase.sol';

contract Challenges is AccessControl {

	struct Challenge {
		uint id;
		string name;
		bool isActive;
		uint strengthPonderation;
		uint dexterityPonderation;
		uint endurancePonderation;
		uint knowledgePonderation;
		uint wisdomPonderation;
		uint charismaonderation;
		uint randomFactor;
		uint expMultiplicator;
	}

	mapping (uint => Challenge) public challenges;

	modifier ownerOf(uint _beastId) {
    	require(msg.sender == beastIndexToOwner[_beastId]);
    	_;
  	}

	function Challenges () {
		
	}	

	function createChallenge(uint _id, string _name, uint _strengthPonderation, uint _dexterityPonderation,
	 uint _endurancePonderation, uint _knowledgePonderation, uint _wisdomPonderation, uint _charismaonderation,
	 uint _randomFactor, uint _expMultiplicator) 
	onlyCOO {
		Challenge memory _challenge = Challenge({
			id: _id,
            name: _name,
            strengthPonderation: _strengthPonderation,
            dexterityPonderation: _dexterityPonderation,
            endurancePonderation: _endurancePonderation,
            knowledgePonderation: _knowledgePonderation,
            wisdomPonderation: _wisdomPonderation,
            charismaonderation: _charismaonderation,
            randomFactor: _randomFactor,
            expMultiplicator: _expMultiplicator
        });
        challenges[_id] = _challenge;
	}

	function challengeBeast(uint _challengerId, uint _challengedId, uint _challengeId) 
	external ownerOf(_challengerId) {

  	}
}

