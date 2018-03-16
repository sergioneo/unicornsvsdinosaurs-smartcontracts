pragma solidity ^0.4.18;

import './BeastBase.sol';
import './ExperienceSystems.sol';
import './SkillsSystems.sol';

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
	external ownerOf(_challengerId) returns(uint) {
		require(challenges[_challengeId].isActive == true);

		Challenge memory _challenge = challenges[_challengeId];
		require(beasts[_challengerId].level >= _challenge.minLevelRequired);

		Beast storage _challenger = beasts[_challengerId];
		Beast storage _challenged = beasts[_challengedId];
		uint challengerBonus = 0;

		uint challengerSum = _challenge.strengthPonderation * _challenger.attrs.strength;
		challengerSum += _challenge.dexterityPonderation * _challenger.attrs.dexterity;
		challengerSum += _challenge.endurancePonderation * _challenger.attrs.endurance;
		challengerSum += _challenge.knowledgePonderation * _challenger.attrs.knowledge;
		challengerSum += _challenge.wisdomPonderation * _challenger.attrs.wisdom;
		challengerSum += _challenge.charismaPonderation * _challenger.attrs.charisma;
		challengerSum += uint(keccak256(block.difficulty, now, _challengerId)) % _challenge.randomFactor;
		challengerSum += skillAttributeBonus(_challengerId);

		uint challengedSum = _challenge.strengthPonderation * _challenged.attrs.strength;
		challengedSum += _challenge.dexterityPonderation * _challenged.attrs.dexterity;
		challengedSum += _challenge.endurancePonderation * _challenged.attrs.endurance;
		challengedSum += _challenge.knowledgePonderation * _challenged.attrs.knowledge;
		challengedSum += _challenge.wisdomPonderation * _challenged.attrs.wisdom;
		challengedSum += _challenge.charismaPonderation * _challenged.attrs.charisma;
		challengedSum += uint(keccak256(block.difficulty, now, _challengedId)) % _challenge.randomFactor;
		challengedSum += skillAttributeBonus(_challengedId);

		if (elementBonus(_challengerId, _challengedId) == _challengerId) {
			challengerSum = challengerSum * 1.1;
		} else if (elementBonus(_challengerId, _challengedId) == _challengedId) {
			challengedSum = challengedSum * 1.1;
		}

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
		calculateLevel(_challenger.experience, _challenger.level);
		calculateLevel(_challenged.experience, _challenged.level);

		return winnerId;
  	}

	// Earth = 0, Water = 1, Fire = 2, Air = 3.
	// Water bonus over Fire
	// Fire bonus over Air
	// Air bonus over Earth
	// Earth bonus over Water
  	function elementBonus(uint _challengerId, uint _challengedId) returns(uint) {
  		Beast storage _challenger = beasts[_challengerId];
		Beast storage _challenged = beasts[_challengedId];
		if((_challenger.element == 0 && _challenged.element == 1) || (_challenger.element == 1 && _challenged.element == 2) 
			|| (_challenger.element == 2 && _challenged.element == 3) || (_challenger.element == 3 && _challenged.element == 0)) {
			return _challengerId
		} else ((_challenger.element == 1 && _challenged.element == 0) || (_challenger.element == 2 && _challenged.element == 1) 
			|| (_challenger.element == 3 && _challenged.element == 2) || (_challenger.element == 0 && _challenged.element == 3)) {
			return _challengedId
		} else {
			return 0
		}
  	}

  	function skillAttributeBonus(uint _beastId) returns(uint) {
  		Beast memory _beast = beasts[_beastId];
  		Skill memory skill = skills[beast.skillId];
  		if (skill.addAttributePercentaje == true) {
  			return skillValue(skill.attirbuteId, _beastId) * skill.attributeBonus;
  		} else {
  			return skillValue(skill.attirbuteId, _beastId) + skill.attributeBonus;
  		}
  	}
}

