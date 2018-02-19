pragma solidity ^0.4.18;

contract Challenges is AccessControl {

	struct Challenge {
		uint id;
		string name;
		uint strengthPonderation;
		uint dexterityPonderation;
		uint endurancePonderation;
		uint knowledgePonderation;
		uint wisdomPonderation;
		uint charismaonderation;
		uint randomFactor;
		uint expBase;
	}

	mapping (uint => Challenge) public challenges;

	function Challenges () {
		
	}	

	function createChallenge(uint _id, string _name, uint _strengthPonderation, uint _dexterityPonderation,
	 uint _endurancePonderation, uint _knowledgePonderation, uint _wisdomPonderation, uint _charismaonderation,
	 uint _randomFactor, uint _expBase) 
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
            expBase: _expBase
        });
        challenges[_id] = _challenge;
	}
}

