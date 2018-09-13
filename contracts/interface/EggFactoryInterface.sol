pragma solidity ^0.4.24;

contract EggFactoryInterface {
    function isEggFactory() public pure returns (bool);
    function eggsOwned(address, uint256) public returns (uint256);
}