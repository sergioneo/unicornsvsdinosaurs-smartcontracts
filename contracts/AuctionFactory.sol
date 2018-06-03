pragma solidity ^0.4.23;

contract AuctionFactory {

	struct AuctionScheme {
		uint id;
		string description;
		uint256 price;
		uint miniumumIncrement;
		address currentOwner;
		uint timeCreated;
		uint duration;
		uint increaseTime;
		bool isAuctionScheme;
	}

	mapping (uint => AuctionScheme) public auctions;

	address ceoAddress;

	address public vaultAddress;

	function AuctionFactory(address _vaultAddress) {
		ceoAddress = msg.sender;
		vaultAddress = _vaultAddress;
	}

	function createAuctionScheme(uint _auctionId, string _description, uint _price, 
		uint _miniumumIncrement, uint _duration, uint _increaseTime) {
		require(!auctionExists(_auctionId));
		auctions[_auctionId].isAuctionScheme = true;
		auctions[_auctionId].id = _auctionId;
		auctions[_auctionId].description = _description;
		auctions[_auctionId].price = _price;

		auctions[_auctionId].miniumumIncrement = _miniumumIncrement;
		auctions[_auctionId].duration = _duration;
		auctions[_auctionId].increaseTime = _increaseTime;
		auctions[_auctionId].timeCreated = block.timestamp;
	}

	function bid(uint _auctionId) payable {
		require(auctionExists(_auctionId));
		require((auctions[_auctionId].timeCreated + auctions[_auctionId].duration) < block.timestamp);
		require (msg.value >= auctions[_auctionId].price  + auctions[_auctionId].miniumumIncrement);
		auctions[_auctionId].currentOwner.transfer(auctions[_auctionId].price);
		auctions[_auctionId].currentOwner = msg.sender;
		auctions[_auctionId].timeCreated += auctions[_auctionId].increaseTime; 
	}

	function endAuction(uint _auctionId) {
		require((auctions[_auctionId].timeCreated + auctions[_auctionId].duration) > block.timestamp);
		vaultAddress.transfer(auctions[_auctionId].price);
	}

	// Verify existence of id to avoid collision
    function auctionExists( uint _auctionId) internal view returns(bool) {
        return auctions[_auctionId].isAuctionScheme;
    }

	// Set a new address for vault contract
    function setVaultAddress(address _vaultAddress) public onlyCEO returns (bool) {
        require( _vaultAddress != address(0x0) );
        vaultAddress = _vaultAddress;
    }

    /// @dev Access modifier for CEO-only functionality
    modifier onlyCEO() {
        require(msg.sender == ceoAddress);
        _;
    }
	
}