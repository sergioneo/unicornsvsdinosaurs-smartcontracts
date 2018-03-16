pragma solidity ^0.4.18;

import './BeastBase.sol';

contract RankingSystems is BeastBase {

  uint256 private constant TOP_RANK_PER_GAME = 10;

  struct RankingStruct {
    mapping (uint256 => uint256) rankingCount; // beastId => winnings
    uint256[TOP_RANK_PER_GAME] rankingList; // beastIds
    uint256 minToRank;
    bool isRanking;
  } 

  // @dev: uint256 is the ID of the game
  mapping (uint256 => RankingStruct) public rankings;
  mapping (uint8 => uint256) public globalRank; // races rank, index will be the bits, as int, of the race

  function rankingExists( uint256 rankingId) internal view returns(bool) {
    return rankings[rankingId].isRanking;
  }

  // TODO: refactor
  // @dev: keep eye on GAS !!
  function registerWinner( uint256 gameId, uint256 beastId ) public {
    
    if (!rankingExists(gameId)) { // create the ranking
      rankings[gameId].isRanking = true;
    }

    rankings[gameId].rankingCount[beastId] += 1; // add a winning to the beast
    // TODO: get race to add to global rank

    _sort(gameId); // sort array based on amount of winnigs

    if (rankings[gameId].rankingList.length < TOP_RANK_PER_GAME) { // easy add
      if ( !_findInArray(rankings[gameId].rankingList, beastId) ) {
        rankings[gameId].rankingList[rankings[gameId].rankingList.length] = beastId;
      }
      
      if ( rankings[gameId].rankingList.length == 1 || rankings[gameId].rankingCount[beastId] < rankings[gameId].minToRank ) {
        rankings[gameId].minToRank = rankings[gameId].rankingCount[beastId];
      }

    } else { // dificult add
      if ( _findInArray(rankings[gameId].rankingList, beastId) ) {
        if ( rankings[gameId].rankingList.length == 1 || rankings[gameId].rankingCount[beastId] < rankings[gameId].minToRank ) {
          rankings[gameId].minToRank = rankings[gameId].rankingCount[beastId];
        }
      } else {
        // if greater than minimum rank then add to list
        if ( rankings[gameId].rankingCount[beastId] > rankings[gameId].minToRank ) {
            // add to list, sort and remove the last
            //rankings[gameId].rankingList[ rankings[gameId].rankingList.length - 1 ] = beastId;
            rankings[gameId].rankingList[0] = beastId;
            rankings[gameId].minToRank = rankings[gameId].rankingCount[beastId];
        }
        
      }
    }
  }

  // @dev: web must convert to ascii the byte32 array
  function getRanking( uint256 gameId ) public view returns(bytes32[TOP_RANK_PER_GAME]) {
    
    bytes32[TOP_RANK_PER_GAME] memory beastList;
    uint256[TOP_RANK_PER_GAME] memory rankingList = rankings[gameId].rankingList;

    for (uint i = 0; i < rankingList.length; i++) {
        bytes32 rankingMember = bytes32(rankingList[i]);
        beastList[i] = rankingMember;
    }
    
    return beastList;
  }

  function _findInArray( uint256[TOP_RANK_PER_GAME] arrayOfValues, uint256 valueToFind ) private pure returns(bool) {
    for (uint i = 0; i < arrayOfValues.length; i++) {
      if (arrayOfValues[i] == valueToFind) {
        return true;
      }
    }
    return false;
  }
  
    // @dev ref from  https://github.com/alianse777/solidity-standard-library/blob/master/Array.sol
    // must be here because the array ref
    function _sortItem(uint256 gameId, uint pos) private returns (bool) {
        uint w_min = pos;
        for(uint i = pos;i < rankings[gameId].rankingList.length;i++) {
            if( rankings[gameId].rankingCount[rankings[gameId].rankingList[i]] < rankings[gameId].rankingCount[rankings[gameId].rankingList[w_min]]) {
                w_min = i;
            }
        }
        if(w_min == pos) {
          return false;
        }
        uint tmp = rankings[gameId].rankingList[pos];
        rankings[gameId].rankingList[pos] = rankings[gameId].rankingList[w_min];
        rankings[gameId].rankingList[w_min] = tmp;
        return true;
    }
    
    /**
     * @dev Sort the array
     */
    function _sort( uint256 gameId ) private {
        for( uint i = 0; i < rankings[gameId].rankingList.length-1; i++ ) {
            _sortItem(gameId, i);
        }
    }
}
