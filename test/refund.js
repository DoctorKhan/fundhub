contract('Project', function(accounts) {
  it("should refund coin correctly", function() {
    var proj = Project.deployed();

    // Get initial balances of first and second account.
    var account_one = accounts[0]; // project account address
    var account_two = accounts[1]; // contributor account address

    var account_one_starting_balance; // after sending contribution
    var account_two_starting_balance; // after receiving contribution

    var account_one_ending_balance; // after receiving refund
    var account_two_ending_balance; // after sending refund

    return proj.getBalance.call(account_one).then(function(balance) {
      account_one_starting_balance = balance.toNumber();
      return proj.getBalance.call(account_two);

    }).then(function(balance) {
      account_two_starting_balance = balance.toNumber();
      return proj.refund();

    }).then(function() {
      return proj.getBalance.call(account_one);

    }).then(function(balance) {
      account_one_ending_balance = balance.toNumber();
      return proj.getBalance.call(account_two);

    }).then(function(balance) {
      account_two_ending_balance = balance.toNumber();

      // Sum of the beginning balances must equal sum of the ending balances
      assert.equal(account_one_ending_balance + account_two_ending_balance, account_one_starting_balance + account_two_starting_balance, "Amount wasn't correctly refunded");
    });
  });
});
