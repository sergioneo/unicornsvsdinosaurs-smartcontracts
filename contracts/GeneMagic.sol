pragma solidity ^0.4.18;
contract GeneMagic {
    
    uint8 constant BEAST_TYPE_LENGTH = 2;
    uint8 constant GENE_BASE_LENGTH = 254;
    
    bool public isGeneMagic = true;

    struct attributeDefinition {
        string name;
        uint8 size;
        uint[] probabilities;
    }
    
    attributeDefinition[] private dinosaurs_attribute_list;
    attributeDefinition[] private unicorns_attribute_list;
    
    function randomNumber(uint a, uint b) public constant returns (int) {
        return int(uint((block.timestamp - a)%b));
    }
    
    function getBits(uint256 src, uint start, uint length) public pure returns (uint256){
        uint256 shifted = src / 2**start;
        return shifted & uint256(2 ** length - 1);
    }
    
    function getLastBits(uint256 src, uint n) public pure returns (uint256) {
        return src / 2 ** n;
    }
    
    function getBeastType(uint256 genes) public pure returns (uint8) {
        return uint8(getBits(genes, 0, BEAST_TYPE_LENGTH));
    }
    
    function getGeneBase(uint256 genes) public pure returns (uint256) {
        return getLastBits(genes, BEAST_TYPE_LENGTH);
    }
    
    function mixGene(uint16 geneMother, uint16 geneFather, uint[] attributeProbabilities) private view returns (uint16) {
        uint[] memory actualProbabilities = attributeProbabilities;
        uint arraySum = 0;
        for (uint i = 0; i < attributeProbabilities.length; i++) {
            if (geneMother == i || geneFather == i) {
                actualProbabilities[i] = 2*attributeProbabilities[i];
            } else {
                actualProbabilities[i] = attributeProbabilities[i];
            }
            arraySum += actualProbabilities[i];
        }
        int256 dice = randomNumber(1, arraySum);
        for (uint j = 0; j < actualProbabilities.length; j++) {
            dice -= int256(actualProbabilities[j]);
            if (dice <= 0) {
                return uint16(j);
            }
        }
        return uint16(actualProbabilities.length - 1);
    }
    
    function mixGenes(uint256 genesMother, uint256 genesFather) public constant returns(uint256) {
        uint8 beastTypeMother = getBeastType(genesMother);
        if (beastTypeMother != getBeastType(genesFather)) {
            revert();
        }
        attributeDefinition[] memory attributeList;
        if (beastTypeMother == uint8(0)) {
            attributeList = dinosaurs_attribute_list;
        } else if (beastTypeMother == uint8(0)) {
            attributeList = unicorns_attribute_list;
        }
        uint256 childGeneBase = 0;
        uint256 fatherGeneBase = getGeneBase(genesFather);
        uint256 motherGeneBase = getGeneBase(genesMother);
        uint startingPosition = 0;
        for (uint i = 0; i < attributeList.length; i++) {
            attributeDefinition memory attr = attributeList[i];
            uint16 geneSegmentMother = uint16(getBits(motherGeneBase, startingPosition, attr.size));
            uint16 geneSegmentFather = uint16(getBits(fatherGeneBase, startingPosition, attr.size));
            uint16 newGenes = mixGene(geneSegmentMother, geneSegmentFather, attr.probabilities);
            childGeneBase = childGeneBase + newGenes * 2 ** (startingPosition);
            startingPosition += attr.size;
        }
        childGeneBase = childGeneBase * 2 ** 2 + beastTypeMother;
        return childGeneBase;
    }
    
    function addAttribute(uint8 target, string name, uint8 size) public {
        attributeDefinition memory attr = attributeDefinition({
            name: name,
            size: size,
            probabilities: new uint[](0)
        });
        if (target == uint8(0)) {
            dinosaurs_attribute_list.push(attr);
        } else if (target == uint8(1)) {
            unicorns_attribute_list.push(attr);
        } else {
            revert();
        }
    }
    
    function initDinosaurs() public {
        addAttribute(0, "pedigree", 2);
        dinosaurs_attribute_list[0].probabilities.push(849);
        dinosaurs_attribute_list[0].probabilities.push(100);
        dinosaurs_attribute_list[0].probabilities.push(50);
        dinosaurs_attribute_list[0].probabilities.push(1);
        addAttribute(0, "type", 4);
        dinosaurs_attribute_list[1].probabilities.push(99);
        dinosaurs_attribute_list[1].probabilities.push(1);
        dinosaurs_attribute_list[1].probabilities.push(2);
        dinosaurs_attribute_list[1].probabilities.push(3);
        dinosaurs_attribute_list[1].probabilities.push(8);
        addAttribute(0, "eyes", 8);
        dinosaurs_attribute_list[2].probabilities.push(1000);
        dinosaurs_attribute_list[2].probabilities.push(1);
        dinosaurs_attribute_list[2].probabilities.push(233);
        addAttribute(0, "horn", 7);
        dinosaurs_attribute_list[3].probabilities.push(1);
        dinosaurs_attribute_list[3].probabilities.push(10000);
    }
    
    function initUnicorns() public {
        addAttribute(1, "pedigree", 2);
        unicorns_attribute_list[0].probabilities.push(100);
        unicorns_attribute_list[0].probabilities.push(50);
        unicorns_attribute_list[0].probabilities.push(30);
        unicorns_attribute_list[0].probabilities.push(100);
    }
    
    function numberOfAttributes(uint8 target) public constant returns (uint) {
        if (target == 0) {
            return dinosaurs_attribute_list.length;
        } else if (target == 1) {
            return unicorns_attribute_list.length;
        } else {
            revert();
        }
    }
    
    function getAttributeName(uint target, uint i) public constant returns (string) {
        if (target == 0) {
            return dinosaurs_attribute_list[i].name;
        } else if (target == 1) {
            return unicorns_attribute_list[i].name;
        } else {
            revert();
        }
    }
    
    function getAttributeProbabilities(uint target, uint i) public constant returns (uint[]) {
        if (target == 0) {
            return dinosaurs_attribute_list[i].probabilities;
        } else if (target == 1) {
            return unicorns_attribute_list[i].probabilities;
        } else {
            revert();
        }
    }
    
    function getAttributeSize(uint target, uint i) public constant returns (uint) {
        if (target == 0) {
            return dinosaurs_attribute_list[i].size;
        } else if (target == 1) {
            return unicorns_attribute_list[i].size;
        } else {
            revert();
        }
    }
    
    function updateAttribute(uint target, uint i, string name, uint[] list) public {
        if (target == 0) {
            dinosaurs_attribute_list[i].name = name;
            dinosaurs_attribute_list[i].probabilities = list;
        } else if (target == 1) {
            unicorns_attribute_list[i].name = name;
            unicorns_attribute_list[i].probabilities = list;
        } else {
            revert();
        }
    }
    
}