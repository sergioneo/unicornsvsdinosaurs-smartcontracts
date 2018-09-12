pragma solidity ^0.4.24;

contract EggFactoryInterface {
    function isEggFactory() public pure returns (bool);
    function openEgg(uint256 _eggId, uint256 _amount) external;
}