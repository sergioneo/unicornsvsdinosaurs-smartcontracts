pragma solidity ^0.4.24;

import "./util/AccessControl.sol";
import "./auction/SaleClockAuction.sol";
import "./auction/SiringClockAuction.sol";

/// @title Base contract for Rumble Legends. Holds all common structs, events and base variables.
/// @dev See the BeastCore contract documentation to understand how the various contract facets are arranged.
contract BeastBase is AccessControl {
    /*** EVENTS ***/

    /// @dev The Birth event is fired whenever a new beasts comes into existence. This obviously
    ///  includes any time a beast is created through the giveBirth method, but it is also called
    ///  when a new gen0 beast is created.
    event Birth(address owner, uint256 beastId, uint256 matronId, uint256 sireId, uint256 genes);

    /// @dev Transfer event as defined in current draft of ERC721. Emitted every time a beasts
    ///  ownership is assigned, including births.
    event Transfer(address from, address to, uint256 tokenId);

    /*** DATA TYPES ***/

    enum Pedigree {Common,Rare,Epic, Legendary}

    // @dev This attributes are the beats base to play the different challenge,
    // each challenge will use different combination of atributes. 
    struct Attrs {
        uint8 strength;
        uint8 dexterity;
        uint8 endurance;
        uint8 knowledge;
        uint8 wisdom;
        uint8 charisma;
    }
    // TODO: Describe
    struct Beast {
        uint race;
        uint256 genes; // first bit represent the type ( uni or dino )
        uint64 experience; // the experience the beast has.
        uint64 challengeCoolDown;
        uint64 birthTime; // The timestamp from the block when this beast came into existence.
        uint64 cooldownEndBlock;
        uint32 sireId;
        uint32 matronId;
        uint32 siringWithId;
        uint16 cooldownIndex;
        uint16 generation;
        uint skillId;
        uint8 level; // the level of the beast, based on experience.
        uint8 preferedAttribute; // The one atttribute that we want to increment when level up.(0,1,2,3,4 or 5)
        uint8 element; // 0 = Earth, 1 = Water, 2 = Fire, 3 = Air.
        Pedigree pedigree;
        Attrs attrs;
    }

    /*** CONSTANTS ***/

    /// @dev A lookup table indicating the cooldown duration after any successful
    ///  breeding action, called "pregnancy time" for matrons and "siring cooldown"
    ///  for sires. Designed such that the cooldown roughly doubles each time a beast
    ///  is bred, encouraging owners not to just keep breeding the same beast over
    ///  and over again. Caps out at one week (a beast can breed an unbounded number
    ///  of times, and the maximum cooldown is always seven days).
    uint32[14] public cooldowns = [
        uint32(1 minutes),
        uint32(2 minutes),
        uint32(5 minutes),
        uint32(10 minutes),
        uint32(30 minutes),
        uint32(1 hours),
        uint32(2 hours),
        uint32(4 hours),
        uint32(8 hours),
        uint32(16 hours),
        uint32(1 days),
        uint32(2 days),
        uint32(4 days),
        uint32(7 days)
    ];

    // An approximation of currently how many seconds are in between blocks.
    uint256 public secondsPerBlock = 15;

    /*** STORAGE ***/

    /// TODO: Description
    Beast[] beasts;

    /// TODO: Description
    mapping (uint256 => address) public beastIndexToOwner;

    // @dev A mapping from owner address to count of tokens that address owns.
    //  Used internally inside balanceOf() to resolve ownership count.
    mapping (address => uint256) ownershipTokenCount;

    /// @dev A mapping from BeastIDs to an address that has been approved to call
    ///  transferFrom(). Each Beast can only have one approved address for transfer
    ///  at any time. A zero value means no approval is outstanding.
    mapping (uint256 => address) public beastIndexToApproved;

    /// @dev A mapping from BeastIDs to an address that has been approved to use
    ///  this Beast for siring via breedWith(). Each Beast can only have one approved
    ///  address for siring at any time. A zero value means no approval is outstanding.
    mapping (uint256 => address) public sireAllowedToAddress;

    /// @dev The address of the ClockAuction contract that handles sales of beasts. This
    ///  same contract handles both peer-to-peer sales as well as the gen0 sales which are
    ///  initiated every 15 minutes.
    SaleClockAuction public saleAuction;

    /// @dev The address of a custom ClockAuction subclassed contract that handles siring
    ///  auctions. Needs to be separate from saleAuction because the actions taken on success
    ///  after a sales and siring auction are quite different.
    SiringClockAuction public siringAuction;

    /// @dev Assigns ownership of a specific Beast to an address.
    function _transfer(address _from, address _to, uint256 _tokenId) internal {
        // Since the number of beasts is capped to 2^32 we can't overflow this
        ownershipTokenCount[_to]++;
        // transfer ownership
        beastIndexToOwner[_tokenId] = _to;
        // When creating new beasts _from is 0x0, but we can't account that address.
        if (_from != address(0)) {
            ownershipTokenCount[_from]--;
            // once the beasts is transferred also clear sire allowances
            delete sireAllowedToAddress[_tokenId];
            // clear any previously approved ownership exchange
            delete beastIndexToApproved[_tokenId];
        }
        // Emit the transfer event.
        Transfer(_from, _to, _tokenId);
    }

    /// TODO: Description
    function _createBeast(
        uint256 _matronId,
        uint256 _sireId,
        uint256 _generation,
        uint256 _genes,
        address _owner
    )
        internal
        returns (uint256)
    {
        // prevent overflows
        require(_matronId == uint256(uint32(_matronId)));
        require(_sireId == uint256(uint32(_sireId)));
        require(_generation == uint256(uint16(_generation)));

        // TODO: Skill ID = 0 is not the right thing to do, we want to have random skills?
        // TODO: element = 0 is not right as well, should be taken out from ADN.
        Beast memory _beast = Beast({
            race: 0, // TODO: Extract from Genes
            genes: _genes,
            experience: 0,
            challengeCoolDown: 0,
            birthTime: uint64(now),
            cooldownEndBlock: 0,
            sireId: uint32(_sireId),
            matronId: uint32(_matronId),
            siringWithId: 0,
            cooldownIndex: 0,
            generation: uint16(_generation),
            skillId: 0, // TODO: Extract from Genes
            level: 1,
            preferedAttribute: 0,
            element: 0, // TODO: Extract from Genes 
            pedigree: Pedigree.Common, // TODO: Extract from Genes
            attrs: Attrs({
                strength: 1,
                dexterity: 1,
                endurance: 1,
                knowledge: 1,
                wisdom: 1,
                charisma: 1
            })
        });
        uint256 newBeastId = beasts.push(_beast) - 1;

        // prevent overflow of 4 billion beasts
        require(newBeastId == uint256(uint32(newBeastId)));

        // emit the birth event
        emit Birth(
            _owner,
            newBeastId,
            uint256(_beast.matronId),
            uint256(_beast.sireId),
            _beast.genes
        );

        // This will assign ownership, and also emit the Transfer event as
        // per ERC721 draft
        _transfer(0, _owner, newBeastId);

        return newBeastId;
    }
}