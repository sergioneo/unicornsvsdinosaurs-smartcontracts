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
	
}
