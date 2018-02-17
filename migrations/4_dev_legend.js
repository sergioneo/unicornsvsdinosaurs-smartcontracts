var Legends = artifacts.require("./Legends.sol");
var SaleClockAuction = artifacts.require("./auction/SaleClockAuction.sol");

module.exports = function(deployer, network, accounts) {
  deployer.deploy(Legends).then(function(){
    return deployer.deploy( SaleClockAuction, Legends.address, 9000 );
  });
};
