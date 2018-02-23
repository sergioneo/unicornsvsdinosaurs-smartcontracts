pragma solidity ^0.4.18;

import './util/AccessControl.sol';
import "./auction/SaleClockAuction.sol";
import "./auction/SiringClockAuction.sol";

/// @title Base contract for CryptoKitties. Holds all common structs, events and base variables.
/// @author Axiom Zen (https://www.axiomzen.co)
/// @dev See the BeastCore contract documentation to understand how the various contract facets are arranged.
contract BeastBase is AccessControl {
    /*** EVENTS ***/

    /// @dev The Birth event is fired whenever a new kitten comes into existence. This obviously
    ///  includes any time a beast is created through the giveBirth method, but it is also called
    ///  when a new gen0 beast is created.
    event Birth(address owner, uint256 beastId, uint256 matronId, uint256 sireId, uint256 genes);

    /// @dev Transfer event as defined in current draft of ERC721. Emitted every time a kitten
    ///  ownership is assigned, including births.
    event Transfer(address from, address to, uint256 tokenId);

    /*** DATA TYPES ***/

    enum Rarity {Common,Rare,Epic, Legendary}

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
        uint8 level; // the level of the beast, based on experience.
        Rarity rarity;
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

    /// Table indicating experience requiere for each level
    uint[20] public experienceRequiredForLevel = [
        uint(2),
        uint(4),
        uint(8),
        uint(16),
        uint(32),
        uint(64),
        uint(128),
        uint(256),
        uint(512),
        uint(1024),
        uint(2048),
        uint(4096),
        uint(8192),
        uint(16384),
        uint(32768),
        uint(65536),
        uint(131072),
        uint(262144),
        uint(524288),
        uint(1048576),
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

    /// @dev The address of the ClockAuction contract that handles sales of Kitties. This
    ///  same contract handles both peer-to-peer sales as well as the gen0 sales which are
    ///  initiated every 15 minutes.
    SaleClockAuction public saleAuction;

    /// @dev The address of a custom ClockAuction subclassed contract that handles siring
    ///  auctions. Needs to be separate from saleAuction because the actions taken on success
    ///  after a sales and siring auction are quite different.
    SiringClockAuction public siringAuction;

    /// @dev Assigns ownership of a specific Beast to an address.
    function _transfer(address _from, address _to, uint256 _tokenId) internal {
        // Since the number of kittens is capped to 2^32 we can't overflow this
        ownershipTokenCount[_to]++;
        // transfer ownership
        beastIndexToOwner[_tokenId] = _to;
        // When creating new kittens _from is 0x0, but we can't account that address.
        if (_from != address(0)) {
            ownershipTokenCount[_from]--;
            // once the kitten is transferred also clear sire allowances
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
        Rarity _rarity,
        address _owner
    )
        internal
        returns (uint)
    {
        // prevent overflows
        require(_matronId == uint256(uint32(_matronId)));
        require(_sireId == uint256(uint32(_sireId)));
        require(_generation == uint256(uint16(_generation)));

        Beast memory _beast = Beast({
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
            level: 1,
            rarity: _rarity, 
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
        Birth(
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