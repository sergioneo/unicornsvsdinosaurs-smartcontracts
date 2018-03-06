pragma solidity ^0.4.18;

contract SkillsSystem {

	struct Skill {
		uint id;
		string name;
		uint attirbuteId;
		bool addAttributePercentaje;
		uint winExperienceBonus;
		uint loseExperienceBonus;
		uint elementalAdvantageBonus;
		uint elementalDisadvantageBonus;
		uint randomAttributeBonus;
		bool has5LevelBonus;
		bool preferedAttributeIncreasedChance;
		bool fertileSpeedBonus;
		bool dominantGene;
		bool recesiveGene;
	}

	mapping (uint => Challenge) public skills;

}