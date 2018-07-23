pragma solidity ^0.4.0;
contract GeneMagic {
    
    uint8 constant BEAST_TYPE_LENGTH = 2;
    uint8 constant GENE_BASE_LENGTH = 254;
    uint8 constant GENE_SIZE = 5;
    uint8 constant EXTRA_GENE_SIZE = 5;
    uint8 constant RECESSIVE_GENE_ABILITY = 12;
    uint8 constant DOMINANT_GENE_ABILITY = 23;

    // PROBABILITIES FOR ABILITIES
    uint256[32] private abilities;
    uint256[32] private second_abilities;
        
    // PROBABILITIES FOR ELEMENTS
    uint256[32] private elements;

    // PROBABILITIES FOR PEDIGREE
    uint256[32] private pedigree;

    // PROBABILITIES FOR COLOR COMBINATION
    uint256[32] private color_combination;
        
    // PROBABILITIES FOR UNICORNS
    uint256[32] private u_type;
    uint256[32] private u_eyes;
    uint256[32] private u_horn;
    uint256[32] private u_hair;
    uint256[32] private u_tail;
    uint256[32] private u_snout;
    uint256[32] private u_legs;

    // PROBABILITIES FOR DINOSAURS
    uint256[32] private d_type;
    uint256[32] private d_eyes;
    uint256[32] private d_nose;
    uint256[32] private d_mouth;
    uint256[32] private d_tail;
    uint256[32] private d_plume;
    uint256[32] private d_legs;
    uint256[32] private d_spikes;
    uint256[32] private d_wings;
    
    uint private mixesMade = 0;

    event readGene(string, uint256);
    
    /**
     * Performs Gene Magic between two gene sequences.
     * @param genesMother - The gene sequence of the mother
     * @param genesFather - The gene sequence of the father
     * @param incubatorId - The id of the incubator
     * @return {uint256} The gene configuration of the child
    */
    function mixGenes(uint8 beastType, uint256 genesMother, uint256 genesFather, uint16 incubatorId) public returns (uint256) {
        uint256 mixedGenes = 0;
        if (beastType == 0) {
            mixedGenes = mixGenesDinosaurs(genesMother, genesFather, incubatorId);
        } else {
            mixedGenes = mixGenesUnicorns(genesMother, genesFather, incubatorId);
        }
        
        return mixedGenes;
    }

    /**
     * Creates a brand new gene sequence
     * @param beastType - The beast type of this new beast
     * @return {uint256} The gene configuration of the new beast
    */
    function createGenes(uint8 beastType, uint256 suggestedSequence) public returns(uint256) {
        uint256 mixedGenes = 0;
        if (beastType == 0) {
            mixedGenes = createGenesDinosaur(suggestedSequence);
        } else {
            mixedGenes = createGenesUnicorn(suggestedSequence);
        }
        return mixedGenes;
    }

    /**
     * Auxiliary function - Creates a brand new gene unicorn sequence
     * @return {uint256} The gene configuration of the new unicorn
    */
    function createGenesUnicorn(uint256 suggestedSequence) private returns(uint256) {
        uint256 newGenes = 0;
        uint16 nextSuggestedGene = catchNextGene(suggestedSequence, GENE_SIZE);
        suggestedSequence = remainingGenes(suggestedSequence, GENE_SIZE);
        
        // Legs
        newGenes = newGenes * 2**uint(GENE_SIZE) + createGene(u_legs, nextSuggestedGene);
        nextSuggestedGene = catchNextGene(suggestedSequence, GENE_SIZE);
        suggestedSequence = remainingGenes(suggestedSequence, GENE_SIZE);
        
        // Snout
        newGenes = newGenes * 2**uint(GENE_SIZE) + createGene(u_snout, nextSuggestedGene);
        nextSuggestedGene = catchNextGene(suggestedSequence, GENE_SIZE);
        suggestedSequence = remainingGenes(suggestedSequence, GENE_SIZE);
        
        // Tail
        newGenes = newGenes * 2**uint(GENE_SIZE) + createGene(u_tail, nextSuggestedGene);
        nextSuggestedGene = catchNextGene(suggestedSequence, GENE_SIZE);
        suggestedSequence = remainingGenes(suggestedSequence, GENE_SIZE);
        
        // Hair
        newGenes = newGenes * 2**uint(GENE_SIZE) + createGene(u_hair, nextSuggestedGene);
        nextSuggestedGene = catchNextGene(suggestedSequence, GENE_SIZE);
        suggestedSequence = remainingGenes(suggestedSequence, GENE_SIZE);
        
        // Horn
        newGenes = newGenes * 2**uint(GENE_SIZE) + createGene(u_horn, nextSuggestedGene);
        nextSuggestedGene = catchNextGene(suggestedSequence, GENE_SIZE);
        suggestedSequence = remainingGenes(suggestedSequence, GENE_SIZE);
        
        // Eyes
        newGenes = newGenes * 2**uint(GENE_SIZE) + createGene(u_eyes, nextSuggestedGene);
        nextSuggestedGene = catchNextGene(suggestedSequence, GENE_SIZE);
        suggestedSequence = remainingGenes(suggestedSequence, GENE_SIZE);
        
        // Type
        newGenes = newGenes * 2**uint(GENE_SIZE) + createGene(u_type, nextSuggestedGene);
        nextSuggestedGene = catchNextGene(suggestedSequence, GENE_SIZE);
        suggestedSequence = remainingGenes(suggestedSequence, GENE_SIZE);
        
        // Element
        newGenes = newGenes * 2**uint(GENE_SIZE) + createGene(elements, nextSuggestedGene);
        nextSuggestedGene = catchNextGene(suggestedSequence, GENE_SIZE);
        suggestedSequence = remainingGenes(suggestedSequence, GENE_SIZE);

        // Pedigree
        newGenes = newGenes * 2**uint(GENE_SIZE) + createGene(pedigree, nextSuggestedGene);
        nextSuggestedGene = catchNextGene(suggestedSequence, GENE_SIZE);
        suggestedSequence = remainingGenes(suggestedSequence, GENE_SIZE);

        // Second Ability
        newGenes = newGenes * 2**uint(GENE_SIZE) + createGene(second_abilities, nextSuggestedGene);
        nextSuggestedGene = catchNextGene(suggestedSequence, GENE_SIZE);
        suggestedSequence = remainingGenes(suggestedSequence, GENE_SIZE);
        
        // Ability
        newGenes = newGenes * 2**uint(GENE_SIZE) + createGene(abilities, nextSuggestedGene);
        nextSuggestedGene = catchNextGene(suggestedSequence, 2);
        suggestedSequence = remainingGenes(suggestedSequence, 2);

        // Beast Type (will always be 1)
        newGenes = newGenes * 2**2 + 1;
        nextSuggestedGene = catchNextGene(suggestedSequence, EXTRA_GENE_SIZE);

        // Color Combination
        newGenes = newGenes * 2**uint(GENE_SIZE) + createGene(color_combination, nextSuggestedGene);
    
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

        uint16 abilityFather = catchAbilityUnicorn(genesFather);
        uint16 abilityMother = catchAbilityUnicorn(genesMother);
        uint256 newGenes = 0;
        
        // Snout
        newGenes = newGenes * 2**uint(GENE_SIZE) + mixGene(GENE_SIZE, genesMother, genesFather, u_snout, true, abilityMother, abilityFather);
        genesFather = remainingGenes(genesFather, GENE_SIZE);
        genesMother = remainingGenes(genesMother, GENE_SIZE);
        
        // Tail
        newGenes = newGenes * 2**uint(GENE_SIZE) + mixGene(GENE_SIZE, genesMother, genesFather, u_tail, true, abilityMother, abilityFather);
        genesFather = remainingGenes(genesFather, GENE_SIZE);
        genesMother = remainingGenes(genesMother, GENE_SIZE);
        
        // Hair
        newGenes = newGenes * 2**uint(GENE_SIZE) + mixGene(GENE_SIZE, genesMother, genesFather, u_hair, true, abilityMother, abilityFather);
        genesFather = remainingGenes(genesFather, GENE_SIZE);
        genesMother = remainingGenes(genesMother, GENE_SIZE);
        
        // Horn
        newGenes = newGenes * 2**uint(GENE_SIZE) + mixGene(GENE_SIZE, genesMother, genesFather, u_horn, true, abilityMother, abilityFather);
        genesFather = remainingGenes(genesFather, GENE_SIZE);
        genesMother = remainingGenes(genesMother, GENE_SIZE);
        
        // Eyes
        newGenes = newGenes * 2**uint(GENE_SIZE) + mixGene(GENE_SIZE, genesMother, genesFather, u_eyes, true, abilityMother, abilityFather);
        genesFather = remainingGenes(genesFather, GENE_SIZE);
        genesMother = remainingGenes(genesMother, GENE_SIZE);
        
        // Type
        newGenes = newGenes * 2**uint(GENE_SIZE) + mixGene(GENE_SIZE, genesMother, genesFather, u_type, true, abilityMother, abilityFather);
        genesFather = remainingGenes(genesFather, GENE_SIZE);
        genesMother = remainingGenes(genesMother, GENE_SIZE);
        
        // Element
        newGenes = newGenes * 2**uint(GENE_SIZE) + mixGene(GENE_SIZE, genesMother, genesFather, elements, true, abilityMother, abilityFather);
        genesFather = remainingGenes(genesFather, GENE_SIZE);
        genesMother = remainingGenes(genesMother, GENE_SIZE);

        // Pedigree
        newGenes = newGenes * 2**uint(GENE_SIZE) + mixGene(GENE_SIZE, genesMother, genesFather, pedigree, true, abilityMother, abilityFather);
        genesFather = remainingGenes(genesFather, GENE_SIZE);
        genesMother = remainingGenes(genesMother, GENE_SIZE);

        // Second Ability
        newGenes = newGenes * 2**uint(GENE_SIZE) + mixGene(GENE_SIZE, genesMother, genesFather, second_abilities, true, abilityMother, abilityFather);
        genesFather = remainingGenes(genesFather, GENE_SIZE);
        genesMother = remainingGenes(genesMother, GENE_SIZE);
        
        // Ability
        newGenes = newGenes * 2**uint(GENE_SIZE) + mixGene(GENE_SIZE, genesMother, genesFather, abilities, true, abilityMother, abilityFather);
        genesFather = remainingGenes(genesFather, GENE_SIZE);
        genesMother = remainingGenes(genesMother, GENE_SIZE);
        
        // Beast Type - will always be 1
        newGenes = newGenes * 2**uint(GENE_SIZE) + 1;
        genesFather = remainingGenes(genesFather, 2);
        genesMother = remainingGenes(genesMother, 2);
        
        // Color Combination
        newGenes = newGenes * 2**uint(EXTRA_GENE_SIZE) + mixGene(EXTRA_GENE_SIZE, genesMother, genesFather, abilities, true, abilityMother, abilityFather);
    
        return newGenes;
    }
    
    /**
     * Auxiliary function - Creates a brand new gene dinosaur sequence
     * @return {uint256} The gene configuration of the new dinosaur
    */
    function createGenesDinosaur(uint256 suggestedSequence) private returns(uint256) {
        uint256 newGenes = 0;
        uint16 nextSuggestedGene = catchNextGene(suggestedSequence, GENE_SIZE);
        suggestedSequence = remainingGenes(suggestedSequence, GENE_SIZE);
        
        // Wings
        newGenes = newGenes * 2**uint(GENE_SIZE) + createGene(d_wings, nextSuggestedGene);
        nextSuggestedGene = catchNextGene(suggestedSequence, GENE_SIZE);
        suggestedSequence = remainingGenes(suggestedSequence, GENE_SIZE);
        
        // Spikes
        newGenes = newGenes * 2**uint(GENE_SIZE) + createGene(d_spikes, nextSuggestedGene);
        nextSuggestedGene = catchNextGene(suggestedSequence, GENE_SIZE);
        suggestedSequence = remainingGenes(suggestedSequence, GENE_SIZE);
        
        // Legs
        newGenes = newGenes * 2**uint(GENE_SIZE) + createGene(d_legs, nextSuggestedGene);
        nextSuggestedGene = catchNextGene(suggestedSequence, GENE_SIZE);
        suggestedSequence = remainingGenes(suggestedSequence, GENE_SIZE);
        
        // Plume
        newGenes = newGenes * 2**uint(GENE_SIZE) + createGene(d_plume, nextSuggestedGene);
        nextSuggestedGene = catchNextGene(suggestedSequence, GENE_SIZE);
        suggestedSequence = remainingGenes(suggestedSequence, GENE_SIZE);
        
        // Tail
        newGenes = newGenes * 2**uint(GENE_SIZE) + createGene(d_tail, nextSuggestedGene);
        nextSuggestedGene = catchNextGene(suggestedSequence, GENE_SIZE);
        suggestedSequence = remainingGenes(suggestedSequence, GENE_SIZE);
        
        // Mouth
        newGenes = newGenes * 2**uint(GENE_SIZE) + createGene(d_mouth, nextSuggestedGene);
        nextSuggestedGene = catchNextGene(suggestedSequence, GENE_SIZE);
        suggestedSequence = remainingGenes(suggestedSequence, GENE_SIZE);
        
        // Nose
        newGenes = newGenes * 2**uint(GENE_SIZE) + createGene(d_nose, nextSuggestedGene);
        nextSuggestedGene = catchNextGene(suggestedSequence, GENE_SIZE);
        suggestedSequence = remainingGenes(suggestedSequence, GENE_SIZE);
        
        // Eyes
        newGenes = newGenes * 2**uint(GENE_SIZE) + createGene(d_eyes, nextSuggestedGene);
        nextSuggestedGene = catchNextGene(suggestedSequence, GENE_SIZE);
        suggestedSequence = remainingGenes(suggestedSequence, GENE_SIZE);
        
        // Type
        newGenes = newGenes * 2**uint(GENE_SIZE) + createGene(d_type, nextSuggestedGene);
        nextSuggestedGene = catchNextGene(suggestedSequence, GENE_SIZE);
        suggestedSequence = remainingGenes(suggestedSequence, GENE_SIZE);
        
        // Element
        newGenes = newGenes * 2**uint(GENE_SIZE) + createGene(elements, nextSuggestedGene);
        nextSuggestedGene = catchNextGene(suggestedSequence, GENE_SIZE);
        suggestedSequence = remainingGenes(suggestedSequence, GENE_SIZE);

        // Pedigree
        newGenes = newGenes * 2**uint(GENE_SIZE) + createGene(pedigree, nextSuggestedGene);
        nextSuggestedGene = catchNextGene(suggestedSequence, GENE_SIZE);
        suggestedSequence = remainingGenes(suggestedSequence, GENE_SIZE);

        // Second Ability
        newGenes = newGenes * 2**uint(GENE_SIZE) + createGene(second_abilities, nextSuggestedGene);
        nextSuggestedGene = catchNextGene(suggestedSequence, GENE_SIZE);
        suggestedSequence = remainingGenes(suggestedSequence, GENE_SIZE);
        
        // Ability
        newGenes = newGenes * 2**uint(GENE_SIZE) + createGene(abilities, nextSuggestedGene);
        nextSuggestedGene = catchNextGene(suggestedSequence, 2);
        suggestedSequence = remainingGenes(suggestedSequence, 2);

        // Beast Type (will always be 0)
        newGenes = newGenes * 2**2;
        nextSuggestedGene = catchNextGene(suggestedSequence, EXTRA_GENE_SIZE);

        // Color Combination
        newGenes = newGenes * 2**uint(GENE_SIZE) + createGene(color_combination, nextSuggestedGene);
    
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

        uint16 abilityFather = catchAbilityDinosaur(genesFather);
        uint16 abilityMother = catchAbilityDinosaur(genesMother);
        uint256 newGenes = 0;
        
        // Wings
        newGenes = newGenes * 2**uint(GENE_SIZE) + mixGene(GENE_SIZE, genesMother, genesFather, d_wings, true, abilityMother, abilityFather);
        genesFather = remainingGenes(genesFather, GENE_SIZE);
        genesMother = remainingGenes(genesMother, GENE_SIZE);
        
        // Spikes
        newGenes = newGenes * 2**uint(GENE_SIZE) + mixGene(GENE_SIZE, genesMother, genesFather, d_spikes, true, abilityMother, abilityFather);
        genesFather = remainingGenes(genesFather, GENE_SIZE);
        genesMother = remainingGenes(genesMother, GENE_SIZE);
        
        // Legs
        newGenes = newGenes * 2**uint(GENE_SIZE) + mixGene(GENE_SIZE, genesMother, genesFather, d_legs, true, abilityMother, abilityFather);
        genesFather = remainingGenes(genesFather, GENE_SIZE);
        genesMother = remainingGenes(genesMother, GENE_SIZE);
        
        // Plume
        newGenes = newGenes * 2**uint(GENE_SIZE) + mixGene(GENE_SIZE, genesMother, genesFather, d_plume, true, abilityMother, abilityFather);
        genesFather = remainingGenes(genesFather, GENE_SIZE);
        genesMother = remainingGenes(genesMother, GENE_SIZE);
        
        // Tail
        newGenes = newGenes * 2**uint(GENE_SIZE) + mixGene(GENE_SIZE, genesMother, genesFather, d_tail, true, abilityMother, abilityFather);
        genesFather = remainingGenes(genesFather, GENE_SIZE);
        genesMother = remainingGenes(genesMother, GENE_SIZE);
        
        // Mouth
        newGenes = newGenes * 2**uint(GENE_SIZE) + mixGene(GENE_SIZE, genesMother, genesFather, d_mouth, true, abilityMother, abilityFather);
        genesFather = remainingGenes(genesFather, GENE_SIZE);
        genesMother = remainingGenes(genesMother, GENE_SIZE);
        
        // Nose
        newGenes = newGenes * 2**uint(GENE_SIZE) + mixGene(GENE_SIZE, genesMother, genesFather, d_nose, true, abilityMother, abilityFather);
        genesFather = remainingGenes(genesFather, GENE_SIZE);
        genesMother = remainingGenes(genesMother, GENE_SIZE);
        
        // Eyes
        newGenes = newGenes * 2**uint(GENE_SIZE) + mixGene(GENE_SIZE, genesMother, genesFather, d_eyes, true, abilityMother, abilityFather);
        genesFather = remainingGenes(genesFather, GENE_SIZE);
        genesMother = remainingGenes(genesMother, GENE_SIZE);
        
        // Type
        newGenes = newGenes * 2**uint(GENE_SIZE) + mixGene(GENE_SIZE, genesMother, genesFather, d_type, true, abilityMother, abilityFather);
        genesFather = remainingGenes(genesFather, GENE_SIZE);
        genesMother = remainingGenes(genesMother, GENE_SIZE);
        
        // Element
        newGenes = newGenes * 2**uint(GENE_SIZE) + mixGene(GENE_SIZE, genesMother, genesFather, elements, true, abilityMother, abilityFather);
        genesFather = remainingGenes(genesFather, GENE_SIZE);
        genesMother = remainingGenes(genesMother, GENE_SIZE);

        // Pedigree
        newGenes = newGenes * 2**uint(GENE_SIZE) + mixGene(GENE_SIZE, genesMother, genesFather, pedigree, true, abilityMother, abilityFather);
        genesFather = remainingGenes(genesFather, GENE_SIZE);
        genesMother = remainingGenes(genesMother, GENE_SIZE);

        // Second Ability
        newGenes = newGenes * 2**uint(GENE_SIZE) + mixGene(GENE_SIZE, genesMother, genesFather, second_abilities, true, abilityMother, abilityFather);
        genesFather = remainingGenes(genesFather, GENE_SIZE);
        genesMother = remainingGenes(genesMother, GENE_SIZE);
        
        // Ability
        newGenes = newGenes * 2**uint(GENE_SIZE) + mixGene(GENE_SIZE, genesMother, genesFather, abilities, true, abilityMother, abilityFather);
        genesFather = remainingGenes(genesFather, GENE_SIZE);
        genesMother = remainingGenes(genesMother, GENE_SIZE);
        
        // Beast Type - will always be 0
        newGenes = newGenes * 2**uint(GENE_SIZE) + 0;
        genesFather = remainingGenes(genesFather, 2);
        genesMother = remainingGenes(genesMother, 2);
        
        // Color Combination
        newGenes = newGenes * 2**uint(EXTRA_GENE_SIZE) + mixGene(EXTRA_GENE_SIZE, genesMother, genesFather, abilities, true, abilityMother, abilityFather);
    
        return newGenes;
    }

    /**
     * Generates a new gene according to a density function.
     * @param attributeProbabilities - The probability distribution of the gene values.
     * @return {uint16} The new gene value
    */
    function createGene(uint[32] attributeProbabilities, uint16 suggestedGene) private returns(uint16) {
        
        if (suggestedGene != 0) {
            return suggestedGene;
        }

        mixesMade++;
        
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
    function mixGene(uint8 geneSize, uint256 genesMother, uint256 genesFather, uint[32] attributeProbabilities, bool useAbilities, uint16 abilityMother, uint16 abilityFather) private returns(uint16) {
        
        mixesMade++;
        
        for (uint j = 0; j < attributeProbabilities.length; j++) {
            if (attributeProbabilities[j] == uint(catchNextGene(genesFather, geneSize))) {
                attributeProbabilities[j] *= 2;
            } else if (attributeProbabilities[j] == uint(catchNextGene(genesMother, geneSize))) {
                attributeProbabilities[j] *= 2;
            }

            if (useAbilities) {
                if (abilityFather == RECESSIVE_GENE_ABILITY && attributeProbabilities[j] == uint(catchNextGene(genesFather, geneSize))) {
                    attributeProbabilities[j] /= 2;
                } else if (abilityFather == DOMINANT_GENE_ABILITY && attributeProbabilities[j] == uint(catchNextGene(genesFather, geneSize))) {
                    attributeProbabilities[j] *= 2;
                }

                if (abilityMother == RECESSIVE_GENE_ABILITY && attributeProbabilities[j] == uint(catchNextGene(genesMother, geneSize))) {
                    attributeProbabilities[j] /= 2;
                } else if (abilityMother == DOMINANT_GENE_ABILITY && attributeProbabilities[j] == uint(catchNextGene(genesMother, geneSize))) {
                    attributeProbabilities[j] *= 2;
                }
            }

        }
        
        uint total = 0;
        for (uint i = 0; i < attributeProbabilities.length; i++) {
            total += attributeProbabilities[i];
        }
        
        int _randomNumber = int(randomNumber(total));
        
        uint16 r = 2 ** geneSize;
        
        for (uint z = 0; z < attributeProbabilities.length; z++) {
            _randomNumber -= int(attributeProbabilities[z]);
            if (_randomNumber <= 0) {
                r = uint16(z);
                break;
            }
        }
        
        if (r == 2 ** geneSize) {
            r = 0;
        }
        
        return r;
    }

    /**
     * Returns the next available gene of a gene sequence.
     * @param geneBase - The gene sequence
     * @return {uint16} The next gene available
    */
    function catchNextGene(uint256 geneBase, uint8 geneSize) private pure returns (uint16) {
        uint16 accumulator = 0;
        for (uint b = 0; b < geneSize; b++) {
            uint256 r = geneBase % 2;
            accumulator += uint16(r) * uint16(2 ** b);
            geneBase /= 2;
        }
        return accumulator;
    }

    function catchAbilityUnicorn(uint256 geneBase) private pure returns (uint16) {
        geneBase = geneBase / (2 ** uint(GENE_SIZE * 10));
        return catchNextGene(geneBase, GENE_SIZE);
    }

    function catchAbilityDinosaur(uint256 geneBase) private pure returns (uint16) {
        geneBase = geneBase / (2 ** uint(GENE_SIZE * 12));
        return catchNextGene(geneBase, GENE_SIZE);
    }
    
    /**
     * Extracts the next available gene of a gene sequence and returns the remainder.
     * @param geneBase - The gene sequence
     * @param geneSize - The gene size
     * @return {uint16} The remainder of the sequence after extracting the gene
    */
    function remainingGenes(uint256 geneBase, uint8 geneSize) private pure returns (uint256) {
        return geneBase / (2 ** uint(geneSize));
    }

    /**
     * Returns a random number using block difficulty, time and mixes previously made as seed.
     * @return {number} The random value.
    */
    function randomNumber(uint b) private constant returns (uint) {
        return uint(keccak256(block.difficulty, now, mixesMade))%b;
    }



    // Unicorn setters

    function set_u_type(uint32 pos, uint256 val) private {
        u_type[pos] = val;
    }

    function set_u_eyes(uint32 pos, uint256 val) private {
        u_eyes[pos] = val;
    }

    function set_u_horn(uint32 pos, uint256 val) private {
        u_horn[pos] = val;
    }

    function set_u_hair(uint32 pos, uint256 val) private {
        u_hair[pos] = val;
    }

    function set_u_tail(uint32 pos, uint256 val) private {
        u_tail[pos] = val;
    }

    function set_u_snout(uint32 pos, uint256 val) private {
        u_snout[pos] = val;
    }

    function set_u_legs(uint32 pos, uint256 val) private {
        u_legs[pos] = val;
    }

    // Dinosaur setters

    function set_d_type(uint32 pos, uint256 val) private {
        d_type[pos] = val;
    }

    function set_d_eyes(uint32 pos, uint256 val) private {
        d_eyes[pos] = val;
    }

    function set_d_nose(uint32 pos, uint256 val) private {
        d_nose[pos] = val;
    }

    function set_d_mouth(uint32 pos, uint256 val) private {
        d_mouth[pos] = val;
    }

    function set_d_tail(uint32 pos, uint256 val) private {
        d_tail[pos] = val;
    }

    function set_d_plume(uint32 pos, uint256 val) private {
        d_plume[pos] = val;
    }

    function set_d_legs(uint32 pos, uint256 val) private {
        d_legs[pos] = val;
    }

    function set_d_spikes(uint32 pos, uint256 val) private {
        d_spikes[pos] = val;
    }

    function set_d_wings(uint32 pos, uint256 val) private {
        d_wings[pos] = val;
    }

    // COMMON SETTERS

    function set_abilities(uint32 pos, uint256 val) private {
        abilities[pos] = val;
    }

    function set_second_abilities(uint32 pos, uint256 val) private {
        second_abilities[pos] = val;
    }

    function set_elements(uint32 pos, uint256 val) private {
        elements[pos] = val;
    }

    function set_pedigree(uint32 pos, uint256 val) private {
        pedigree[pos] = val;
    }

}