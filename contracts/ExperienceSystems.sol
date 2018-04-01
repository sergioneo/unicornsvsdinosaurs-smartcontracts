pragma solidity ^0.4.18;

import './BeastAttributes.sol';
import './SkillsSystem.sol';
import './util/Random.sol';

contract ExperienceSystems is Random, BeastAttributes, SkillsSystem{

    struct ExperienceSystem {
        uint id;
        uint base;
        uint percentaje;
        bool isJustBase;
        bool isJustPercentaje;
        uint dinosaurBonus;
        uint unicornBonus;
        bool isExperience;
    }

    mapping (uint => ExperienceSystem) public experienceSystems;  

    function experienceExists( uint experienceId) internal view returns(bool) {
        return experienceSystems[experienceId].isExperience;
    }

    // Create a new experience ExperienceSystem
    // Impotant, ID must me unique.
    // Default Dinosaur and Unicorn Bonus is 1
    function createExperienceSystem(uint _id, uint _base, uint _percentaje, bool _isJustBase, bool _isJustPercentaje, uint _dinosaurBonus, uint _unicornBonus) internal onlyCOO {
        require(!experienceExists(_id)); // prevents destruction of existing experience with same ID
        require(_isJustPercentaje == false || _isJustBase == false);
        ExperienceSystem memory _experienceSystems = ExperienceSystem({
            id: _id,
            base: _base,
            percentaje: _percentaje,
            isJustBase: _isJustBase,
            isJustPercentaje: _isJustPercentaje,
            dinosaurBonus: _dinosaurBonus,
            unicornBonus: _unicornBonus,
            isExperience: true
        });
        experienceSystems[_id] = _experienceSystems;
    }

    // Calculate experience based on system ID and modify winner and looser experiece attribute
    function calculateExperience(uint _experienceSystemId, uint256 _winnerId, uint256 _looserId) internal {
        ExperienceSystem memory _experienceSystem = experienceSystems[_experienceSystemId];
        Beast storage winner =     [_winnerId];
        Beast storage looser =     [_looserId];

        // TODO: Here we need to assing Dinosaur or Unicorn bonus, but we need to check from ADN wich
        // one is Dinosaur and wich one is Unicorn

        uint winnerExperienceIncrement = 0;
        uint looserExperienceIncrement = 0;

        // It is not possible to have: isJustBase = true and isJustPercentaje  = true option.
        if (_experienceSystem.isJustBase) {
            winnerExperienceIncrement += uint64(_experienceSystem.base);
            looserExperienceIncrement -= uint64(_experienceSystem.base);
        } else if (_experienceSystem.isJustPercentaje) {
            winnerExperienceIncrement += uint64(looser.experience * _experienceSystem.percentaje);
            looserExperienceIncrement -= uint64(looser.experience * _experienceSystem.percentaje);
        } else {
            uint looserExperience = looser.experience;
            winnerExperienceIncrement += uint64(_experienceSystem.base);
            looserExperienceIncrement -= uint64(_experienceSystem.base);
            winnerExperienceIncrement += uint64(looserExperience * _experienceSystem.percentaje);
            looserExperienceIncrement -= uint64(looserExperience * _experienceSystem.percentaje);
        }
        // Is there a Skill Bonus to Win more exp or loss less exp?
        Skill memory winnerSkills = skills[winner.skillId];
        Skill memory looserSkills = skills[looser.skillId];
        winnerExperienceIncrement += winnerExperienceIncrement * winnerSkills.winExperienceBonus;
        looserExperienceIncrement += looserExperienceIncrement * looserSkills.loseExperienceBonus;

        winner.experience += uint64((winnerExperienceIncrement * getExperienceBonusBasedOnRarity(winner.pedigree))/100);
        looser.experience -= uint64((looserExperienceIncrement * getExperienceBonusBasedOnRarity(looser.pedigree))/100);
        if (looser.experience < experienceRequiredForLevel[looser.level - 1]) {
            looser.experience = uint64(experienceRequiredForLevel[looser.level - 1]);
        }

        _addToSuggestionList(looser.experience, _looserId);
        _addToSuggestionList(winner.experience, _winnerId);
    }

    function getExperienceBonusBasedOnRarity(Pedigree _pedigree) internal returns(uint) {
        if (_pedigree == Pedigree.Common) {
            return 100;
        } else if(_pedigree == Pedigree.Rare) {
            return 105;
        } else if(_pedigree == Pedigree.Epic) {
            return 115;
        } else if(_pedigree == Pedigree.Legendary) {
            return 130;
        } else {
            return 100;
        }
    }

    function calculateLevel(uint _experience, uint _currentLevel) internal returns(uint) {
        if(_experience >= experienceRequiredForLevel[_currentLevel - 1]) {
            return _currentLevel + 1;
        } else {
            if(_currentLevel == 1) {
                return 1;
            } else if(_experience <= experienceRequiredForLevel[_currentLevel - 2]) {
                return _currentLevel - 1;
            } else {
                return _currentLevel;
            }
        }
    }

    /**
     * Listed by suggerences
     */
    uint constant DIVIDER = 10;
    mapping( uint => uint256[] ) private suggestionsList;
    mapping( uint256 => uint ) private beastRange;

    uint[] private activeRanges;
    uint private maxRange;

    function getRandomSuggestionBattles(uint256 _beastId) public view returns (bytes32[6]) {

        bytes32[6] memory suggestionList;
        uint currentRange = beastRange[_beastId];
        uint lowerRange = currentRange - 1 <= 0 ? 0 : currentRange - 1;
        uint upperRange = currentRange + 1 >= maxRange ? maxRange : currentRange + 1;

        uint256 lenLowerRange = suggestionsList[lowerRange].length - 1;
        uint256 lenUpperRange = suggestionsList[upperRange].length - 1;

        suggestionList[0] = bytes32(suggestionsList[lowerRange][random(lenLowerRange)]);
        suggestionList[1] = bytes32(suggestionsList[lowerRange][random(lenLowerRange)]);
        suggestionList[2] = bytes32(suggestionsList[lowerRange][random(lenLowerRange)]);
        suggestionList[3] = bytes32(suggestionsList[lowerRange][random(lenUpperRange)]);
        suggestionList[4] = bytes32(suggestionsList[lowerRange][random(lenUpperRange)]);
        suggestionList[5] = bytes32(suggestionsList[lowerRange][random(lenUpperRange)]);

        return suggestionList;
    }
    
    function _addToSuggestionList(uint64 _beastExp, uint _beastId) internal {
        uint range = uint(_beastExp/DIVIDER);
        _addToActiveRanges(range);
        
        _deleteFromSuggestionsList(beastRange[_beastId], _beastId);
        suggestionsList[range].push(_beastId);
        beastRange[_beastId] = range;
    }

    function _deleteFromSuggestionsList(uint range, uint256 _beastId) internal {
        delete suggestionsList[range][_beastId];
        suggestionsList[range][_beastId] = suggestionsList[range][suggestionsList[range].length-1];
        suggestionsList[range].length--;
    }

    function _addToActiveRanges(uint range) internal {
        if(!_valueExistsInArray(activeRanges, range)){
            activeRanges.push(range);
        }
        maxRange = _maxValueInArray(activeRanges);
    }

    function _maxValueInArray(uint[] arrayToSearch) private returns (uint) {
        uint max = 0;
        for( uint i = 0; i < arrayToSearch.length; i++ ){
            if( arrayToSearch[i] > max ){
                max = arrayToSearch[i];
            }
        }
        return max;
    } 

    function _valueExistsInArray(uint[] arrayToSearch, uint valueToSearch) private returns (bool) {
        for( uint i = 0; i < arrayToSearch.length; i++ ){
            if( arrayToSearch[i] == valueToSearch ){
                return true;
            }
        }
        return false;
    }
}
