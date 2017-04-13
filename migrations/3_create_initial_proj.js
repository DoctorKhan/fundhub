module.exports = function(deployer) {
	deployer.then(function() {
		FundingHub.deployed().createProject('0x55928c1d15ae0c55ad452ec870f035bc1012cf51', 30, 8933899328, {gas:3000000});
	});
}
