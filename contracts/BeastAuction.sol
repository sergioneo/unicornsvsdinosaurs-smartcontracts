pragma solidity ^0.4.24;

import "./BeastBreeding.sol";
import "./auction/ClockAuction.sol";
import "./auction/SaleClockAuction.sol";

contract BeastAuction is BeastBreeding {

    /// @dev Sets the reference to the sale auction.
    /// @param _address - Address of sale contract.
    function setSaleAuctionAddress(address _address) public onlyCEO {
        SaleClockAuction candidateContract = SaleClockAuction(_address);

        // NOTE: verify that a contract is what we expect - https://github.com/Lunyr/crowdsale-contracts/blob/cfadd15986c30521d8ba7d5b6f57b4fefcc7ac38/contracts/LunyrToken.sol#L117
        require(candidateContract.isSaleClockAuction());

        // Set the new contract address
        saleAuction = candidateContract;
    }

    /// @dev Sets the reference to the siring auction.
    /// @param _address - Address of siring contract.
    function setSiringAuctionAddress(address _address) external onlyCEO {
        SiringClockAuction candidateContract = SiringClockAuction(_address);

        // NOTE: verify that a contract is what we expect - https://github.com/Lunyr/crowdsale-contracts/blob/cfadd15986c30521d8ba7d5b6f57b4fefcc7ac38/contracts/LunyrToken.sol#L117
        require(candidateContract.isSiringClockAuction());

        // Set the new contract address
        siringAuction = candidateContract;
    }

    /// @dev Put a beast up for auction.
    ///  Does some ownership trickery to create auctions in one tx.
    function createSaleAuction(
        uint256 _beastId,
        uint256 _startingPrice,
        uint256 _endingPrice,
        uint256 _duration
    )
        public
        whenNotPaused
    {
        // Auction contract checks input sizes
        // If beast is already on any auction, this will throw
        // because it will be owned by the auction contract.
        require(_owns(msg.sender, _beastId));
        // Ensure the beast is not pregnant to prevent the auction
        // contract accidentally receiving ownership of the child.
        // NOTE: the beast IS allowed to be in a cooldown.
        require(!isPregnant(_beastId));
        _approve(_beastId, saleAuction);
        // Sale auction throws if inputs are invalid and clears
        // transfer and sire approval after escrowing the beast.
        saleAuction.createAuction(
            _beastId,
            _startingPrice,
            _endingPrice,
            _duration,
            msg.sender
        );
    }

    /// @dev Put a beast up for auction to be sire.
    ///  Performs checks to ensure the beast can be sired, then
    ///  delegates to reverse auction.
    function createSiringAuction(
        uint256 _beastId,
        uint256 _startingPrice,
        uint256 _endingPrice,
        uint256 _duration
    )
        external
        whenNotPaused
    {
        // Auction contract checks input sizes
        // If beast is already on any auction, this will throw
        // because it will be owned by the auction contract.
        require(_owns(msg.sender, _beastId));
        require(isReadyToBreed(_beastId));
        _approve(_beastId, siringAuction);
        // Siring auction throws if inputs are invalid and clears
        // transfer and sire approval after escrowing the beast.
        siringAuction.createAuction(
            _beastId,
            _startingPrice,
            _endingPrice,
            _duration,
            msg.sender
        );
    }

    /// @dev Completes a siring auction by bidding.
    ///  Immediately breeds the winning matron with the sire on auction.
    /// @param _sireId - ID of the sire on auction.
    /// @param _matronId - ID of the matron owned by the bidder.
    function bidOnSiringAuction(
        uint256 _sireId,
        uint256 _matronId
    )
        external
        payable
        whenNotPaused
    {
        // Auction contract checks input sizes
        require(_owns(msg.sender, _matronId));
        require(isReadyToBreed(_matronId));
        require(_canBreedWithViaAuction(_matronId, _sireId));

        // Define the current price of the auction.
        uint256 currentPrice = siringAuction.getCurrentPrice(_sireId);
        require(msg.value >= currentPrice + autoBirthFee);

        // Siring auction will throw if the bid fails.
        siringAuction.bid.value(msg.value - autoBirthFee)(_sireId);
        _breedWith(uint32(_matronId), uint32(_sireId));
    }

    /// @dev Transfers the balance of the sale auction contract
    /// to the Legends contract. We use two-step withdrawal to
    /// prevent two transfer calls in the auction bid function.
    // TODO: Check if balance must go to Split Payment
    function withdrawAuctionBalances() external onlyCLevel {
        saleAuction.withdrawBalance();
        siringAuction.withdrawBalance();
    }
}