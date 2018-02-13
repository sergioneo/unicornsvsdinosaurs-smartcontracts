pragma solidity ^0.4.4;

contract Market {

  event BestAcquired(uint256 _beastId);
  event BestOffered(uint256 _beastId, uint _price);
  
  mapping (uint256 => address) public beastIndexToOwner;
  uint256[] bestInAuction;
  
  function MarketV2() public {}
  
  function offerBeast(address _seller, uint256 _beastId, uint256 _priceWei) public {
      require( _seller != address(0) );
      
  }
  function acquireBeast(address _buyer, uint256 _beastId) public payable {
      require( _buyer != address(0) );
      uint256 weiAmount = msg.value;
  }
  
  function _transferBeast() internal {}
  
  function () external payable {}
}
