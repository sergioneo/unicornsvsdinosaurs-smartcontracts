pragma solidity ^0.4.18;

import './BeastMinting.sol';

contract Legends is BeastMinting {
  
    /// @notice Creates the main Legend smart contract instance.
    function Legends() public {
        // Starts paused.
        paused = true;

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
    function() external payable { }

    function getLegend(uint256 _legendId) external view returns(Beast) {
      Beast storage legend = beasts[_legendId];
      return legend;
    }
}
