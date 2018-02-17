pragma solidity ^0.4.18;

import './BeastMinting.sol';

contract Legends is BeastMinting {
  
    event Bought(uint256 legendId);

    /// CONSTANT
    uint BOUGHT_PRICE = 300000000000000000;

    /// @notice Creates the main Legend smart contract instance.
    function Legends() public {
        // Starts paused.
        //paused = true;

        // the creator of the contract is the initial CEO
        ceoAddress = msg.sender;

        // the creator of the contract is also the initial COO
        cooAddress = msg.sender;

        // start with the mythical kitten 0 - so we don't have generation-0 parent issues
        _createBeast(0, 0, 0, uint256(-1), address(0));
    }

    /// @notice No tipping!
    /// @dev Reject all Ether from being sent here, unless it's from one of the
    ///  two auction contracts. (Hopefully, we can prevent user accidents.)
    function() external payable {
        //require(
        //    msg.sender == address(saleAuction) ||
        //    msg.sender == address(siringAuction)
        //);
    }

    function getLegend(uint256 _legendId) external view returns(uint256) {
      Beast storage legend = beasts[_legendId];
      return legend.genes;
    }

    function buyRandomLegend() external payable {
        require( BOUGHT_PRICE == msg.value );

        // TODO: Random gens
        uint256 randomGens = random(100000000000);
        uint legendId = _createBeast(0, 0, 0, randomGens, msg.sender);
        Bought(legendId);
    }

    function legendToMarket(uint256 legendId, uint256 _startingPrice, uint256 _endingPrice) external {
        createSaleAuction(legendId, _startingPrice, _endingPrice, 3600);
    }

    // @dev Allows the CFO to capture the balance available to the contract.
    function withdrawBalance() external onlyCFO {
        uint256 balance = this.balance;
        cfoAddress.transfer(balance);
    }

    // TODO: replace random with oracle
    // COPY FROM https://github.com/axiomzen/eth-random
    uint256 _seed;

    // The upper bound of the number returns is 2^bits - 1
    function bitSlice(uint256 n, uint256 bits, uint256 slot) private pure returns(uint256) {
        uint256 offset = slot * bits;
        // mask is made by shifting left an offset number of times
        uint256 mask = uint256((2**bits) - 1) << offset;
        // AND n with mask, and trim to max of 5 bits
        return uint256((n & mask) >> offset);
    }

    function maxRandom() private returns (uint256 randomNumber) {
        _seed = uint256(keccak256(
            _seed,
            block.blockhash(block.number - 1),
            block.coinbase,
            block.difficulty
        ));
        return _seed;
    }

    // return a pseudo random number between lower and upper bounds
    // given the number of previous blocks it should hash.
    function random(uint256 upper) private returns (uint256 randomNumber) {
        return maxRandom() % upper;
    }
}
