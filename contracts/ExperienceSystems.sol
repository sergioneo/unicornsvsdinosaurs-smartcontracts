pragma solidity ^0.4.18;

import './BeastBase.sol';

contract ExperienceSystems {

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

	function createExperienceSystem(uint _id, uint _base, uint _percentaje, bool _isJustBase,
	 bool _isJustPercentaje, uint _dinosaurBonus, uint _unicornBonus)  {
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

	function calculateExperience(uint _experienceSystemId, uint _winnerId, uint _looserId) internal {
		ExperienceSystem memory _experienceSystem = experienceSystems[_experienceSystemId];
		Beast storage winner = beasts[_winnerId];
		Beast storage looser = beasts[_looserId];
		if (_experienceSystem.isJustBase) {
			winner.experience += _experienceSystem.base;
			looser.experience -= _experienceSystem.base;
		} else if (_experienceSystem.isJustPercentaje) {
			winner.experience += looser.experience * _experienceSystem.percentaje;
			looser.experience -= looser.experience * _experienceSystem.percentaje;
		} else {
			uint looserExperience = looser.experience;
			winner.experience += _experienceSystem.base;
			looser.experience -= _experienceSystem.base;
			winner.experience += looserExperience * _experienceSystem.percentaje;
			looser.experience -= looserExperience * _experienceSystem.percentaje;
		}
	}
	
}
