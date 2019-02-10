pragma solidity ^0.4.24;

import "../token/ERC721.sol";
import "../util/Pausable.sol";
import "./ClockAuctionBase.sol";

/// @title Clock auction for non-fungible tokens.
/// @notice We omit a fallback function to prevent accidental sends to this contract.
contract ClockAuction is Pausable, ClockAuctionBase {

}