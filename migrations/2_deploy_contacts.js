const Contracts = artifacts.require("RocketElevator.sol");

module.exports = function (deployer) {
  deployer.deploy(Contracts);
};
