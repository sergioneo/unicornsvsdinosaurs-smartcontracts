var Beasts = artifacts.require("./Beasts.sol");
var SaleClockAuction = artifacts.require("./auction/SaleClockAuction.sol");
var SiringClockAuction = artifacts.require("./auction/SiringClockAuction.sol");
var GeneMagic = artifacts.require("./GeneMagic.sol");
var SplitPayment = artifacts.require("./SplitPayment.sol");
var EggFactory = artifacts.require("./EggFactory.sol");

module.exports = function (deployer, network, accounts) {

    deployer.deploy(SplitPayment, ["0x5BAa8cF9C87ea0f0C8d1A1d4D4f9D6Cfa1eAc083", "0x47B8c01C43D8049D108Cc3979B48965bba6517b5", "0xa82e08F41e958514c74959c5876dFeA5F539b6Ca"], [40, 30, 30]).then(function () {
        deployer.deploy(EggFactory, SplitPayment.address);
    });

    deployer.deploy(GeneMagic);

    deployer.deploy(Beasts).then(function () {
        return deployer.deploy([
            [SaleClockAuction, Beasts.address, 9000],
            [SiringClockAuction, Beasts.address, 9000]
        ]);
    });
};
