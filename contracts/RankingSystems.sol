pragma solidity ^0.4.18;

import './BeastBase.sol';

contract RankingSystems is BeastBase {

  uint private constant TOP_RANK_PER_GAME = 10;

  struct RankingStruct {
    mapping (uint256 => uint256) rankingCount; 
    uint256[] rankingList;
    uint256 minToRank;
    bool isRanking;
  } 

  // @dev: uint256 is the ID of the game
  mapping (uint256 => RankingStruct) public rankings;
  mapping (uint8 => uint256) public globalRank; // races rank, index will be the bits, as int, of the race

  function rankingExists( uint256 rankingId) internal returns(bool) {
    return rankings[rankingId].isRanking;
  }

  // reset all ranks
  function resetLeaderboards() public onlyCEO {
    // TODO: reset all storages
	// @dev: delete of mapping will be the hardest thing to do
  }  

  // TODO: refactor
  // @dev: keep eye on GAS !!
  function registerWinner( uint256 gameId, uint256 beastId ) internal {

    if (!rankingExists(gameId)) { // create the ranking
      rankings[gameId].isRanking = true;
    }

    rankings[gameId].rankingCount[beastId] += 1; // add a winning to the beast
    // TODO: get race to add to global rank

    if (rankings[gameId].rankingList.length < TOP_RANK_PER_GAME) { // easy add
      if ( !_findInArray(rankings[gameId].rankingList, beastId) ) {
        rankings[gameId].rankingList.push(beastId);
      }
      
      if ( rankings[gameId].rankingList.length == 1 || rankings[gameId].rankingCount[beastId] < rankings[gameId].minToRank ) {
        rankings[gameId].minToRank = rankings[gameId].rankingCount[beastId];
      }

    } else { // hard add
      if ( _findInArray(rankings[gameId].rankingList, beastId) ) {
        if ( rankings[gameId].rankingList.length == 1 || rankings[gameId].rankingCount[beastId] < rankings[gameId].minToRank ) {
          rankings[gameId].minToRank = rankings[gameId].rankingCount[beastId];
        }
      } else { // we need remove a value from the list

      }
    }
  }

  // @dev: web must convert to ascii the byte32 array
  function getRanking( uint256 gameId ) public view returns(bytes32[] beastList) {
    
    uint256[] rankingList = rankings[gameId].rankingList;
    mapping (uint256 => uint256) rankingCount = rankings[gameId].rankingCount;

    for (uint i = 0; i < rankingList.length; i++) {

    }

  }

  function _findInArray( uint256[] arrayOfValues, uint256 valueToFind ) private returns(bool) {
    for (uint i = 0; i < arrayOfValues.length; i++) {
      if (arrayOfValues[i] == valueToFind) {
        return true;
      }
    }
    return false;
  }
}
