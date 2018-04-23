pragma solidity ^0.4.18;
contract GeneMagic {
    
    uint8 constant BEAST_TYPE_LENGTH = 2;
    uint8 constant GENE_BASE_LENGTH = 254;
    uint8 constant GENE_SIZE = 5;
    uint8 constant RECESSIVE_GENE_ABILITY = 12;
    uint8 constant DOMINANT_GENE_ABILITY = 23;

    // PROBABILITIES FOR ABILITIES
    uint256[32] abilities = [uint256(1), 1, 2, 1, 4, 3, 5, 3, 1, 2, 1, 4, 3, 5, 3, 1, 2, 1, 4, 3, 5, 3, 1, 2, 1, 4, 3, 5, 3, 2, 1, 9];
        
    // PROBABILITIES FOR ELEMENTS
    uint256[32] elements = [uint256(1), 1, 2, 1, 4, 3, 5, 3, 1, 2, 1, 4, 3, 5, 3, 1, 2, 1, 4, 3, 5, 3, 1, 2, 1, 4, 3, 5, 3, 2, 1, 9];
        
    // PROBABILITIES FOR UNICORNS
    uint256[32] u_type = [uint256(1), 1, 2, 1, 4, 3, 5, 3, 1, 2, 1, 4, 3, 5, 3, 1, 2, 1, 4, 3, 5, 3, 1, 2, 1, 4, 3, 5, 3, 2, 1, 9];
    uint256[32] u_eyes = [uint256(1), 1, 2, 1, 4, 3, 5, 3, 1, 2, 1, 4, 3, 5, 3, 1, 2, 1, 4, 3, 5, 3, 1, 2, 1, 4, 3, 5, 3, 2, 1, 9];
    uint256[32] u_horn = [uint256(1), 1, 2, 1, 4, 3, 5, 3, 1, 2, 1, 4, 3, 5, 3, 1, 2, 1, 4, 3, 5, 3, 1, 2, 1, 4, 3, 5, 3, 2, 1, 9];
    uint256[32] u_hair = [uint256(1), 1, 2, 1, 4, 3, 5, 3, 1, 2, 1, 4, 3, 5, 3, 1, 2, 1, 4, 3, 5, 3, 1, 2, 1, 4, 3, 5, 3, 2, 1, 9];
    uint256[32] u_tail = [uint256(1), 1, 2, 1, 4, 3, 5, 3, 1, 2, 1, 4, 3, 5, 3, 1, 2, 1, 4, 3, 5, 3, 1, 2, 1, 4, 3, 5, 3, 2, 1, 9];
    uint256[32] u_snout = [uint256(1), 1, 2, 1, 4, 3, 5, 3, 1, 2, 1, 4, 3, 5, 3, 1, 2, 1, 4, 3, 5, 3, 1, 2, 1, 4, 3, 5, 3, 2, 1, 9];
    uint256[32] u_legs = [uint256(1), 1, 2, 1, 4, 3, 5, 3, 1, 2, 1, 4, 3, 5, 3, 1, 2, 1, 4, 3, 5, 3, 1, 2, 1, 4, 3, 5, 3, 2, 1, 9];

    // PROBABILITIES FOR DINOSAURS
    uint256[32] d_type = [uint256(1), 1, 2, 1, 4, 3, 5, 3, 1, 2, 1, 4, 3, 5, 3, 1, 2, 1, 4, 3, 5, 3, 1, 2, 1, 4, 3, 5, 3, 2, 1, 9];
    uint256[32] d_eyes = [uint256(1), 1, 2, 1, 4, 3, 5, 3, 1, 2, 1, 4, 3, 5, 3, 1, 2, 1, 4, 3, 5, 3, 1, 2, 1, 4, 3, 5, 3, 2, 1, 9];
    uint256[32] d_nose = [uint256(1), 1, 2, 1, 4, 3, 5, 3, 1, 2, 1, 4, 3, 5, 3, 1, 2, 1, 4, 3, 5, 3, 1, 2, 1, 4, 3, 5, 3, 2, 1, 9];
    uint256[32] d_mouth = [uint256(1), 1, 2, 1, 4, 3, 5, 3, 1, 2, 1, 4, 3, 5, 3, 1, 2, 1, 4, 3, 5, 3, 1, 2, 1, 4, 3, 5, 3, 2, 1, 9];
    uint256[32] d_tail = [uint256(1), 1, 2, 1, 4, 3, 5, 3, 1, 2, 1, 4, 3, 5, 3, 1, 2, 1, 4, 3, 5, 3, 1, 2, 1, 4, 3, 5, 3, 2, 1, 9];
    uint256[32] d_plume = [uint256(1), 1, 2, 1, 4, 3, 5, 3, 1, 2, 1, 4, 3, 5, 3, 1, 2, 1, 4, 3, 5, 3, 1, 2, 1, 4, 3, 5, 3, 2, 1, 9];
    uint256[32] d_legs = [uint256(1), 1, 2, 1, 4, 3, 5, 3, 1, 2, 1, 4, 3, 5, 3, 1, 2, 1, 4, 3, 5, 3, 1, 2, 1, 4, 3, 5, 3, 2, 1, 9];
    uint256[32] d_spikes = [uint256(1), 1, 2, 1, 4, 3, 5, 3, 1, 2, 1, 4, 3, 5, 3, 1, 2, 1, 4, 3, 5, 3, 1, 2, 1, 4, 3, 5, 3, 2, 1, 9];
    uint256[32] d_wings = [uint256(1), 1, 2, 1, 4, 3, 5, 3, 1, 2, 1, 4, 3, 5, 3, 1, 2, 1, 4, 3, 5, 3, 1, 2, 1, 4, 3, 5, 3, 2, 1, 9];
    
    bool public isGeneMagic = true;

    struct attributeDefinition {
        string name;
        uint8 size;
        uint[] probabilities;
    }
    
    attributeDefinition[] private dinosaurs_attribute_list;
    attributeDefinition[] private unicorns_attribute_list;
    
    /**
     * Performs Gene Magic between two gene sequences.
     * @param genesMother - The gene sequence of the mother
     * @param genesFather - The gene sequence of the father
     * @param incubatorId - The id of the incubator
     * @return {uint256} The gene configuration of the child
    */
    function mixGenes(uint256 genesMother, uint256 genesFather, uint16 incubatorId) public returns (uint256) {
        uint8 beastTypeMother = getBeastType(genesMother);
        uint8 beastTypeFather = getBeastType(genesFather);
        if (beastTypeFather != beastTypeMother) {
            revert();
        }
        
        uint baseMother = remainingGenes(genesMother, BEAST_TYPE_LENGTH);
        uint baseFather = remainingGenes(genesFather, BEAST_TYPE_LENGTH);
        uint256 mixedGenes = 0;
        if (beastTypeMother == 0) {
            mixedGenes = mixGenesDinosaurs(baseMother, baseFather, incubatorId);
        } else {
            mixedGenes = mixGenesUnicorns(baseMother, baseFather, incubatorId);
        }
        
        return mixedGenes*2**(BEAST_TYPE_LENGTH) + beastTypeMother;
    }

    /**
     * Creates a brand new gene sequence
     * @param beastType - The beast type of this new beast
     * @return {uint256} The gene configuration of the new beast
    */
    function createGenes(uint8 beastType) public returns(uint256) {
        uint256 mixedGenes = 0;
        if (beastType == 0) {
            mixedGenes = createGenesDinosaur();
        } else {
            mixedGenes = createGenesUnicorn();
        }
        return mixedGenes*2**(BEAST_TYPE_LENGTH) + beastType;
    }

    /**
     * Auxiliary function - Creates a brand new gene unicorn sequence
     * @return {uint256} The gene configuration of the new unicorn
    */
    function createGenesUnicorn() private returns(uint256) {
        uint256 newGenes = 0;
        
        // Ability
        newGenes = newGenes * 2**GENE_SIZE + createGene(abilities);
        
        // Element
        newGenes = newGenes * 2**GENE_SIZE + createGene(elements);
        
        // Type
        newGenes = newGenes * 2**GENE_SIZE + createGene(u_type);
        
        // Eyes
        newGenes = newGenes * 2**GENE_SIZE + createGene(u_eyes);
        
        // Horn
        newGenes = newGenes * 2**GENE_SIZE + createGene(u_horn);
        
        // Hair
        newGenes = newGenes * 2**GENE_SIZE + createGene(u_hair);
        
        // Tail
        newGenes = newGenes * 2**GENE_SIZE + createGene(u_tail);
        
        // Snout
        newGenes = newGenes * 2**GENE_SIZE + createGene(u_snout);
        
        // Legs
        newGenes = newGenes * 2**GENE_SIZE + createGene(u_legs);
    
        return newGenes;
    }
    
    /**
     * Auxiliary function - Performs Gene Magic between two unicorn gene sequences.
     * @param genesMother - The gene sequence of the unicorn mother
     * @param genesFather - The gene sequence of the unicorn father
     * @param incubatorId - The id of the incubator
     * @return {uint256} The gene configuration of the unicorn child
    */
    function mixGenesUnicorns(uint256 genesMother, uint256 genesFather, uint16 incubatorId) private returns(uint256) {
        
        
        if (incubatorId < 4) {
            elements[incubatorId] *= 3;
        }

        uint16 abilityFather = catchNextGene(genesFather);
        uint16 abilityMother = catchNextGene(genesMother);
        uint256 newGenes = 0;
        
        // Ability
        newGenes = newGenes * 2**GENE_SIZE + mixGene(genesMother, genesFather, abilities, true, abilityMother, abilityFather);
        genesFather = remainingGenes(genesFather, GENE_SIZE);
        genesMother = remainingGenes(genesMother, GENE_SIZE);
        
        // Element
        newGenes = newGenes * 2**GENE_SIZE + mixGene(genesMother, genesFather, elements, true, abilityMother, abilityFather);
        genesFather = remainingGenes(genesFather, GENE_SIZE);
        genesMother = remainingGenes(genesMother, GENE_SIZE);
        
        // Type
        newGenes = newGenes * 2**GENE_SIZE + mixGene(genesMother, genesFather, u_type, true, abilityMother, abilityFather);
        genesFather = remainingGenes(genesFather, GENE_SIZE);
        genesMother = remainingGenes(genesMother, GENE_SIZE);
        
        // Eyes
        newGenes = newGenes * 2**GENE_SIZE + mixGene(genesMother, genesFather, u_eyes, true, abilityMother, abilityFather);
        genesFather = remainingGenes(genesFather, GENE_SIZE);
        genesMother = remainingGenes(genesMother, GENE_SIZE);
        
        // Horn
        newGenes = newGenes * 2**GENE_SIZE + mixGene(genesMother, genesFather, u_horn, true, abilityMother, abilityFather);
        genesFather = remainingGenes(genesFather, GENE_SIZE);
        genesMother = remainingGenes(genesMother, GENE_SIZE);
        
        // Hair
        newGenes = newGenes * 2**GENE_SIZE + mixGene(genesMother, genesFather, u_hair, true, abilityMother, abilityFather);
        genesFather = remainingGenes(genesFather, GENE_SIZE);
        genesMother = remainingGenes(genesMother, GENE_SIZE);
        
        // Tail
        newGenes = newGenes * 2**GENE_SIZE + mixGene(genesMother, genesFather, u_tail, true, abilityMother, abilityFather);
        genesFather = remainingGenes(genesFather, GENE_SIZE);
        genesMother = remainingGenes(genesMother, GENE_SIZE);
        
        // Snout
        newGenes = newGenes * 2**GENE_SIZE + mixGene(genesMother, genesFather, u_snout, true, abilityMother, abilityFather);
        genesFather = remainingGenes(genesFather, GENE_SIZE);
        genesMother = remainingGenes(genesMother, GENE_SIZE);
        
        // Legs
        newGenes = newGenes * 2**GENE_SIZE + mixGene(genesMother, genesFather, u_legs, true, abilityMother, abilityFather);
        genesFather = remainingGenes(genesFather, GENE_SIZE);
        genesMother = remainingGenes(genesMother, GENE_SIZE);
    
        return newGenes;
    }
    
    /**
     * Auxiliary function - Creates a brand new gene dinosaur sequence
     * @return {uint256} The gene configuration of the new dinosaur
    */
    function createGenesDinosaur() private returns(uint256) {
        uint256 newGenes = 0;
        
        // Ability
        newGenes = newGenes * 2**GENE_SIZE + createGene(abilities);
        
        // Element
        newGenes = newGenes * 2**GENE_SIZE + createGene(elements);
        
        // Type
        newGenes = newGenes * 2**GENE_SIZE + createGene(d_type);
        
        // Eyes
        newGenes = newGenes * 2**GENE_SIZE + createGene(d_eyes);
        
        // Nose
        newGenes = newGenes * 2**GENE_SIZE + createGene(d_nose);
        
        // Mouth
        newGenes = newGenes * 2**GENE_SIZE + createGene(d_mouth);
        
        // Tail
        newGenes = newGenes * 2**GENE_SIZE + createGene(d_tail);
        
        // Plume
        newGenes = newGenes * 2**GENE_SIZE + createGene(d_plume);
        
        // Legs
        newGenes = newGenes * 2**GENE_SIZE + createGene(d_legs);
        
        // Spikes
        newGenes = newGenes * 2**GENE_SIZE + createGene(d_spikes);
        
        // Wings
        newGenes = newGenes * 2**GENE_SIZE + createGene(d_wings);
    
        return newGenes;
    }
 
    /**
     * Auxiliary function - Performs Gene Magic between two dinosaur gene sequences.
     * @param genesMother - The gene sequence of the dinosaur mother
     * @param genesFather - The gene sequence of the dinosaur father
     * @param incubatorId - The id of the incubator
     * @return {uint256} The gene configuration of the dinosaur child
    */
    function mixGenesDinosaurs(uint256 genesMother, uint256 genesFather, uint16 incubatorId) private returns(uint256) {
        if (incubatorId < 4) {
            elements[incubatorId] *= 3;
        }

        uint16 abilityFather = catchNextGene(genesFather);
        uint16 abilityMother = catchNextGene(genesMother);
        uint256 newGenes = 0;
        
        // Ability
        newGenes = newGenes * 2**GENE_SIZE + mixGene(genesMother, genesFather, abilities, false, abilityMother, abilityFather);
        genesFather = remainingGenes(genesFather, GENE_SIZE);
        genesMother = remainingGenes(genesMother, GENE_SIZE);
        
        // Element

        newGenes = newGenes * 2**GENE_SIZE + mixGene(genesMother, genesFather, elements, true, abilityMother, abilityFather);
        genesFather = remainingGenes(genesFather, GENE_SIZE);
        genesMother = remainingGenes(genesMother, GENE_SIZE);
        
        // Type
        newGenes = newGenes * 2**GENE_SIZE + mixGene(genesMother, genesFather, d_type, true, abilityMother, abilityFather);
        genesFather = remainingGenes(genesFather, GENE_SIZE);
        genesMother = remainingGenes(genesMother, GENE_SIZE);
        
        // Eyes
        newGenes = newGenes * 2**GENE_SIZE + mixGene(genesMother, genesFather, d_eyes, true, abilityMother, abilityFather);
        genesFather = remainingGenes(genesFather, GENE_SIZE);
        genesMother = remainingGenes(genesMother, GENE_SIZE);
        
        // Nose
        newGenes = newGenes * 2**GENE_SIZE + mixGene(genesMother, genesFather, d_nose, true, abilityMother, abilityFather);
        genesFather = remainingGenes(genesFather, GENE_SIZE);
        genesMother = remainingGenes(genesMother, GENE_SIZE);
        
        // Mouth
        newGenes = newGenes * 2**GENE_SIZE + mixGene(genesMother, genesFather, d_mouth, true, abilityMother, abilityFather);
        genesFather = remainingGenes(genesFather, GENE_SIZE);
        genesMother = remainingGenes(genesMother, GENE_SIZE);
        
        // Tail
        newGenes = newGenes * 2**GENE_SIZE + mixGene(genesMother, genesFather, d_tail, true, abilityMother, abilityFather);
        genesFather = remainingGenes(genesFather, GENE_SIZE);
        genesMother = remainingGenes(genesMother, GENE_SIZE);
        
        // Plume
        newGenes = newGenes * 2**GENE_SIZE + mixGene(genesMother, genesFather, d_plume, true, abilityMother, abilityFather);
        genesFather = remainingGenes(genesFather, GENE_SIZE);
        genesMother = remainingGenes(genesMother, GENE_SIZE);
        
        // Legs
        newGenes = newGenes * 2**GENE_SIZE + mixGene(genesMother, genesFather, d_legs, true, abilityMother, abilityFather);
        genesFather = remainingGenes(genesFather, GENE_SIZE);
        genesMother = remainingGenes(genesMother, GENE_SIZE);
        
        // Spikes
        newGenes = newGenes * 2**GENE_SIZE + mixGene(genesMother, genesFather, d_spikes, true, abilityMother, abilityFather);
        genesFather = remainingGenes(genesFather, GENE_SIZE);
        genesMother = remainingGenes(genesMother, GENE_SIZE);
        
        // Wings
        newGenes = newGenes * 2**GENE_SIZE + mixGene(genesMother, genesFather, d_wings, true, abilityMother, abilityFather);
        genesFather = remainingGenes(genesFather, GENE_SIZE);
        genesMother = remainingGenes(genesMother, GENE_SIZE);
    
    function mixGene(uint16 geneMother, uint16 geneFather, uint[] attributeProbabilities) private view returns (uint16) {
        uint[] memory actualProbabilities = attributeProbabilities;
        uint arraySum = 0;
        for (uint i = 0; i < attributeProbabilities.length; i++) {
            total += attributeProbabilities[i];
        }
        
        int _randomNumber = int(randomNumber(total));
        
        uint16 r = 32;
        
        for (uint z = 0; z < attributeProbabilities.length; z++) {
            _randomNumber -= int(attributeProbabilities[z]);
            if (_randomNumber <= 0) {
                r = uint16(z);
                break;
            }
        }
        
        if (r == 32) {
            r = 0;
        }
        
        return r;
    }

    /**
     * Mixes two genes using a density function.
     * @param genesMother - The gene sequence of the dinosaur mother
     * @param genesFather - The gene sequence of the dinosaur father
     * @param attributeProbabilities - The probability distribution of the gene values.
     * @return {uint16} The new gene value
    */
    function mixGene(uint256 genesMother, uint256 genesFather, uint[32] attributeProbabilities, bool useAbilities, uint16 abilityMother, uint16 abilityFather) private returns(uint16) {
        
        mixesMade++;
        
        uint16 geneMother = catchNextGene(genesMother);
        uint16 geneFather = catchNextGene(genesFather);
        
        for (uint j = 0; j < attributeProbabilities.length; j++) {
            if (attributeProbabilities[j] == uint(geneFather)) {
                attributeProbabilities[j] *= 2;
            } else if (attributeProbabilities[j] == uint(geneMother)) {
                attributeProbabilities[j] *= 2;
            }

            if (useAbilities) {
                if (abilityFather == RECESSIVE_GENE_ABILITY && attributeProbabilities[j] == uint(geneFather)) {
                    attributeProbabilities[j] /= 2;
                } else if (abilityFather == DOMINANT_GENE_ABILITY && attributeProbabilities[j] == uint(geneFather)) {
                    attributeProbabilities[j] *= 2;
                }

                if (abilityMother == RECESSIVE_GENE_ABILITY && attributeProbabilities[j] == uint(geneMother)) {
                    attributeProbabilities[j] /= 2;
                } else if (abilityMother == DOMINANT_GENE_ABILITY && attributeProbabilities[j] == uint(geneMother)) {
                    attributeProbabilities[j] *= 2;
                }
            }

        }
        
        uint total = 0;
        for (uint i = 0; i < attributeProbabilities.length; i++) {
            total += attributeProbabilities[i];
        }
        
        int _randomNumber = int(randomNumber(total));
        
        uint16 r = 32;
        
        for (uint z = 0; z < attributeProbabilities.length; z++) {
            _randomNumber -= int(attributeProbabilities[z]);
            if (_randomNumber <= 0) {
                r = uint16(z);
                break;
            }
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
        
        return r;
    }
    
    /**
     * Returns the beast type of a gene sequence
     * @param genes - The gene sequence
     * @return {uint8} The beast type
    */
    function getBeastType(uint256 genes) private returns (uint8) {
        uint8 accumulator = 0;
        for (uint b = 0; b < BEAST_TYPE_LENGTH; b++) {
            uint256 r = genes % 2;
            accumulator += uint8(r) * uint8(2 ** b);
            genes /= 2;
        }
        return accumulator;
    }

    /**
     * Returns the next available gene of a gene sequence.
     * @param geneBase - The gene sequence
     * @return {uint16} The next gene available
    */
    function catchNextGene(uint256 geneBase) private returns (uint16) {
        uint16 accumulator = 0;
        for (uint b = 0; b < GENE_SIZE; b++) {
            uint256 r = geneBase % 2;
            accumulator += uint16(r) * uint16(2 ** b);
            geneBase /= 2;
        }
        return accumulator;
    }
    
    /**
     * Extracts the next available gene of a gene sequence and returns the remainder.
     * @param geneBase - The gene sequence
     * @param geneSize - The gene size
     * @return {uint16} The remainder of the sequence after extracting the gene
    */
    function remainingGenes(uint256 geneBase, uint8 geneSize) private returns (uint256) {
        return geneBase / (2 ** geneSize);
    }

    /**
     * Returns a random number using block difficulty, time and mixes previously made as seed.
     * @return {number} The random value.
    */
    function randomNumber(uint b) private constant returns (uint) {
        return uint(keccak256(block.difficulty, now, mixesMade))%b;
    }

}