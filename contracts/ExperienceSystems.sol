pragma solidity ^0.4.18;

import './BeastBase.sol';

contract ExperienceSystems {

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
		// TODO: This should be an Exp System
		uint expMultiplicator;
	}

	function ExperienceSystems () {
		
	}	
}
