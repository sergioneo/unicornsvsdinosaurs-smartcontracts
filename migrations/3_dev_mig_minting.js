var BeastMinting = artifacts.require("./BeastMinting.sol");

module.exports = function(deployer) {
  deployer.deploy(BeastMinting);
};
