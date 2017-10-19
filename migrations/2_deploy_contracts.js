var MintToken = artifacts.require("./MintToken.sol")

module.exports = function(deployer) {
  deployer.deploy(MintToken, 10000)
}
