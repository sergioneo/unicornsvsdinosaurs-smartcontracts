pragma solidity ^0.4.18;

import './BeastBase.sol';

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

		// It is not possible to have: isJustBase = true and isJustPercentaje  = true option.
		if (_experienceSystem.isJustBase) {
			winner.experience += uint64(_experienceSystem.base);
			looser.experience -= uint64(_experienceSystem.base);
		} else if (_experienceSystem.isJustPercentaje) {
			winner.experience += uint64(looser.experience * _experienceSystem.percentaje);
			looser.experience -= uint64(looser.experience * _experienceSystem.percentaje);
		} else {
			uint looserExperience = looser.experience;
			winner.experience += uint64(_experienceSystem.base);
			looser.experience -= uint64(_experienceSystem.base);
			winner.experience += uint64(looserExperience * _experienceSystem.percentaje);
			looser.experience -= uint64(looserExperience * _experienceSystem.percentaje);
		}
	}

	function calculateNewLevel(uint _experience, uint _currentLevel) returns uint internal {
		if(_experience >= experienceRequiredForLevel[_currentLevel - 1) {
			return _currentLevel + 1;
		} else {
			if(_currentLevel == 1) {
				return 1;
			} else if(_experience <= experienceRequiredForLevel[_currentLevel - 2) {
				return _currentLevel - 1;
			} else {
				return _currentLevel;
			}
		}
	}
	
}
