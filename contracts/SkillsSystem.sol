pragma solidity ^0.4.18;

contract SkillsSystem {

	struct Skill {
		uint id;
		string name;
	}

	mapping (uint => Challenge) public skills;

}