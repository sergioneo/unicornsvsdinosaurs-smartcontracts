pragma solidity ^0.4.18;

import './BeastBase.sol';
import './SkillsSystems.sol';

contract ExperienceSystems is BeastBase {

	struct ExperienceSystem {
		uint id;
		uint base;
		uint percentaje;
		bool isJustBase;
		bool isJustPercentaje;
		uint dinosaurBonus;
		uint unicornBonus;
	}

	mapping (uint => ExperienceSystem) public experienceSystems;

	function ExperienceSystems () {
		
	}	

	// Create a new experience ExperienceSystem
	// Impotant, ID must me unique.
	// Default Dinosaur and Unicorn Bonus is 1
	function createExperienceSystem(uint _id, uint _base, uint _percentaje, bool _isJustBase,
	 bool _isJustPercentaje, uint _dinosaurBonus, uint _unicornBonus)  {
	 	require(_isJustPercentaje == false || _isJustBase == false);
			ExperienceSystem memory _experienceSystems = ExperienceSystem({
			id: _id,
            base: _base,
            percentaje: _percentaje,
            isJustBase: _isJustBase,
            isJustPercentaje: _isJustPercentaje,
            dinosaurBonus: _dinosaurBonus,
            unicornBonus: _unicornBonus
        });
        experienceSystems[_id] = _experienceSystems;
	}

	// Calculate experience based on system ID and modify winner and looser experiece attribute
	function calculateExperience(uint _experienceSystemId, uint _winnerId, uint _looserId) internal {
		ExperienceSystem memory _experienceSystem = experienceSystems[_experienceSystemId];
		Beast storage winner = beasts[_winnerId];
		Beast storage looser = beasts[_looserId];

		// TODO: Here we need to assing Dinosaur or Unicorn bonus, but we need to check from ADN wich
		// one is Dinosaur and wich one is Unicorn

		uint winnerExperienceIncrement = 0;
		uint looserExperienceIncrement = 0;

		// It is not possible to have: isJustBase = true and isJustPercentaje  = true option.
		if (_experienceSystem.isJustBase) {
			winnerExperienceIncrement += uint64(_experienceSystem.base);
			looserExperienceIncrement -= uint64(_experienceSystem.base);
		} else if (_experienceSystem.isJustPercentaje) {
			winnerExperienceIncrement += uint64(looser.experience * _experienceSystem.percentaje);
			looserExperienceIncrement -= uint64(looser.experience * _experienceSystem.percentaje);
		} else {
			uint looserExperience = looser.experience;
			winnerExperienceIncrement += uint64(_experienceSystem.base);
			looserExperienceIncrement -= uint64(_experienceSystem.base);
			winnerExperienceIncrement += uint64(looserExperience * _experienceSystem.percentaje);
			looserExperienceIncrement -= uint64(looserExperience * _experienceSystem.percentaje);
		}
		// Is there a Skill Bonus to Win more exp or loss les exp?
		Skill memory winnerSkills = skills[winner.skillId];
		Skill memory looserSkills = skills[looser.skillId];
		winnerExperienceIncrement += winnerExperienceIncrement * winnerSkills.winExperienceBonus;
		looserExperienceIncrement += looserExperienceIncrement * looserSkills.loseExperienceBonus;

		winner.experience += winnerExperienceIncrement * getExperienceBonusBasedOnRarity(winner.rarity);
		looser.experience -= looserExperienceIncrement * getExperienceBonusBasedOnRarity(looser.rarity);
		if(looser.experience < experienceRequiredForLevel[looser.level - 1]) {
			looser.experience = experienceRequiredForLevel[looser.level - 1];
		}
	}

	function getExperienceBonusBasedOnRarity(Rarity _rarity) returns uint internal {
		if(_rarity == Rarity.Common) {
			return 1
		} else if(_rarity == Rarity.Rare) {
			return 1.05
		} else if(_rarity == Rarity.Epic) {
			return 1.15
		} else if(_rarity == Rarity.Legendary) {
			return 1.3
		}
	}

	function calculateLevel(uint _experience, uint _currentLevel) returns uint internal {
		if(_experience >= experienceRequiredForLevel[_currentLevel - 1]) {
			return _currentLevel + 1;
		} else {
			if(_currentLevel == 1) {
				return 1;
			} else if(_experience <= experienceRequiredForLevel[_currentLevel - 2]) {
				return _currentLevel - 1;
			} else {
				return _currentLevel;
			}
		}
	}
	
}
