pragma solidity ^0.4.18;

import './BeastBase.sol';
import './ExperienceSystems.sol';

contract ChallengeSystem is AccessControl, ExperienceSystems {

	struct Challenge {
		uint id;
		string name;
		bool isActive;
		uint minLevelRequired;
		uint strengthPonderation;
		uint dexterityPonderation;
		uint endurancePonderation;
		uint knowledgePonderation;
		uint wisdomPonderation;
		uint charismaPonderation;
		uint randomFactor; // How much you can add to the sum calculation.
		uint experienceSystemId;
	}

	mapping (uint => Challenge) public challenges;

	modifier ownerOf(uint _beastId) {
    	require(msg.sender == beastIndexToOwner[_beastId]);
    	_;
  	}

	function ChallengeSystem () {
		
	}	

	// Create a new challenge, important to have Unique ID
	function createChallenge(uint _id, string _name, uint _minLevelRequired, uint _strengthPonderation, uint _dexterityPonderation,
	 uint _endurancePonderation, uint _knowledgePonderation, uint _wisdomPonderation, uint _charismaPonderation,
	 uint _randomFactor, uint _experienceSystemId) 
	external onlyCOO {
		Challenge memory _challenge = Challenge({
			id: _id,
            name: _name,
            isActive: true,
            minLevelRequired: _minLevelRequired,
            strengthPonderation: _strengthPonderation,
            dexterityPonderation: _dexterityPonderation,
            endurancePonderation: _endurancePonderation,
            knowledgePonderation: _knowledgePonderation,
            wisdomPonderation: _wisdomPonderation,
            charismaPonderation: _charismaPonderation,
            randomFactor: _randomFactor,
            experienceSystemId: _experienceSystemId
        });
        challenges[_id] = _challenge;
	}

	// Edit a deployed challenge, only you can change active, exp system, isActive and minLevelRequired
	function editChallenge(uint _challengeId, bool _isActive, uint _randomFactor, uint _experienceSystemId, uint _minLevelRequired) external onlyCOO {
		Challenge storage _challenge = challenges[_challengeId];
		_challenge.isActive = _isActive;
		_challenge.randomFactor = _randomFactor;
		_challenge.experienceSystemId = _experienceSystemId;
		_challenge.minLevelRequired = _minLevelRequired;
	}

	// Function that executes a challenge, here we calculate winner and handle Exp + Ranking.
	function challengeBeast(uint _challengerId, uint _challengedId, uint _challengeId) 
	external ownerOf(_challengerId) retruns(uint) {
		require(challenges[_id].isActive == true);

		Challenge memory _challenge = challenges[_challengeId];
		require(beasts[_challengerId].level >= _challenge.minLevelRequired);

		Beast storage _challenger = beasts[_challengerId];
		Beast storage _challenged = beasts[_challengedId];

		uint challengerSum = strengthPonderation * _challenger.attrs.strenght;
		challengerSum += dexterityPonderation * _challenger.attrs.dexterity;
		challengerSum += endurancePonderation * _challenger.attrs.endurance;
		challengerSum += knowledgePonderation * _challenger.attrs.knowledge;
		challengerSum += wisdomPonderation * _challenger.attrs.wisdom;
		challengerSum += charismaPonderation * _challenger.attrs.charisma;
		challengerSum += uint(keccak256(block.difficulty, now, _challengerId)) % _challenge.randomFactor;

		uint challengedSum = strengthPonderation * _challenged.attrs.strenght;
		challengedSum += dexterityPonderation * _challenged.attrs.dexterity;
		challengedSum += endurancePonderation * _challenged.attrs.endurance;
		challengedSum += knowledgePonderation * _challenged.attrs.knowledge;
		challengedSum += wisdomPonderation * _challenged.attrs.wisdom;
		challengedSum += charismaPonderation * _challenged.attrs.charisma;
		challengedSum += uint(keccak256(block.difficulty, now, _challengedId)) % _challenge.randomFactor;

		uint winnerId = 0;
		uint looserId = 0;

		if (challengerSum > challengedSum) {
			winnerId = _challengerId;
			looserId = _challengedId;
			// TODO: Ranking
		} else {
			winnerId = _challengedId;
			looserId = _challengerId;
			// TODO: Ranking
		}
		calculateExperience(_challenge.experienceSystemId, winnerId, looserId);

		return winnerId;
  	}
}

