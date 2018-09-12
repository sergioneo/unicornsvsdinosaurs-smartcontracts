var Beasts = artifacts.require("./Beasts.sol");
var SaleClockAuction = artifacts.require("./auction/SaleClockAuction.sol");
var SiringClockAuction = artifacts.require("./auction/SiringClockAuction.sol");
var GeneMagic = artifacts.require("./GeneMagic.sol");

module.exports = function (deployer, network, accounts) {
    deployer.deploy(Beasts).then(function () {
        return deployer.deploy([
            [SaleClockAuction, Beasts.address, 9000],
            [SiringClockAuction, Beasts.address, 9000],
            GeneMagic
        ]);
    });
};
