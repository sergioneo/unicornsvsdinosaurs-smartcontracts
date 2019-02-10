pragma solidity ^0.4.24;

import "./util/AccessControl.sol";

contract SkillsSystem is AccessControl {

    struct Skill {
        uint id;
        string name;
        uint attirbuteId;
        bool addAttributePercentaje;
        uint attributeBonus;
        uint winExperienceBonus;
        uint loseExperienceBonus;
        uint elementalAdvantageBonus;
        uint elementalDisadvantageBonus;
        uint randomAttributeBonus;
        bool has5LevelBonus;
        bool preferedAttributeIncreasedChance;
        bool fertileSpeedBonus;
        bool isSkill;
    }

    mapping (uint => Skill) public skills;

    function skillExists( uint skillId) internal view returns(bool) {
        return skills[skillId].isSkill;
    }
/*
    // Create a new skill, important to have Unique ID
    function createSkill(
        uint _id, 
        string _name, 
        uint _attirbuteId, 
        bool _addAttributePercentaje, 
        uint _attributeBonus, 
        uint _winExperienceBonus, 
        uint _loseExperienceBonus, 
        uint _elementalAdvantageBonus, 
        uint _elementalDisadvantageBonus, 
        uint _randomAttributeBonus, 
        bool _has5LevelBonus, 
        bool _preferedAttributeIncreasedChance, 
        bool _fertileSpeedBonus, 
        bool _dominantGene, 
        bool _recesiveGene
    ) public onlyCOO {
        require(!skillExists(_id)); // prevents destruction of existing skill with same ID
        Skill memory _skill = Skill({
            id: _id,
            name: _name,
            attirbuteId: _attirbuteId,
            addAttributePercentaje: _addAttributePercentaje,
            attributeBonus: _attributeBonus,
            winExperienceBonus: _winExperienceBonus,
            loseExperienceBonus: _loseExperienceBonus,
            elementalAdvantageBonus: _elementalAdvantageBonus,
            elementalDisadvantageBonus: _elementalDisadvantageBonus,
            randomAttributeBonus: _randomAttributeBonus,
            has5LevelBonus: _has5LevelBonus,
            preferedAttributeIncreasedChance: _preferedAttributeIncreasedChance,
            fertileSpeedBonus: _fertileSpeedBonus,
            dominantGene: _dominantGene,
            recesiveGene: _recesiveGene,
            isSkill: true
        });

        skills[_id] = _skill;
    }

    // Edit a  skill, important to have Unique ID
    function editSkill(
        uint _id, 
        string _name, 
        uint _attirbuteId, 
        bool _addAttributePercentaje, 
        uint _attributeBonus, 
        uint _winExperienceBonus, 
        uint _loseExperienceBonus, 
        uint _elementalAdvantageBonus, 
        uint _elementalDisadvantageBonus, 
        uint _randomAttributeBonus, 
        bool _has5LevelBonus, 
        bool _preferedAttributeIncreasedChance, 
        bool _fertileSpeedBonus, 
        bool _dominantGene, 
        bool _recesiveGene
    ) external onlyCOO {

        Skill storage _skill = skills[_id];
        _skill.name = _name;
        _skill.attirbuteId = _attirbuteId;
        _skill.addAttributePercentaje = _addAttributePercentaje;
        _skill.attributeBonus = _attributeBonus;
        _skill.winExperienceBonus = _winExperienceBonus;
        _skill.loseExperienceBonus = _loseExperienceBonus;
        _skill.elementalAdvantageBonus = _elementalAdvantageBonus;
        _skill.elementalDisadvantageBonus = _elementalDisadvantageBonus;
        _skill.randomAttributeBonus = _randomAttributeBonus;
        _skill.has5LevelBonus = _has5LevelBonus;
        _skill.preferedAttributeIncreasedChance = _preferedAttributeIncreasedChance;
        _skill.fertileSpeedBonus = _fertileSpeedBonus;
        _skill.dominantGene = _dominantGene;
        _skill.recesiveGene = _recesiveGene;
    }
*/
}