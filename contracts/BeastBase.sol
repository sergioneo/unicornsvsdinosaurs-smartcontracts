pragma solidity ^0.4.18;

import './AccessControl.sol';

/// @title Base contract for CryptoKitties. Holds all common structs, events and base variables.
/// @author Axiom Zen (https://www.axiomzen.co)
/// @dev See the BeastCore contract documentation to understand how the various contract facets are arranged.
contract BeastBase is AccessControl {
    /*** EVENTS ***/

    /// @dev The Birth event is fired whenever a new kitten comes into existence. This obviously
    ///  includes any time a cat is created through the giveBirth method, but it is also called
    ///  when a new gen0 cat is created.
    event Birth(address owner, uint256 beastId, uint256 matronId, uint256 sireId, uint256 genes);

    /// @dev Transfer event as defined in current draft of ERC721. Emitted every time a kitten
    ///  ownership is assigned, including births.
    event Transfer(address from, address to, uint256 tokenId);

    /*** DATA TYPES ***/

    // TODO: Describe
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
        uint256 genes; // first bite represent the type ( uni or dino )
        uint64 birthTime;
        uint64 coolDown;
        uint32 sireId;
        uint32 matronId;
        uint32 breedWithId;
        Attrs attrs;
    }

    /*** CONSTANTS ***/

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
            birthTime: uint64(now),
            coolDown: 0,
            matronId: uint32(_matronId),
            sireId: uint32(_sireId),
            breedWithId: 0,
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
            uint256(_beast.momId),
            uint256(_beast.dadId),
            _beast.genes
        );

        // This will assign ownership, and also emit the Transfer event as
        // per ERC721 draft
        _transfer(0, _owner, newBeastId);

        return newBeastId;
    }
}