pragma solidity ^0.4.24;

import "./BeastOwnership.sol";
import "./interface/GeneMagicInterface.sol";
import "./util/Random.sol";

contract BeastBreeding is Random, BeastOwnership {
/*
    /// @dev The Pregnant event is fired when two beast successfully breed and the pregnancy
    ///  timer begins for the matron.
    event Pregnant(address owner, uint256 matronId, uint256 sireId, uint256 cooldownEndBlock);

    /// @notice The minimum payment required to use breedWithAuto(). This fee goes towards
    ///  the gas cost paid by whatever calls giveBirth(), and can be dynamically updated by
    ///  the COO role as the gas price changes.
    uint256 public autoBirthFee = 2 finney;

    // Keeps track of number of pregnant beasts.
    uint256 public pregnantBeasts;

    /// @dev The address of the sibling contract that is used to implement the sooper-sekret
    ///  genetic combination algorithm.
    GeneMagicInterface public geneMagic;

    /// @dev Update the address of the genetic contract, can only be called by the CEO.
    /// @param _address An address of a GeneMagic contract instance to be used from this point forward.
    function setGeneMagicAddress(address _address) external onlyCEO {
        GeneMagicInterface candidateContract = GeneMagicInterface(_address);

        // NOTE: verify that a contract is what we expect - https://github.com/Lunyr/crowdsale-contracts/blob/cfadd15986c30521d8ba7d5b6f57b4fefcc7ac38/contracts/LunyrToken.sol#L117
        require(candidateContract.isGeneMagic());

        // Set the new contract address
        geneMagic = candidateContract;
    }

    /// @dev Checks that a given beast is able to breed. Requires that the
    ///  current cooldown is finished (for sires) and also checks that there is
    ///  no pending pregnancy.
    function _isReadyToBreed(Beast _beast) internal view returns (bool) {
        // In addition to checking the cooldownEndBlock, we also need to check to see if
        // the beast has a pending birth; there can be some period of time between the end
        // of the pregnacy timer and the birth event.
        return (_beast.siringWithId == 0) && (_beast.cooldownEndBlock <= uint64(block.number));
    }

    /// @dev Check if a sire has authorized breeding with this matron. True if both sire
    ///  and matron have the same owner, or if the sire has given siring permission to
    ///  the matron's owner (via approveSiring()).
    function _isSiringPermitted(uint256 _sireId, uint256 _matronId) internal view returns (bool) {
        address matronOwner = beastIndexToOwner[_matronId];
        address sireOwner = beastIndexToOwner[_sireId];

        // Siring is okay if they have same owner, or if the matron's owner was given
        // permission to breed with this sire.
        return (matronOwner == sireOwner || sireAllowedToAddress[_sireId] == matronOwner);
    }

    /// @dev Set the cooldownEndTime for the given Beast, based on its current cooldownIndex.
    ///  Also increments the cooldownIndex (unless it has hit the cap).
    /// @param _beast A reference to the Beast in storage which needs its timer started.
    function _triggerCooldown(Beast storage _beast) internal {
        // Compute an estimation of the cooldown time in blocks (based on current cooldownIndex).
        _beast.cooldownEndBlock = uint64((cooldowns[_beast.cooldownIndex]/secondsPerBlock) + block.number);

        // Increment the breeding count, clamping it at 13, which is the length of the
        // cooldowns array. We could check the array size dynamically, but hard-coding
        // this as a constant saves gas. Yay, Solidity!
        if (_beast.cooldownIndex < 13) {
            _beast.cooldownIndex += 1;
        }
    }

    /// @notice Grants approval to another user to sire with one of your Beasts.
    /// @param _addr The address that will be able to sire with your Beast. Set to
    ///  address(0) to clear all siring approvals for this Beast.
    /// @param _sireId A Beast that you own that _addr will now be able to sire with.
    function approveSiring(address _addr, uint256 _sireId)
        external
        whenNotPaused
    {
        //require(_owns(msg.sender, _sireId));
        sireAllowedToAddress[_sireId] = _addr;
    }

    /// @dev Updates the minimum payment required for calling giveBirthAuto(). Can only
    ///  be called by the COO address. (This fee is used to offset the gas cost incurred
    ///  by the autobirth daemon).
    function setAutoBirthFee(uint256 val) external onlyCOO {
        autoBirthFee = val;
    }

    /// @dev Checks to see if a given Beast is pregnant and (if so) if the gestation
    ///  period has passed.
    function _isReadyToGiveBirth(Beast _matron) private view returns (bool) {
        return (_matron.siringWithId != 0) && (_matron.cooldownEndBlock <= uint64(block.number));
    }

    /// @notice Checks that a given beast is able to breed (i.e. it is not pregnant or
    ///  in the middle of a siring cooldown).
    /// @param _beastId reference the id of the beast, any user can inquire about it
    function isReadyToBreed(uint256 _beastId)
        public
        view
        returns (bool)
    {
        require(_beastId > 0);
        Beast storage bst = beasts[_beastId];
        return _isReadyToBreed(bst);
    }

    /// @dev Checks whether a beast is currently pregnant.
    /// @param _beastId reference the id of the beast, any user can inquire about it
    function isPregnant(uint256 _beastId)
        public
        view
        returns (bool)
    {
        require(_beastId > 0);
        // A beast is pregnant if and only if this field is set
        return beasts[_beastId].siringWithId != 0;
    }

    /// @dev Internal check to see if a given sire and matron are a valid mating pair. DOES NOT
    ///  check ownership permissions (that is up to the caller).
    /// @param _matron A reference to the Beast struct of the potential matron.
    /// @param _matronId The matron's ID.
    /// @param _sire A reference to the Beast struct of the potential sire.
    /// @param _sireId The sire's ID
    function _isValidMatingPair(
        Beast storage _matron,
        uint256 _matronId,
        Beast storage _sire,
        uint256 _sireId
    )
        private
        view
        returns(bool)
    {
        // A Beast can't breed with itself!
        if (_matronId == _sireId) {
            return false;
        }

        // Beasts can't breed with their parents.
        if (_matron.matronId == _sireId || _matron.sireId == _sireId) {
            return false;
        }
        if (_sire.matronId == _matronId || _sire.sireId == _matronId) {
            return false;
        }

        // We can short circuit the sibling check (below) if either beast is
        // gen zero (has a matron ID of zero).
        if (_sire.matronId == 0 || _matron.matronId == 0) {
            return true;
        }

        // Beasts can't breed with full or half siblings.
        if (_sire.matronId == _matron.matronId || _sire.matronId == _matron.sireId) {
            return false;
        }
        if (_sire.sireId == _matron.matronId || _sire.sireId == _matron.sireId) {
            return false;
        }

        // Everything seems cool! Let's get DTF.
        return true;
    }

    /// @dev Internal check to see if a given sire and matron are a valid mating pair for
    ///  breeding via auction (i.e. skips ownership and siring approval checks).
    function _canBreedWithViaAuction(uint256 _matronId, uint256 _sireId)
        internal
        view
        returns (bool)
    {
        Beast storage matron = beasts[_matronId];
        Beast storage sire = beasts[_sireId];
        return _isValidMatingPair(matron, _matronId, sire, _sireId);
    }

    /// @notice Checks to see if two beasts can breed together, including checks for
    ///  ownership and siring approvals. Does NOT check that both beasts are ready for
    ///  breeding (i.e. breedWith could still fail until the cooldowns are finished).
    ///  TODO: Shouldn't this check pregnancy and cooldowns?!?
    /// @param _matronId The ID of the proposed matron.
    /// @param _sireId The ID of the proposed sire.
    function canBreedWith(uint256 _matronId, uint256 _sireId)
        external
        view
        returns(bool)
    {
        require(_matronId > 0);
        require(_sireId > 0);
        Beast storage matron = beasts[_matronId];
        Beast storage sire = beasts[_sireId];
        return _isValidMatingPair(matron, _matronId, sire, _sireId) &&
            _isSiringPermitted(_sireId, _matronId);
    }

    /// @dev Internal utility function to initiate breeding, assumes that all breeding
    ///  requirements have been checked.
    function _breedWith(uint256 _matronId, uint256 _sireId) internal {
        // Grab a reference to the Beasts from storage.
        Beast storage sire = beasts[_sireId];
        Beast storage matron = beasts[_matronId];

        // Mark the matron as pregnant, keeping track of who the sire is.
        matron.siringWithId = uint32(_sireId);

        // Trigger the cooldown for both parents.
        _triggerCooldown(sire);
        _triggerCooldown(matron);

        // Clear siring permission for both parents. This may not be strictly necessary
        // but it's likely to avoid confusion!
        delete sireAllowedToAddress[_matronId];
        delete sireAllowedToAddress[_sireId];

        // Every time a beast gets pregnant, counter is incremented.
        pregnantBeasts++;

        // Emit the pregnancy event.
        Pregnant(beastIndexToOwner[_matronId], _matronId, _sireId, matron.cooldownEndBlock);
    }

    /// @notice Breed a Beast you own (as matron) with a sire that you own, or for which you
    ///  have previously been given Siring approval. Will either make your beast pregnant, or will
    ///  fail entirely. Requires a pre-payment of the fee given out to the first caller of giveBirth()
    /// @param _matronId The ID of the Beast acting as matron (will end up pregnant if successful)
    /// @param _sireId The ID of the Beast acting as sire (will begin its siring cooldown if successful)
    function breedWithAuto(uint256 _matronId, uint256 _sireId)
        external
        payable
        whenNotPaused
    {
        // Checks for payment.
        require(msg.value >= autoBirthFee);

        // Caller must own the matron.
        //require(_owns(msg.sender, _matronId));

        // Neither sire nor matron are allowed to be on auction during a normal
        // breeding operation, but we don't need to check that explicitly.
        // For matron: The caller of this function can't be the owner of the matron
        //   because the owner of a Beast on auction is the auction house, and the
        //   auction house will never call breedWith().
        // For sire: Similarly, a sire on auction will be owned by the auction house
        //   and the act of transferring ownership will have cleared any oustanding
        //   siring approval.
        // Thus we don't need to spend gas explicitly checking to see if either beast
        // is on auction.

        // Check that matron and sire are both owned by caller, or that the sire
        // has given siring permission to caller (i.e. matron's owner).
        // Will fail for _sireId = 0
        require(_isSiringPermitted(_sireId, _matronId));

        // Grab a reference to the potential matron
        Beast storage matron = beasts[_matronId];

        // Make sure matron isn't pregnant, or in the middle of a siring cooldown
        require(_isReadyToBreed(matron));

        // Grab a reference to the potential sire
        Beast storage sire = beasts[_sireId];

        // Make sure sire isn't pregnant, or in the middle of a siring cooldown
        require(_isReadyToBreed(sire));

        // Test that these cats are a valid mating pair.
        require(_isValidMatingPair(matron, _matronId, sire, _sireId));

        // All checks passed, beast gets pregnant!
        _breedWith(_matronId, _sireId);
    }

    /// @notice Have a pregnant Beast give birth!
    /// @param _matronId A Beast ready to give birth.
    /// @return The Beast ID of the new beast.
    /// @dev Looks at a given Beast and, if pregnant and if the gestation period has passed,
    ///  combines the genes of the two parents to create a new beast. The new Beast is assigned
    ///  to the current owner of the matron. Upon successful completion, both the matron and the
    ///  new beast will be ready to breed again. Note that anyone can call this function (if they
    ///  are willing to pay the gas!), but the new beast always goes to the mother's owner.
    function giveBirth(uint256 _matronId)
        external
        whenNotPaused
        returns(uint256)
    {
        // Grab a reference to the matron in storage.
        Beast storage matron = beasts[_matronId];

        // Check that the matron is a valid cat.
        require(matron.birthTime != 0);

        // Check that the matron is pregnant, and that its time has come!
        require(_isReadyToGiveBirth(matron));

        // Grab a reference to the sire in storage.
        uint256 sireId = matron.siringWithId;
        Beast storage sire = beasts[sireId];

        // Determine the higher generation number of the two parents
        uint16 parentGen = matron.generation;
        if (sire.generation > matron.generation) {
            parentGen = sire.generation;
        }

        // Call the sooper-sekret gene mixing operation.
        //uint256 childGenes = geneScience.mixGenes(matron.genes, sire.genes, matron.cooldownEndBlock - 1);
        uint256 childGenes = random(1000000000000000);

        // Make the new beast!
        address owner = beastIndexToOwner[_matronId];
        uint256 beastId = _createBeast(_matronId, matron.siringWithId, parentGen + 1, childGenes, owner);

        // Clear the reference to sire from the matron (REQUIRED! Having siringWithId
        // set is what marks a matron as being pregnant.)
        delete matron.siringWithId;

        // Every time a beast gives birth counter is decremented.
        pregnantBeasts--;

        // Send the balance fee to the person who made birth happen.
        msg.sender.transfer(autoBirthFee);

        // return the new beast's ID
        return beastId;
    }
    */
}
