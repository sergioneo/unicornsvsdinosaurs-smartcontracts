pragma solidity ^0.4.18;

import "./BeastBase.sol";

contract RankingSystems is BeastBase {

    uint256 private constant TOP_RANK_PER_GAME = 10;

    struct RankingStruct {
        mapping (bytes32 => uint256) rankingCount; // beastId => winnings
        uint256[4] rankingList; // beastIds
        uint256 minToRank;
        uint256 mappingVersion;
        bool isRanking;
    } 

    // @dev: uint256 is the ID of the game
    mapping (uint256 => RankingStruct) public rankings;
    uint256[] rankingsIndexes;
    
    function getRankingIndexes() public view returns(bytes32[]) {
        
        bytes32[] memory returnList;
        for (uint i = 0; i < rankingsIndexes.length; i++) {
            bytes32 listMember = bytes32( rankingsIndexes[i] );
            returnList[i] = listMember;
        }
        
        return returnList;
    }
    
    mapping (uint8 => uint256) public globalRank; // races rank, index will be the bits, as int, of the race
    uint8[] globalRankIndexes;
    
    // @dev onlyCEO
    function resetRankings() public {
        // reset global ranking
        for ( uint i = 0; i<globalRankIndexes.length; i++ ) {
            delete globalRank[globalRankIndexes[i]];
        }
        
        // reset winnings counts
        for ( uint j = 0; j<rankingsIndexes.length; j++ ) {
            rankings[rankingsIndexes[j]].mappingVersion++;
            delete rankings[rankingsIndexes[j]].rankingList;
            delete rankings[rankingsIndexes[j]].minToRank;
        }
    } 

    function rankingExists( uint256 rankingId) internal view returns(bool) {
        return rankings[rankingId].isRanking;
    }

    // TODO: refactor
    // @dev: keep eye on GAS !!
    function registerWinner( uint256 gameId, uint256 beastId ) public {
        
        if (!rankingExists(gameId)) { // create the ranking
            rankings[gameId].isRanking = true;
            rankingsIndexes.push(gameId);
        }

        bytes32 beastIdRef = keccak256(rankings[gameId].mappingVersion, beastId);
        rankings[gameId].rankingCount[beastIdRef] += 1; // add a winning to the beast
        
        // TODO: get race to add to global rank

        _sort(gameId); // sort array based on amount of winnigs

        if (rankings[gameId].rankingList.length < TOP_RANK_PER_GAME) { // easy add
            if ( !_findInFixedArray(rankings[gameId].rankingList, beastId ) ) {
                rankings[gameId].rankingList[ rankings[gameId].rankingList.length ] = beastId;
            }
            
            if ( rankings[gameId].rankingList.length == 1 || rankings[gameId].rankingCount[beastIdRef] < rankings[gameId].minToRank ) {
                rankings[gameId].minToRank = rankings[gameId].rankingCount[beastIdRef];
            }

        } else { // dificult add
            if ( _findInFixedArray(rankings[gameId].rankingList, beastId ) ) {
                if ( rankings[gameId].rankingList.length == 1 || rankings[gameId].rankingCount[beastIdRef] < rankings[gameId].minToRank ) {
                    rankings[gameId].minToRank = rankings[gameId].rankingCount[beastIdRef];
                }
            } else { // we need remove a value from the list
                // if greater than minimum rank then add to list
                if( rankings[gameId].rankingCount[beastIdRef] > rankings[gameId].minToRank ) {
                    // add to list, sort and remove the last
                    //rankings[gameId].rankingList[ rankings[gameId].rankingList.length - 1 ] = beastId;
                    rankings[gameId].rankingList[ 0 ] = beastId;
                    rankings[gameId].minToRank = rankings[gameId].rankingCount[beastIdRef];
                }
                
            }
        }
    }

    // @dev: web must convert to ascii the byte32 array
    //       the array is returned in increase order (from less winnings to most winnings)
    function getRanking( uint256 gameId ) public view returns(bytes32[TOP_RANK_PER_GAME]) {
        
        bytes32[TOP_RANK_PER_GAME] memory beastList;
        uint256[TOP_RANK_PER_GAME] memory rankingList = rankings[gameId].rankingList;

        for (uint i = 0; i < rankingList.length; i++) {
            bytes32 rankingMember = bytes32(rankingList[i]);
            beastList[i] = rankingMember;
        }
        
        return beastList;
    }

    // @dev: confirm if item exist in array of fixed length
    function _findInFixedArray( uint256[TOP_RANK_PER_GAME] arrayOfValues, uint256 valueToFind ) private pure returns(bool) {
        for (uint i = 0; i < arrayOfValues.length; i++) {
            if (arrayOfValues[i] == valueToFind) {
                return true;
            }
        }
        return false;
    }
    
    // @dev ref from    https://github.com/alianse777/solidity-standard-library/blob/master/Array.sol
    // rankings[gameId].rankingCount[beastId]
    function _sort_item(uint256 gameId, uint pos) private returns (bool) {
            
        uint w_min = pos;
        for(uint i = pos;i < rankings[gameId].rankingList.length;i++) {
            bytes32 beastIdRef = keccak256(rankings[gameId].mappingVersion, rankings[gameId].rankingList[i]);
            bytes32 beastIdRefMin = keccak256(rankings[gameId].mappingVersion, rankings[gameId].rankingList[w_min]);
            
            if( rankings[gameId].rankingCount[beastIdRef] < rankings[gameId].rankingCount[beastIdRefMin]) {
                w_min = i;
            }
        }
        if(w_min == pos) return false;
        uint tmp = rankings[gameId].rankingList[pos];
        rankings[gameId].rankingList[pos] = rankings[gameId].rankingList[w_min];
        rankings[gameId].rankingList[w_min] = tmp;
        return true;
    }
        
    /**
        * @dev Sort the array
        */
    function _sort( uint256 gameId ) public {
        for( uint i = 0; i < rankings[gameId].rankingList.length-1; i++ ) {
            _sort_item(gameId, i);
        }
    }
}