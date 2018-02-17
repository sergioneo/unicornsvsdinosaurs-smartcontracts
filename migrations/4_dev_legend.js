var ERC721  = artifacts.require("./token/ERC721.sol"); 
var SaleClockAuction = artifacts.require("./auction/SaleClockAuction.sol");
var Legends = artifacts.require("./Legends.sol");

module.exports = function(deployer, network, accounts) {
  deployer.deploy(ERC721).then(function(){
    return deployer.deploy([
      [SaleClockAuction, ERC721.address, 9000],
      Legends
    ]);
  });
};
