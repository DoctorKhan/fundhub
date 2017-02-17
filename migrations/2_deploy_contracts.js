module.exports = function(deployer) {
  deployer.deploy(Project);
  deployer.autolink();
  deployer.deploy(FundingHub);
};
