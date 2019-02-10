pragma solidity >=0.4.24;

contract EggFactoryInterface {
    function isEggFactory() public pure returns (bool);
    function eggs(uint256) public returns(uint256,uint256,uint256,uint256,uint256,uint256,uint256,bool,bool,bool);
    function eggsOwned(address, uint256) public returns (uint256);
}