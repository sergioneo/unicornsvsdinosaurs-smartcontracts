pragma solidity ^0.4.18;

import './BeastBase.sol';

contract RankingSystems {

	struct RankingSystem {
		uint id;
		uint[10] top10Ids = [0,0,0,0,0,0,0,0,0,0]
		uint top10MinWins;
		uint[10] top10DinosaursIds = [0,0,0,0,0,0,0,0,0,0]
		uint top10DinosaurMinWins;
		uint[10] top10UnicornsIds = [0,0,0,0,0,0,0,0,0,0]
		uint top10UnicornMinWins;
	}

	mapping (uint => RankingSystem) public rankingSystems;

	function RankingSystems () {
		
	}

	function handleTop10(uint _rankId, uint _beastId, uint _wins) internal {
		RankingSystem memory _rankSystem= rankingSystems[_rankId];
		
		require(_rankSystem.top10MinWins < top10MinWins || _rankSystem.top10MinWins < top10DinosaurMinWins || 
			_rankSystem.top10MinWins < top10UnicornMinWins);
		// TODO: Check if dino or UNI and add to correspondig ranking.
		if(_wins > _rankSystem.top10MinWins) {
			addToTop10Global(_rankId, _beastId, _wins);
		}
	}

	function addToTop10Global(uint _rankId, uint _beastId, uint _wins) internal {
		RankingSystem memory _rankSystem= rankingSystems[_rankId];
		// TODO: Handle adding to top 10 global.
		// for(uint i = 0; i < 10; i++) {
		// 	if (_wins > _rankSystem.top10Ids[i]) {

		// 	}
  //      	}
	}
}
