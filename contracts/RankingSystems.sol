pragma solidity ^0.4.18;

import './BeastBase.sol';

contract RankingSystems {

	struct RankingSystem {
		uint id;
	}

	mapping (uint => RankingSystem) public rankingSystems;

	function RankingSystems () {
		
	}
}
