var Legends = artifacts.require("./Legends.sol");
var SaleClockAuction = artifacts.require("./auction/SaleClockAuction.sol");
var SiringClockAuction = artifacts.require("./auction/SiringClockAuction.sol");
var GeneMagic = artifacts.require("./GeneMagic.sol");

module.exports = function(deployer, network, accounts) {
    deployer.deploy(Legends).then(function(){
        return deployer.deploy( [
            [SaleClockAuction, Legends.address, 9000],
            [SiringClockAuction, Legends.address, 9000],
            GeneMagic
        ] );
    });
};
  